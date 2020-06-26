import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:unofficial_jisho_api/api.dart';
import 'package:test/test.dart';

List<String> getFilePaths(String dirname) {
  final currentdir = Directory.current.path;
  final testDir = path.join(currentdir, 'test', dirname);
  final filenames = Directory(testDir).listSync();
  return filenames.map((filename) => path.join(testDir, filename.path)).toList();
}

List getTestCases(String directoryName) {
  final testCaseFiles = getFilePaths(directoryName);
  var result = [];

  for (var testCount = 0; testCount < testCaseFiles.length; testCount++) {
    final file = File(testCaseFiles[testCount]).readAsStringSync();
    result.add(jsonDecode(file));
  }
  return result;
}

void main() {
  group('searchForKanji', () {
    final testCases = getTestCases('kanji_test_cases');
    for (var testCase in testCases) {
      test('Query "${testCase['query']}"', () async {
        final result = await searchForKanji(testCase['query']);
        expect(jsonEncode(result), jsonEncode(testCase));
      });
    }
  });

  group('searchForExamples', () {
    final testCases = getTestCases('example_test_cases');
    for (var testCase in testCases) {
      test('Query "${testCase['query']}"', () async {
        final result = await searchForExamples(testCase['query']);
        expect(jsonEncode(result), jsonEncode(testCase));
      });
    }
  });

  group('scrapeForPhrase', () {
    final testCases = getTestCases('phrase_scrape_test_cases');
    for (var testCase in testCases) {
      test('Query "${testCase['query']}"', () async {
        final result = await scrapeForPhrase(testCase['query']);
        expect(jsonEncode(result), jsonEncode(testCase));
      });
    }
  });
}