import 'dart:io';
import 'package:path/path.dart' as path;
import 'dart:convert';

import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
import 'local_function_test_cases.dart' show test_local_functions;
import 'package:test/test.dart';

final jisho = JishoApi();

List<String> getFilePaths(String dirname) {
  final currentdir = Directory.current.path;
  final filenames = Directory(path.join(currentdir, 'test', dirname)).listSync();
  return filenames.map((filename) => path.join(currentdir, 'test', dirname, filename.path)).toList();
}

void runTestCases(List<String> testCaseFiles, String apiFunction) async {
  for (var testCount = 0; testCount < testCaseFiles.length; testCount++) {
    final file = await File(testCaseFiles[testCount]).readAsString();
    final testCase = jsonDecode(file);
    await test('Test ${testCount}', () async {
      switch(apiFunction) {
        case 'searchForKanji': {
          final result = await jisho.searchForKanji(testCase['query']);
          expect(result.toJson(), testCase['expectedResult']);
          break;
        }
        case 'searchForExamples': {
          final result = await jisho.searchForExamples(testCase['query']);
          expect(result, testCase['expectedResult']);
          break;
        }
        case 'scrapeForPhrase': {
          final result = await jisho.scrapeForPhrase(testCase['query']);
          expect(result, testCase['expectedResult']);
          break;
        }
        throw 'No API function provided';
      }
    });
  }
}

void main() async {

  await test_local_functions();

  await runTestCases(getFilePaths('kanji_test_cases'), 'searchForKanji');

  await runTestCases(getFilePaths('example_test_cases'), 'searchForExamples');

  await runTestCases(getFilePaths('phrase_scrape_test_cases'), 'scrapeForPhrase');

}
