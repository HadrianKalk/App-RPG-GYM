import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

@JS('fetch')
external JSPromise<_JsResponse> _jsFetch(String url, _JsRequestInit init);

extension type _JsRequestInit._(JSObject _) implements JSObject {
  external factory _JsRequestInit({
    String method,
    _JsHeaders headers,
    String body,
  });
}

extension type _JsHeaders._(JSObject _) implements JSObject {
  external factory _JsHeaders();
  @JS('Content-Type')
  external set contentType(String value);
}

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
  final headers = _JsHeaders()..contentType = 'application/json';
  final init = _JsRequestInit(
    method: 'POST',
    headers: headers,
    body: jsonEncode(body),
  );
  final response = await _jsFetch(url.toString(), init).toDart.timeout(timeout);
  final responseText = (await response.text().toDart.timeout(timeout)).toDart;
  if (!response.ok) {
    throw StateError('AI HTTP ${response.status}: $responseText');
  }
  return responseText;
}
