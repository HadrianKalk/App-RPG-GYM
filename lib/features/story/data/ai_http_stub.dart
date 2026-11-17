/// Cross-platform minimal HTTP JSON POST transport (stub fallback).
Future<String> postJsonPayload({
  required Uri url,
  required Map<String, dynamic> body,
  Duration timeout = const Duration(seconds: 18),
}) {
  throw UnsupportedError('HTTP transport is not available on this platform.');
}
