import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'dart:convert';

import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
import 'package:test/test.dart';

final jisho = API();

List<String> getFilePaths(String dirname) {
  final currentdir = io.Directory.current.path;
  final filenames = io.Directory(path.join(currentdir, 'test', dirname)).listSync();
  return filenames.map((filename) => path.join(currentdir, 'test', dirname, filename.path)).toList();
}

void runTestCases(testCaseFiles, apiFunction) async {
  for (var testCount = 0; testCount < testCaseFiles.length; testCount++) {
    final file = await io.File(testCaseFiles[testCount]).readAsString();
    final testCase = jsonDecode(file);
    test('Test ${testCount}', () async {
      switch(apiFunction) {
        case 'searchForKanji': {
          final result = await jisho.searchForKanji(testCase.query);
          expect(result, testCase.expectedResult);
          break;
        }
        case 'searchForExamples': {
          final result = await jisho.searchForExamples(testCase.query);
          expect(result, testCase.expectedResult);
          break;
        }
        case 'scrapeForPhrase': {
          final result = await jisho.scrapeForPhrase(testCase.query);
          expect(result, testCase.expectedResult);
          break;
        }
        throw 'No API function provided';
      }
    });
  }
}

void main() {

  group('Kanji test cases', () {
    final filePaths = getFilePaths('kanji_test_cases');
    runTestCases(filePaths, 'searchForKanji');
  });

  group('Example test cases', () {
    final filePaths = getFilePaths('example_test_cases');
    runTestCases(filePaths, 'searchForExamples');
  });

  group('Phrase scrape test cases', () {
    final filePaths = getFilePaths('phrase_scrape_test_cases');
    runTestCases(filePaths, 'scrapeForPhrase');
  });

}
