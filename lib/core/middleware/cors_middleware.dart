import 'package:shelf/shelf.dart';

Middleware corsMiddleware({
  List<String>? origins,
  List<String>? methods,
  List<String>? headers,
}) {
  return (Handler innerHandler) {
    return (Request request) async {
      final allowedOrigins = origins ?? [
        'http://localhost:3000',
        'http://localhost:8080',
        'https://your-domain.com',
      ];

      final origin = request.headers['origin'];
      final isAllowed = origin != null && allowedOrigins.contains(origin);

      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'access-control-allow-origin': isAllowed ? origin! : '',
          'access-control-allow-methods': methods?.join(', ') ?? 'GET, POST, PUT, DELETE, OPTIONS',
          'access-control-allow-headers': headers?.join(', ') ?? 'Content-Type, Authorization',
          'access-control-max-age': '86400',
        });
      }

      final response = await innerHandler(request);

      // Add CORS headers to actual responses
      return response.change(headers: {
        ...response.headers,
        if (isAllowed) 'access-control-allow-origin': origin!,
        'access-control-allow-credentials': 'true',
      });
    };
  };
}