import 'dart:convert';
import 'package:unofficial_jisho_api/api.dart' as jisho;
final JsonEncoder encoder = JsonEncoder.withIndent('  ');

void main() {
  jisho.searchForPhrase('日').then((result) {
  // jisho.searchForPhrase('する').then((result) {
    print(encoder.convert(result));
  });
}