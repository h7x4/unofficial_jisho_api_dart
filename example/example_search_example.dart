import 'dart:convert' show jsonEncode;
import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
final jisho = JishoApi();

void main() async {
  await jisho.searchForExamples('日').then((result) {
    print('Jisho Uri: ' + result.uri);
    print('');

    for (int i = 0; i < 3; i++) {
      var example = result.results[i];
      print(example.kanji);
      print(example.kana);
      print(example.english);
      print(jsonEncode(example.pieces));
      print('');
    }
  });
}