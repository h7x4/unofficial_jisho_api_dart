import 'dart:convert';
import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
final jisho = JishoApi();
final encoder = JsonEncoder.withIndent('  ');

void main() async {
  await jisho.searchForPhrase('反対').then((result) {
    print(encoder.convert(result));
  });
}