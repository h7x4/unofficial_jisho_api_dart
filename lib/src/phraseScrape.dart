import './objects.dart';
import './exampleSearch.dart';

import 'package:html/parser.dart';
import 'package:html/dom.dart';

List<String> getTags(Document document) {
  final List<String> tags = [];
  final tagElements = document.querySelectorAll('.concept_light-tag');

  for (var i = 0; i < tagElements.length; i += 1) {
    final tagText = tagElements[i].text;
    tags.add(tagText);
  }

  return tags;
}

List<String> getMostRecentWordTypes(Element child) {
  return child.text.split(',').map((s) => s.trim().toLowerCase()).toList();
}

List<KanjiKanaPair> getOtherForms(Element child) {
  return child.text.split('、')
    .map((s) => s.replaceAll('【', '').replaceAll('】', '').split(' '))
    .map((a) => (KanjiKanaPair( kanji: a[0], kana: (a.length == 2) ? a[1] : null ))).toList();
}

List<String> getNotes(Element child) => child.text.split('\n');

String getMeaning(Element child) => child.querySelector('.meaning-meaning').text;

String getMeaningAbstract(Element child) {
  final meaningAbstract = child.querySelector('.meaning-abstract');
  if (meaningAbstract == null) return null;
  
  for (var element in meaningAbstract.querySelectorAll('a')) {
    element.remove();
  }

  return child.querySelector('.meaning-abstract')?.text;
}

List<String> getSupplemental(Element child) {
  final supplemental = child.querySelector('.supplemental_info');
  if (supplemental == null) return [];
  return supplemental.text.split(',').map((s) => s.trim()).toList();
}

List<String> getSeeAlsoTerms(List<String> supplemental) {
  if (supplemental == null) return [];

  final List<String> seeAlsoTerms = [];
  for (var i = supplemental.length - 1; i >= 0; i -= 1) {
    final supplementalEntry = supplemental[i];
    if (supplementalEntry.startsWith('See also')) {
      seeAlsoTerms.add(supplementalEntry.replaceAll('See also ', ''));
      supplemental.removeAt(i);
    }
  }
  return seeAlsoTerms;
}

List<PhraseScrapeSentence> getSentences(Element child) {
  final sentenceElements = child.querySelector('.sentences')?.querySelectorAll('.sentence');
  if (sentenceElements == null) return [];

  final List<PhraseScrapeSentence> sentences = [];
  for (var sentenceIndex = 0; sentenceIndex < (sentenceElements?.length ?? 0); sentenceIndex += 1) {
    final sentenceElement = sentenceElements[sentenceIndex];

    final english = sentenceElement.querySelector('.english').text;
    final pieces = getPieces(sentenceElement);

    sentenceElement.querySelector('.english').remove();
    for (var element in sentenceElement.children[0].children) {
      element.querySelector('.furigana')?.remove();
    }

    final japanese = sentenceElement.text;

    sentences.add(
      PhraseScrapeSentence(
        english: english,
        japanese: japanese,
        pieces: pieces ?? []
      )
    );
  }

  return sentences;
}

PhrasePageScrapeResult getMeaningsOtherFormsAndNotes(Document document) {
  final returnValues = PhrasePageScrapeResult( otherForms: [], notes: [] );

  final meaningsWrapper = document.querySelector('.meanings-wrapper');
  if (meaningsWrapper == null) return PhrasePageScrapeResult(found: false);
  returnValues.found = true;

  final meaningsChildren = meaningsWrapper.children;

  final List<PhraseScrapeMeaning> meanings = [];
  var mostRecentWordTypes = [];
  for (var meaningIndex = 0; meaningIndex < meaningsChildren.length; meaningIndex += 1) {
    final child = meaningsChildren[meaningIndex];

    if (child.className.contains('meaning-tags')) {
      mostRecentWordTypes = getMostRecentWordTypes(child);

    } else if (mostRecentWordTypes[0] == 'other forms') {
      returnValues.otherForms = getOtherForms(child);

    } else if (mostRecentWordTypes[0] == 'notes') {
      returnValues.notes = getNotes(child);

    } else {
      final meaning = getMeaning(child);
      final meaningAbstract = getMeaningAbstract(child);
      final supplemental = getSupplemental(child);
      final seeAlsoTerms = getSeeAlsoTerms(supplemental);
      final sentences = getSentences(child);

      meanings.add(PhraseScrapeMeaning(
        seeAlsoTerms: seeAlsoTerms ?? [],
        sentences: sentences ?? [],
        definition: meaning,
        supplemental: supplemental ?? [],
        definitionAbstract: meaningAbstract,
        tags: mostRecentWordTypes ?? [],
      ));
    }
  }

  returnValues.meanings = meanings;

  return returnValues;
}

String uriForPhraseScrape(String searchTerm) {
  return 'https://jisho.org/word/${Uri.encodeComponent(searchTerm)}';
}

PhrasePageScrapeResult parsePhrasePageData(String pageHtml, String query) {
  final document = parse(pageHtml);
  final result = getMeaningsOtherFormsAndNotes(document);

  result.query = query;
  if (!result.found) return result;
  result.uri = uriForPhraseScrape(query);
  result.tags = getTags(document);

  return result;
}