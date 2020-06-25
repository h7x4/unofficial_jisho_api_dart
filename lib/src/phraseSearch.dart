import './baseURI.dart';


/// Provides the URI for a phrase search
String uriForPhraseSearch(String phrase) {
  return '$JISHO_API?keyword=${Uri.encodeComponent(phrase)}';
}