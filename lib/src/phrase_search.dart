import './base_uri.dart';

/// Provides the URI for a phrase search
Uri uriForPhraseSearch(String phrase) {
  return Uri.parse('$jishoApi?keyword=${Uri.encodeComponent(phrase)}');
}
