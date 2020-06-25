import 'dart:convert';
import 'package:unofficial_jisho_api/api.dart' as jisho;
final JsonEncoder encoder = JsonEncoder.withIndent('  ');

void main() async {
  await jisho.scrapeForPhrase('谷').then((data) {
    print(encoder.convert(data));
  });
}