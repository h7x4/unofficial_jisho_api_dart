import 'package:unofficial_jisho_api/src/objects.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:html_unescape/html_unescape.dart' as html_entities;
import 'dart:convert';

final htmlUnescape = html_entities.HtmlUnescape();

// TODO: Put public facing types in this file.

const String JISHO_API = 'http://jisho.org/api/v1/search/words';
const String SCRAPE_BASE_URI = 'http://jisho.org/search/';
const String STROKE_ORDER_DIAGRAM_BASE_URI = 'http://classic.jisho.org/static/images/stroke_diagrams/';

/* KANJI SEARCH FUNCTIONS START */

const String ONYOMI_LOCATOR_SYMBOL = 'On';
const KUNYOMI_LOCATOR_SYMBOL = 'Kun';

String removeNewlines(String str) {
  return str.replaceAll(RegExp(r'(?:\r|\n)') , '').trim();
}

String uriForKanjiSearch(String kanji) {
  return '${SCRAPE_BASE_URI}${Uri.encodeComponent(kanji)}%23kanji';
}

String getUriForStrokeOrderDiagram(String kanji) {
  return '${STROKE_ORDER_DIAGRAM_BASE_URI}${kanji.codeUnitAt(0)}_frames.png';
}

String uriForPhraseSearch(String phrase) {
  return '${JISHO_API}?keyword=${Uri.encodeComponent(phrase)}';
}

bool containsKanjiGlyph(String pageHtml, String kanji) {
  final kanjiGlyphToken = '<h1 class="character" data-area-name="print" lang="ja">${kanji}</h1>';
  return pageHtml.contains(kanjiGlyphToken);
}

String getStringBetweenIndicies(String data, int startIndex, int endIndex) {
  final result = data.substring(startIndex, endIndex);
  return removeNewlines(result).trim();
}

String getStringBetweenStrings(String data, String startString, String endString) {
  final regex = RegExp('${RegExp.escape(startString)}(.*?)${RegExp.escape(endString)}', dotAll: true);
  final match = regex.allMatches(data).toList(); //TODO: Something wrong here

  return match.isNotEmpty ? match[0].group(1).toString() : null;
}

int getIntBetweenStrings(String pageHtml, String startString, String endString) {
  final  stringBetweenStrings = getStringBetweenStrings(pageHtml, startString, endString);
  return int.parse(stringBetweenStrings);
}

List<String> getAllGlobalGroupMatches(String str, RegExp regex) {
  var regexResults = regex.allMatches(str).toList();
  List<String> results = [];
  for (var match in regexResults) {
    results.add(match.group(1));
  }

  return results;
}

List<String> parseAnchorsToArray(String str) {
  final regex = RegExp(r'<a href=".*?">(.*?)<\/a>');
  return getAllGlobalGroupMatches(str, regex);
}

List<String> getYomi(String pageHtml, String yomiLocatorSymbol) {
  final yomiSection = getStringBetweenStrings(pageHtml, '<dt>${yomiLocatorSymbol}:</dt>', '</dl>');
  return parseAnchorsToArray(yomiSection ?? '');
}

List<String> getKunyomi(String pageHtml) {
  return getYomi(pageHtml, KUNYOMI_LOCATOR_SYMBOL);
}

List<String> getOnyomi(String pageHtml) {
  return getYomi(pageHtml, ONYOMI_LOCATOR_SYMBOL);
}

List<YomiExample> getYomiExamples(String pageHtml, String yomiLocatorSymbol) {
  final locatorString = '<h2>${yomiLocatorSymbol} reading compounds</h2>';
  final exampleSection = getStringBetweenStrings(pageHtml, locatorString, '</ul>');
  if (exampleSection==null) {
    return null;
  }

  final regex = RegExp(r'<li>(.*?)<\/li>', dotAll: true);
  final regexResults = getAllGlobalGroupMatches(exampleSection, regex).map((s) => s.trim());

  final examples = regexResults.map((regexResult) {
    final examplesLines = regexResult.split('\n').map((s) => s.trim()).toList();
    return YomiExample(
      example: examplesLines[0],
      reading: examplesLines[1].replaceAll('【', '').replaceAll('】', ''),
      meaning: htmlUnescape.convert(examplesLines[2]),
    );
  });

  return examples.toList();
}

List<YomiExample> getOnyomiExamples(String pageHtml) {
  return getYomiExamples(pageHtml, ONYOMI_LOCATOR_SYMBOL);
}

List<YomiExample> getKunyomiExamples(String pageHtml) {
  return getYomiExamples(pageHtml, KUNYOMI_LOCATOR_SYMBOL);
}

Radical getRadical(String pageHtml) {
  const radicalMeaningStartString = '<span class="radical_meaning">';
  const radicalMeaningEndString = '</span>';

  var radicalMeaning = getStringBetweenStrings(
    pageHtml,
    radicalMeaningStartString,
    radicalMeaningEndString,
  ).trim();

  if (radicalMeaning!=null) {
    final radicalMeaningStartIndex = pageHtml.indexOf(radicalMeaningStartString);

    final radicalMeaningEndIndex = pageHtml.indexOf(
      radicalMeaningEndString,
      radicalMeaningStartIndex,
    );

    final radicalSymbolStartIndex = radicalMeaningEndIndex + radicalMeaningEndString.length;
    const radicalSymbolEndString = '</span>';
    final radicalSymbolEndIndex = pageHtml.indexOf(radicalSymbolEndString, radicalSymbolStartIndex);

    final radicalSymbolsString = getStringBetweenIndicies(
      pageHtml,
      radicalSymbolStartIndex,
      radicalSymbolEndIndex,
    );

    if (radicalSymbolsString.length > 1) {
      final radicalForms = radicalSymbolsString
        .substring(1)
        .replaceAll('(', '')
        .replaceAll(')', '')
        .trim()
        .split(', ');

      return Radical(
        symbol: radicalSymbolsString[0],
        forms: radicalForms,
        meaning: radicalMeaning
      );
    }

    return Radical (
      symbol: radicalSymbolsString,
      meaning: radicalMeaning
    );
  }

  return null;
}

List<String> getParts(String pageHtml) {
  const partsSectionStartString = '<dt>Parts:</dt>';
  const partsSectionEndString = '</dl>';

  final partsSection = getStringBetweenStrings(
    pageHtml,
    partsSectionStartString,
    partsSectionEndString,
  );

  var result = parseAnchorsToArray(partsSection);
  result.sort();

  return (result);
}

String getSvgUri(String pageHtml) {
  var svgRegex = RegExp('\/\/.*?.cloudfront.net\/.*?.svg');
  final regexResult = svgRegex.firstMatch(pageHtml).group(0).toString();
  return regexResult.isNotEmpty ? 'http:${regexResult}' : null;
}

String getGifUri(String kanji) {
  final unicodeString = kanji.codeUnitAt(0).toRadixString(16);
  final fileName = '${unicodeString}.gif';
  final animationUri = 'https://raw.githubusercontent.com/mistval/kanji_images/master/gifs/${fileName}';

  return animationUri;
}

int getNewspaperFrequencyRank(String pageHtml) {
  final frequencySection = getStringBetweenStrings(pageHtml, '<div class="frequency">', '</div>');
  return frequencySection.isNotEmpty ? int.parse(getStringBetweenStrings(frequencySection, '<strong>', '</strong>')) : null;
}

KanjiResult parseKanjiPageData(String pageHtml, String kanji) {
  final result = KanjiResult();
  result.query = kanji;
  result.found = containsKanjiGlyph(pageHtml, kanji);
  if (result.found==false) {
    return result;
  }

  result.taughtIn = getStringBetweenStrings(pageHtml, 'taught in <strong>', '</strong>');
  result.jlptLevel = getStringBetweenStrings(pageHtml, 'JLPT level <strong>', '</strong>');
  result.newspaperFrequencyRank = getNewspaperFrequencyRank(pageHtml);
  result.strokeCount = getIntBetweenStrings(pageHtml, '<strong>', '</strong> strokes');
  result.meaning = htmlUnescape.convert(removeNewlines(getStringBetweenStrings(pageHtml, '<div class="kanji-details__main-meanings">', '</div>')).trim());
  result.kunyomi = getKunyomi(pageHtml);
  result.onyomi = getOnyomi(pageHtml);
  result.onyomiExamples = getOnyomiExamples(pageHtml);
  result.kunyomiExamples = getKunyomiExamples(pageHtml);
  result.radical = getRadical(pageHtml);
  result.parts = getParts(pageHtml);
  result.strokeOrderDiagramUri = getUriForStrokeOrderDiagram(kanji);
  result.strokeOrderSvgUri = getSvgUri(pageHtml);
  result.strokeOrderGifUri = getGifUri(kanji);
  result.uri = uriForKanjiSearch(kanji);
  return result;
}

/* KANJI SEARCH FUNCTIONS END */

/* EXAMPLE SEARCH FUNCTIONS START */

RegExp kanjiRegex = RegExp(r'[\u4e00-\u9faf\u3400-\u4dbf]');

String uriForExampleSearch(String phrase) {
  return '${SCRAPE_BASE_URI}${Uri.encodeComponent(phrase)}%23sentences';
}

ExampleResultData getKanjiAndKana(div) {
  final ul = div.find('ul').eq(0);
  final contents = ul.contents();

  var kanji = '';
  var kana = '';
  for (var i = 0; i < contents.length; i += 1) {
    final content = contents.eq(i);
    if (content[0].name == 'li') {
      final li = content;
      final furigana = li.find('.furigana').text();
      final unlifted = li.find('.unlinked').text();

      if (furigana) {
        kanji += unlifted;
        kana += furigana;

        final kanaEnding = [];
        for (var j = unlifted.length - 1; j > 0; j -= 1) {
          if (!unlifted[j].match(kanjiRegex)) {
            kanaEnding.add(unlifted[j]);
          } else {
            break;
          }
        }

        kana += kanaEnding.reversed.join('');
      } else {
        kanji += unlifted;
        kana += unlifted;
      }
    } else {
      final text = content.text().trim();
      if (text) {
        kanji += text;
        kana += text;
      }
    }
  }

  return ExampleResultData(
    kanji: kanji,
    kana: kana,
  );
}

List<ExampleSentencePiece> getPieces(sentenceElement) {
  final pieceElements = sentenceElement.find('li.clearfix');
  final pieces = [];
  for (var pieceIndex = 0; pieceIndex < pieceElements.length; pieceIndex += 1) {
    final pieceElement = pieceElements.eq(pieceIndex);
    pieces.add(ExampleSentencePiece(
      lifted: pieceElement.children('.furigana').text(),
      unlifted: pieceElement.children('.unlinked').text(),
    ));
  }

  return pieces;
}

ExampleResultData parseExampleDiv(div) {
  final result = getKanjiAndKana(div);
  result.english = div.find('.english').text();
  result.pieces = getPieces(div);

  return result;
}

ExampleResults parseExamplePageData(String pageHtml, String phrase) {
  final document = xml.parse(pageHtml);
  final divs = document.descendants.where((node) => node.attributes[0].value == 'sentence_content').toList();

  final results = divs.map((div) => parseExampleDiv(div));

  return ExampleResults(
    query: phrase,
    found: results.isNotEmpty,
    results: results,
    uri: uriForExampleSearch(phrase),
    phrase: phrase,
  );
}

/* EXAMPLE SEARCH FUNCTIONS END */

/* PHRASE SCRAPE FUNCTIONS START */

List<String> getTags(document) {
  final tags = [];
  final tagElements = document.descendants.where((node) => node.attributes[0].value == 'concept_light-tag').toList();

  for (var i = 0; i < tagElements.length; i += 1) {
    final tagText = tagElements.eq(i).text();
    tags.add(tagText);
  }

  return tags;
}

PhrasePageScrapeResult getMeaningsOtherFormsAndNotes(document) {
  final returnValues = PhrasePageScrapeResult( otherForms: [], notes: [] );

  //TODO: Fix
  // const meaningsWrapper = $('#page_container > div > div > article > div > div.concept_light-meanings.medium-9.columns > div');
  final meaningsWrapper = document.descendants.where((node) => node.attributes[0].value == 'page_container').toList();



  final meaningsChildren = meaningsWrapper.children();
  final meanings = [];

  var mostRecentWordTypes = [];
  for (var meaningIndex = 0; meaningIndex < meaningsChildren.length; meaningIndex += 1) {
    final child = meaningsChildren.eq(meaningIndex);
    if (child.hasClass('meaning-tags')) {
      mostRecentWordTypes = child.text().split(',').map((s) => s.trim().toLowerCase());
    } else if (mostRecentWordTypes[0] == 'other forms') {
      returnValues.otherForms = child.text().split('、')
        .map((s) => s.replaceAll('【', '').replaceAll('】', '').split(' '))
        .map((a) => (ExampleResultData( kanji: a[0], kana: a[1] )));
    } else if (mostRecentWordTypes[0] == 'notes') {
      returnValues.notes = child.text().split('\n');
    } else {
      final meaning = child.find('.meaning-meaning').text();
      final meaningAbstract = child.find('.meaning-abstract')
        .find('a')
        .remove()
        .end()
        .text();

      final supplemental = child.find('.supplemental_info').text().split(',')
        .map((s) => s.trim())
        .filter((s) => s);

      final seeAlsoTerms = [];
      for (var i = supplemental.length - 1; i >= 0; i -= 1) {
        final supplementalEntry = supplemental[i];
        if (supplementalEntry.startsWith('See also')) {
          seeAlsoTerms.add(supplementalEntry.replaceAll('See also ', ''));
          supplemental.splice(i, 1);
        }
      }

      final sentences = [];
      final sentenceElements = child.find('.sentences').children('.sentence');

      for (var sentenceIndex = 0; sentenceIndex < sentenceElements.length; sentenceIndex += 1) {
        final sentenceElement = sentenceElements.eq(sentenceIndex);

        final english = sentenceElement.find('.english').text();
        final pieces = getPieces(sentenceElement);

        final japanese = sentenceElement
          .find('.english').remove().end()
          .find('.furigana')
          .remove()
          .end()
          .text();

        sentences.add(PhraseScrapeSentence(english: english, japanese: japanese, pieces: pieces));
      }

      meanings.add(PhraseScrapeMeaning(
        seeAlsoTerms: seeAlsoTerms,
        sentences: sentences,
        definition: meaning,
        supplemental: supplemental,
        definitionAbstract: meaningAbstract,
        tags: mostRecentWordTypes,
      ));
    }
  }

  returnValues.meanings = meanings;

  return returnValues;
}

String uriForPhraseScrape(searchTerm) {
  return 'https://jisho.org/word/${Uri.encodeComponent(searchTerm)}';
}

PhrasePageScrapeResult parsePhrasePageData(pageHtml, query) {
  final document = xml.parse(pageHtml);
  final result = getMeaningsOtherFormsAndNotes(document);

    result.found = true;
    result.query = query;
    result.uri = uriForPhraseScrape(query);
    result.tags = getTags(document);
    // result.meanings = meanings;
    // result.otherForms = forms;
    // result.notes = notes;

  return result;
}

class JishoApi {

  /// Query the official Jisho API for a word or phrase
  /// 
  /// See [here]{@link https://jisho.org/forum/54fefc1f6e73340b1f160000-is-there-any-kind-of-search-api}
  /// for discussion about the official API.
  /// @param {string} phrase The search term to search for.
  /// @returns {Object} The response data from the official Jisho.org API. Its format is somewhat
  ///   complex and is not documented, so put on your trial-and-error hat.
  /// @async
  searchForPhrase(String phrase) {
    final uri = uriForPhraseSearch(phrase);
    return http.get(uri).then((response) => jsonDecode(response.body).data);
  }

  /// Scrape the word page for a word/phrase.
  /// 
  /// This allows you to get some information that isn't provided by the official API, such as
  /// part-of-speech and JLPT level. However, the official API should be preferred
  /// if it has the information you need. This function scrapes https://jisho.org/word/XXX.
  /// In general, you'll want to include kanji in your search term, for example 掛かる
  /// instead of かかる (no results).
  /// @param {string} phrase The search term to search for.
  /// @returns {PhrasePageScrapeResult} Information about the searched query.
  /// @async
  Future<PhrasePageScrapeResult> scrapeForPhrase(String phrase) async {
    final uri = uriForPhraseScrape(phrase);
    try {
      final response = await http.get(uri);
      return parsePhrasePageData(response.body, phrase);
    } catch (err) {
      if (err.response.status == 404) {
        return PhrasePageScrapeResult(
          query: phrase,
          found: false,
        );
      }

      throw err;
    }
  }

  /// Scrape Jisho.org for information about a kanji character.
  /// @param {string} kanji The kanji to search for.
  /// @returns {KanjiResult} Information about the searched kanji.
  /// @async
  Future<KanjiResult> searchForKanji(String kanji) {
    final uri = uriForKanjiSearch(kanji);
    return http.get(uri).then((response) => parseKanjiPageData(response.body, kanji));
  }

  /// Scrape Jisho.org for examples.
  /// @param {string} phrase The word or phrase to search for.
  /// @returns {ExampleResults}
  /// @async
  Future<ExampleResults> searchForExamples(String phrase) {
    final uri = uriForExampleSearch(phrase);
    return http.get(uri).then((response) => parseExamplePageData(response.body, phrase));
  }
}