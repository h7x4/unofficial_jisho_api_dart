import 'package:html/dom.dart';
import 'package:html/parser.dart';

import './example_search.dart' show getPieces;
import './objects.dart';
import './scraping.dart';

List<String> _getTags(Document document) {
  final tagElements = document.querySelectorAll('.concept_light-tag');
  final tags = tagElements.map((tagElement) => tagElement.text).toList();
  return tags;
}

List<String> _getMostRecentWordTypes(Element child) {
  return child.text.split(',').map((s) => s.trim().toLowerCase()).toList();
}

List<KanjiKanaPair> _getOtherForms(Element child) {
  return child.text
      .split('、')
      .map((s) => s.replaceAll('【', '').replaceAll('】', '').split(' '))
      .map((a) => (KanjiKanaPair(
            kanji: a[0],
            kana: (a.length == 2) ? a[1] : null,
          )))
      .toList();
}

List<String> _getNotes(Element child) => child.text.split('\n');

String _getMeaningString(Element child) {
  final meaning = assertNotNull(
    variable: child.querySelector('.meaning-meaning')?.text,
    errorMessage:
        "Could not parse meaning div. Is the provided document corrupt, or has Jisho been updated?",
  );

  return meaning;
}

String? _getMeaningAbstract(Element child) {
  final meaningAbstract = child.querySelector('.meaning-abstract');
  if (meaningAbstract == null) return null;

  for (var element in meaningAbstract.querySelectorAll('a')) {
    element.remove();
  }

  return child.querySelector('.meaning-abstract')?.text;
}

List<String> _getSupplemental(Element child) {
  final supplemental = child.querySelector('.supplemental_info');
  if (supplemental == null) return [];
  return supplemental.text.split(',').map((s) => s.trim()).toList();
}

List<String> _getSeeAlsoTerms(List<String> supplemental) {
  // if (supplemental == null) return [];

  final seeAlsoTerms = <String>[];
  for (var i = supplemental.length - 1; i >= 0; i -= 1) {
    final supplementalEntry = supplemental[i];
    if (supplementalEntry.startsWith('See also')) {
      seeAlsoTerms.add(supplementalEntry.replaceAll('See also ', ''));
      supplemental.removeAt(i);
    }
  }
  return seeAlsoTerms;
}

PhraseScrapeSentence _getSentence(Element sentenceElement) {
  final english = assertNotNull(
    variable: sentenceElement.querySelector('.english')?.text,
    errorMessage:
        'Could not parse sentence translation. Is the provided document corrupt, or has Jisho been updated?',
  );

  final pieces = getPieces(sentenceElement);

  sentenceElement.querySelector('.english')?.remove();

  for (var element in sentenceElement.children[0].children) {
    element.querySelector('.furigana')?.remove();
  }

  final japanese = sentenceElement.text;
  return PhraseScrapeSentence(
    english: english,
    japanese: japanese,
    pieces: pieces,
  );
}

List<PhraseScrapeSentence> _getSentences(Element child) {
  final sentenceElements =
      child.querySelector('.sentences')?.querySelectorAll('.sentence');
  if (sentenceElements == null) return [];

  return sentenceElements.map(_getSentence).toList();
}

PhraseScrapeMeaning _getMeaning(Element child) {
  final meaning = _getMeaningString(child);
  final meaningAbstract = _getMeaningAbstract(child);
  final supplemental = _getSupplemental(child);
  final seeAlsoTerms = _getSeeAlsoTerms(supplemental);
  final sentences = _getSentences(child);

  return PhraseScrapeMeaning(
    seeAlsoTerms: seeAlsoTerms,
    sentences: sentences,
    definition: meaning,
    supplemental: supplemental,
    definitionAbstract: meaningAbstract,
    // tags: mostRecentWordTypes ?? [],
  );
}

List<AudioFile> _getAudio(Document document) {
  return document
          .querySelector('.concept_light-status')
          ?.querySelectorAll('audio > source')
          .map((element) {
        final src = assertNotNull(
          variable: element.attributes["src"],
          errorMessage:
              'Could not parse audio source. Is the provided document corrupt, or has Jisho been updated?',
        );
        final type = assertNotNull(
          variable: element.attributes['type'],
          errorMessage:
              'Could not parse audio type. Is the provided document corrupt, or has Jisho been updated?',
        );
        return AudioFile(
          uri: 'https:$src',
          mimetype: type,
        );
      }).toList() ??
      [];
}

/// Provides the URI for a phrase scrape
Uri uriForPhraseScrape(String searchTerm) {
  return Uri.parse('https://jisho.org/word/${Uri.encodeComponent(searchTerm)}');
}

PhrasePageScrapeResultData _getMeaningsOtherFormsAndNotes(
    String query, Document document) {
  final meaningsWrapper = assertNotNull(
    variable: document.querySelector('.meanings-wrapper'),
    errorMessage:
        "Could not parse meanings. Is the provided document corrupt, or has Jisho been updated?",
  );

  final meanings = <PhraseScrapeMeaning>[];
  var mostRecentWordTypes = [];
  var otherForms;
  var notes;

  for (var child in meaningsWrapper.children) {
    final mostRecentWordType = mostRecentWordTypes.length >= 1 ? mostRecentWordTypes[0] : null;
    if (child.className.contains('meaning-tags')) {
      mostRecentWordTypes = _getMostRecentWordTypes(child);
    } else if (mostRecentWordType == 'other forms') {
      otherForms = _getOtherForms(child);
    } else if (mostRecentWordType == 'notes') {
      notes = _getNotes(child);
    } else {
      meanings.add(_getMeaning(child));
    }
  }

  return PhrasePageScrapeResultData(
    uri: uriForPhraseScrape(query).toString(),
    tags: _getTags(document),
    meanings: meanings,
    otherForms: otherForms ?? [],
    audio: _getAudio(document),
    notes: notes ?? [],
  );
}

bool _resultWasFound(Document document) {
  return document.querySelector('.meanings-wrapper') != null;
}

/// Parses a jisho word search page to an object
PhrasePageScrapeResult parsePhrasePageData(String pageHtml, String query) {
  final document = parse(pageHtml);

  if (!_resultWasFound(document)) {
    return PhrasePageScrapeResult(found: false, query: query);
  }

  final data = _getMeaningsOtherFormsAndNotes(query, document);

  return PhrasePageScrapeResult(
    found: true,
    query: query,
    data: data,
  );
}
