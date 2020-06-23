import 'dart:convert';
import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
final jisho = JishoApi();
final encoder = JsonEncoder.withIndent('  ');

void main() async {
  await jisho.scrapeForPhrase('谷').then((data) {
    print(encoder.convert(data));
  });
}