import 'dart:convert';
import 'dart:io';

/// Native (`dart:io`) JSON POST helper for Windows, macOS, Linux, iOS, Android.
Future<String> postJsonPayload({
  required Uri url,
  required Map<String, dynamic> body,
  Duration timeout = const Duration(seconds: 18),
}) async {
  final client = HttpClient()..connectionTimeout = timeout;
  try {
    final req = await client.postUrl(url).timeout(timeout);
    req.headers.contentType = ContentType.json;
    req.write(jsonEncode(body));
    final res = await req.close().timeout(timeout);
    final responseText = await res.transform(utf8.decoder).join().timeout(timeout);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw HttpException(
        'AI HTTP ${res.statusCode}: $responseText',
        uri: url,
      );
    }
    return responseText;
  } finally {
    client.close(force: true);
  }
}
