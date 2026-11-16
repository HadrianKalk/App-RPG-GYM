import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/services.dart';

@JS('document.createElement')
external _JsElement _createElement(String tag);

@JS('document.body.appendChild')
external void _appendToBody(_JsElement node);

extension type _JsElement(JSObject _) implements JSObject {
  external set href(String value);
  external set download(String value);
  external void click();
  external void remove();
}

/// Copies the backup JSON to clipboard AND triggers a `.json` file download in
/// web browsers / iOS Safari PWA.
Future<bool> exportBackupPayload({
  required String filename,
  required String jsonContent,
}) async {
  await Clipboard.setData(ClipboardData(text: jsonContent));
  try {
    final uri = Uri.dataFromString(
      jsonContent,
      mimeType: 'application/json',
      encoding: utf8,
    );
    final anchor = _createElement('a')
      ..href = uri.toString()
      ..download = filename;
    _appendToBody(anchor);
    anchor.click();
    anchor.remove();
    return true;
  } catch (_) {
    return false;
  }
}
