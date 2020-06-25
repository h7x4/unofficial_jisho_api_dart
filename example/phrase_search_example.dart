import 'dart:convert';
import 'package:unofficial_jisho_api/api.dart' as jisho;
final encoder = JsonEncoder.withIndent('  ');

void main() async {
  await jisho.searchForPhrase('日').then((result) {
    print(encoder.convert(result));
  });
}