import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

@JS('fetch')
external JSPromise<_JsResponse> _jsFetch(String url, JSAny? init);

extension type _JsResponse(JSObject _) implements JSObject {
  external bool get ok;
  external int get status;
  external JSPromise<JSString> text();
}

/// Browser / iOS Safari PWA JSON POST helper using native `window.fetch`.
Future<String> postJsonPayload({
  required Uri url,
  required Map<String, dynamic> body,
  Duration timeout = const Duration(seconds: 18),
}) async {
  // Use `.jsify()` instead of custom `@JS()` headers extension types so
  // browsers (including iOS Safari PWA) receive a valid JS RequestInit object.
  final init = <String, dynamic>{
    'method': 'POST',
    'headers': <String, String>{'Content-Type': 'application/json'},
    'body': jsonEncode(body),
  }.jsify();

  final response = await _jsFetch(url.toString(), init).toDart.timeout(timeout);
  final responseText = (await response.text().toDart.timeout(timeout)).toDart;
  if (!response.ok) {
    throw StateError('AI HTTP ${response.status}: $responseText');
  }
  return responseText;
}
