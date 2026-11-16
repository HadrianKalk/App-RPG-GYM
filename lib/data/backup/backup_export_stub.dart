import 'package:flutter/services.dart';

/// Copies the backup JSON to the system clipboard on non-web platforms.
Future<bool> exportBackupPayload({
  required String filename,
  required String jsonContent,
}) async {
  await Clipboard.setData(ClipboardData(text: jsonContent));
  return false; // No browser download triggered.
}
