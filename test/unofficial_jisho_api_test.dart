import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:unofficial_jisho_api/api.dart';

List<String> getFilePaths(String dirname) {
  final currentdir = Directory.current.path;
  final testDir = path.join(currentdir, 'test', dirname);
  final filenames = Directory(testDir).listSync();
  return filenames
      .map((filename) => path.join(testDir, filename.path))
      .toList();
}

List<dynamic> getTestCases(String directoryName) {
  final testCaseFiles = getFilePaths(directoryName);
  final result = <dynamic>[];

  for (var testCount = 0; testCount < testCaseFiles.length; testCount++) {
    final file = File(testCaseFiles[testCount]).readAsStringSync();
    result.add(jsonDecode(file));
  }
  return result;
}

void main() {
  group('searchForKanji', () {
    final testCases = getTestCases('kanji_test_cases')
        .map((e) => KanjiResult.fromJson(e))
        .toList();
    for (var testCase in testCases) {
      test('Query "${testCase.query}"', () async {
        final result = await searchForKanji(testCase.query);
        expect(result, testCase);
      });
    }
  });

  group('searchForExamples', () {
    final testCases = getTestCases('example_test_cases')
        .map((e) => ExampleResults.fromJson(e))
        .toList();
    for (var testCase in testCases) {
      test('Query "${testCase.query}"', () async {
        final result = await searchForExamples(testCase.query);
        expect(result, testCase);
      });
    }
  });

  group('scrapeForPhrase', () {
    final testCases = getTestCases('phrase_scrape_test_cases')
        .map((e) => PhrasePageScrapeResult.fromJson(e))
        .toList();
    for (var testCase in testCases) {
      test('Query "${testCase.query}"', () async {
        final result = await scrapeForPhrase(testCase.query);
        expect(result, testCase);
      });
    }
  });

  group('equatable', () {
    // searchForExample returns random results, not stable for testing.
    // I will assume it works if all the other works, and rather wait for
    // reports in Github issues if something is broken.
    final kanjiSearch = [searchForKanji('関'), searchForKanji('関')];
    final phraseScrape = [scrapeForPhrase('関係'), scrapeForPhrase('関係')];
    final phraseSearch = [searchForPhrase('関係'), searchForPhrase('関係')];
    for (var testCase in [kanjiSearch, phraseScrape, phraseSearch]) {
      test('Equate ${testCase[0].runtimeType}' , () async {
        expect(await testCase[0], await testCase[1]);
      });
    }
  });

}
