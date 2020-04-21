import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';
import 'package:test/test.dart';

import 'package:http/http.dart' as http;

void test_local_functions() async {


/* KANJI SEARCH FUNCTION TESTS START */

  test('removeNewLines', () {
    final result = removeNewlines('Line \nwith\r\n Newlines and spaces\n');
    expect(result, 'Line with Newlines and spaces');
  });

  test('uriForKanjiSearch', () {
    final result = uriForKanjiSearch('時');
    expect(result, 'https://jisho.org/search/%E6%99%82%23kanji');
  });

  test('getUriForStrokeOrderDiagram', () {
    final result = getUriForStrokeOrderDiagram('時');
    expect(result, 'https://classic.jisho.org/static/images/stroke_diagrams/26178_frames.png');
  });

  test('uriForPhraseSearch', () {
    final result = uriForPhraseSearch('時間');
    expect(result, 'https://jisho.org/api/v1/search/words?keyword=%E6%99%82%E9%96%93');
  });

  final kanjiPage = (await http.get('https://jisho.org/search/%E6%99%82%23kanji')).body;

  test('containsKanjiGlyph', () {
    final result = containsKanjiGlyph(kanjiPage, '時');
    expect(result, true);
  });

  test('getStringBetweenIndicies', () {
    final result = getStringBetweenIndicies('String\n\rwith\nNewlines', 3, 9);
    expect(result, 'ingw');
  });

  test('getStringBetweenStrings', () {
    const data = 'STArT I want this string END';
    final result = getStringBetweenStrings(data, 'STArT', 'END');
    expect(result, ' I want this string ');
  });

  test('getIntBetweenStrings', () {
    final result = getIntBetweenStrings(kanjiPage, '<strong>', '</strong> strokes');
    expect(result, 10);
  });

  test('getAllGlobalGroupMatches', () {

  });

  test('parseAnchorsToArray', () {

  });

  test('getYomi', () {
    final result = getYomi(kanjiPage, 'On');
    expect(result, ['ジ']);

  });

  test('getKunyomi', () {
    final result = getKunyomi(kanjiPage);
    expect(result, ['とき', '-どき']);
  });

  test('getOnyomi', () {
    final result = getOnyomi(kanjiPage);
    expect(result, ['ジ']);
  });

  test('getYomiExamples', () {
    final result = getYomiExamples(kanjiPage, 'Kun');
    expect(result, ['ジ']); //FIX
  });

  test('getOnomiExamples', () {
    final result = getOnyomiExamples(kanjiPage);
    expect(result, ['ジ']); //FIX
  });

  test('getKunyomiExamples', () {
    final result = getKunyomiExamples(kanjiPage);
    expect(result, ['ジ']); //FIX
  });

  test('getRadical', () {
    final result = getRadical(kanjiPage);
    expect(result, ['ジ']); //FIX
  });

  test('getParts', () {
    final result = getParts(kanjiPage);
    expect(result, ['土', '寸', '日']);
  });

  test('getSvgUri', () {
    final result = getSvgUri(kanjiPage);
    expect(result, 'http://d1w6u4xc3l95km.cloudfront.net/kanji-2015-03/06642.svg');
  });

  test('getGifUri', () {
    final result = getGifUri(kanjiPage);
    expect(result, 'https://raw.githubusercontent.com/mistval/kanji_images/master/gifs/3c.gif');
  });

  test('getNewspaperFrequencyRank', () {
    final result = getNewspaperFrequencyRank(kanjiPage);
    expect(result, 16); //This might change
  });

  test('parseKanjiPageData', () {

  });

  /* KANJI SEARCH FUNCTION TESTS END */

}