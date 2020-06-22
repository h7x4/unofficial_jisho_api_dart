import './baseURI.dart';

String uriForPhraseSearch(String phrase) {
  return '${JISHO_API}?keyword=${Uri.encodeComponent(phrase)}';
}