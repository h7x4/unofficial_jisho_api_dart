import 'dart:io';
import 'package:path/path.dart' as path;
import 'dart:convert';

import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';

final jisho = JishoApi();
final encoder = JsonEncoder.withIndent('  ');
final currentdir = Directory.current.path;

void writeCases(Function apiFunction, String folderName, List<String> queries) async {
  final dir = path.join(currentdir, 'test', folderName);

  for (var testCount = 0; testCount < queries.length; testCount++) {
    final result = await apiFunction(queries[testCount]);
    final content = encoder.convert(result);
    final filePath = path.join(dir, '${testCount}.json');

    await File(filePath).writeAsString(content);
  }
}

const kanjiQueries = ['車', '家', '楽', '極上', '贄', 'ネガティブ', 'wegmwrlgkrgmg', '水'];
const exampleQueries = ['車', '日本人', '彼＊叩く', '皆', 'ネガティブ', 'grlgmregmneriireg'];
const phraseQueries = ['車', '日本人', '皆', 'ネガティブ', 'grlgmregmneriireg'];

void main() async {
  await writeCases(jisho.searchForKanji, 'kanji_test_cases', kanjiQueries);
  await writeCases(jisho.searchForExamples, 'example_test_cases', exampleQueries);
  await writeCases(jisho.scrapeForPhrase, 'phrase_scrape_test_cases', phraseQueries);
}
