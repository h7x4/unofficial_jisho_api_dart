import './base_uri.dart';

/// Provides the URI for a phrase search
/// [requestPage] : added to get more pharse
Uri uriForPhraseSearch(String phrase, {int requestPage = 1}) {
  return Uri.parse('$jishoApi?keyword=${Uri.encodeComponent(phrase)}&page=${Uri.encodeComponent(requestPage.toString())}');
}
