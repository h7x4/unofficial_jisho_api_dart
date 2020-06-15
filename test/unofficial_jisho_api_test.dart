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

void runTestCases(List<String> testCaseFiles, Function apiFunction) async {
  for (var testCount = 0; testCount < testCaseFiles.length; testCount++) {
    final file = await File(testCaseFiles[testCount]).readAsString();
    final testCase = jsonDecode(file);
    await test('Test ${testCount}', () async {
      final result = await apiFunction(testCase['query']);
      expect(jsonEncode(result), jsonEncode(testCase['expectedResult']));
    });
  }
}

void main() async {

  await test_local_functions();

  await runTestCases(getFilePaths('kanji_test_cases'), jisho.searchForKanji);
  await runTestCases(getFilePaths('example_test_cases'), jisho.searchForExamples);
  await runTestCases(getFilePaths('phrase_scrape_test_cases'), jisho.scrapeForPhrase);

}
