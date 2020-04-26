import 'package:unofficial_jisho_api/src/objects.dart';
import 'package:unofficial_jisho_api/unofficial_jisho_api.dart';

import 'package:test/test.dart';
import 'dart:convert';
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
    const htmlCode = 
    '''
    <div class="test">
      <p>
        <a href="https://test.test">Hello</a>
      </p>
      <a href="//xyz">Hi</a>
      <span>
        <p>
          <a href="">How are you doing</a>
        </p>
      </span>
    </div>
    ''';

    final result = parseAnchorsToArray(htmlCode);
    expect(result, [
      'Hello', 'Hi', 'How are you doing']);
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
    final result = getYomiExamples(kanjiPage, 'On');
    expect(
      json.encode(result),
      json.encode([
        YomiExample(
          example: '時',
          reading: 'ジ',
          meaning: '''hour, o'clock, (specified) time, when ..., during ...'''
        ),
        YomiExample(
          example: '時価',
          reading: 'ジカ',
          meaning: 'current value, price, market value'
        ),
        YomiExample(
          example: '零時',
          reading: 'レイジ',
          meaning: '''twelve o'clock, midnight, noon'''
        ),
        YomiExample(
          example: '平時',
          reading: 'ヘイジ',
          meaning: 'peacetime, time of peace, ordinary times, normal times'
        ),
      ])
    );
  });

  test('getOnyomiExamples', () {
    final result = getOnyomiExamples(kanjiPage);
    expect(
      json.encode(result), 
      json.encode([
        YomiExample(
          example: '時',
          reading: 'ジ',
          meaning: '''hour, o'clock, (specified) time, when ..., during ...'''
        ),
        YomiExample(
          example: '時価',
          reading: 'ジカ',
          meaning: 'current value, price, market value'
        ),
        YomiExample(
          example: '零時',
          reading: 'レイジ',
          meaning: '''twelve o'clock, midnight, noon'''
        ),
        YomiExample(
          example: '平時',
          reading: 'ヘイジ',
          meaning: 'peacetime, time of peace, ordinary times, normal times'
        ),
      ])
    );
  });

  test('getKunyomiExamples', () {
    final result = getKunyomiExamples(kanjiPage);
    expect(
      json.encode(result), 
      json.encode([
        YomiExample(
          example: '時',
          reading: 'とき',
          meaning: 'time, hour, moment, occasion, case, chance, opportunity, season, the times, the age, the day, tense'
        ),
        YomiExample(
          example: '時折',
          reading: 'ときおり',
          meaning: 'sometimes'
        ),
        YomiExample(
          example: '切り替え時',
          reading: 'きりかえとき',
          meaning: 'time to switch over, response time'
        ),
        YomiExample(
          example: '逢魔が時',
          reading: 'おうまがとき',
          meaning: '''twilight, time for disasters (similar to 'the witching hour' but not midnight)'''
        ),
      ])
    );
  });

  test('getRadical', () {
    final result = getRadical(kanjiPage);
    expect(
      json.encode(result),
      json.encode(Radical(
        symbol: '日',
        meaning: 'sun, day'
      ))
    );
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
    expect(result, 16);
  });

  test('parseKanjiPageData', () {
    final result = parseKanjiPageData(kanjiPage, '時');

    final expectedResult = KanjiResult();
    expectedResult.query = '時';
    expectedResult.found = true;
    expectedResult.taughtIn = 'grade 2';
    expectedResult.jlptLevel = 'N5';
    expectedResult.newspaperFrequencyRank = 16;
    expectedResult.strokeCount = 10;
    expectedResult.meaning = 'time, hour';
    expectedResult.kunyomi = ['とき', '-どき'];
    expectedResult.onyomi = ['ジ'];
    expectedResult.onyomiExamples = 
    [
      YomiExample(
        example: '時',
        reading: 'ジ',
        meaning: '''hour, o'clock, (specified) time, when ..., during ...'''
      ),
      YomiExample(
        example: '時価',
        reading: 'ジカ',
        meaning: 'current value, price, market value'
      ),
      YomiExample(
        example: '零時',
        reading: 'レイジ',
        meaning: '''twelve o'clock, midnight, noon'''
      ),
      YomiExample(
        example: '平時',
        reading: 'ヘイジ',
        meaning: 'peacetime, time of peace, ordinary times, normal times'
      ),
    ];
    expectedResult.kunyomiExamples = 
    [
      YomiExample(
        example: '時',
        reading: 'とき',
        meaning: 'time, hour, moment, occasion, case, chance, opportunity, season, the times, the age, the day, tense'
      ),
      YomiExample(
        example: '時折',
        reading: 'ときおり',
        meaning: 'sometimes'
      ),
      YomiExample(
        example: '切り替え時',
        reading: 'きりかえとき',
        meaning: 'time to switch over, response time'
      ),
      YomiExample(
        example: '逢魔が時',
        reading: 'おうまがとき',
        meaning: '''twilight, time for disasters (similar to 'the witching hour' but not midnight)'''
      ),
    ];
    expectedResult.radical = 
    Radical(
      symbol: '日',
      meaning: 'sun, day'
    );
    expectedResult.parts = ['土', '寸', '日'];
    expectedResult.strokeOrderDiagramUri = 'https://classic.jisho.org/static/images/stroke_diagrams/26178_frames.png';
    expectedResult.strokeOrderSvgUri = 'http://d1w6u4xc3l95km.cloudfront.net/kanji-2015-03/06642.svg';
    expectedResult.strokeOrderGifUri = 'https://raw.githubusercontent.com/mistval/kanji_images/master/gifs/3c.gif';
    expectedResult.uri = 'https://jisho.org/search/%E6%99%82%23kanji';

    expect(
      json.encode(result),
      json.encode(expectedResult)
      );
  });

  /* KANJI SEARCH FUNCTION TESTS END */

}