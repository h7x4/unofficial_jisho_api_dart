/// Remove all newlines from a string
String removeNewlines(String str) {
  return str.replaceAll(RegExp(r'(?:\r|\n)'), '').trim();
}

/// Remove all text between two positions, and remove all newlines
String getStringBetweenIndicies(String data, int startIndex, int endIndex) {
  final result = data.substring(startIndex, endIndex);
  return removeNewlines(result).trim();
}

/// Try to find a string between two pieces of text
String? getStringBetweenStrings(
  String data,
  String startString,
  String endString,
) {
  final regex = RegExp(
    '${RegExp.escape(startString)}(.*?)${RegExp.escape(endString)}',
    dotAll: true,
  );

  final match = regex.allMatches(data).toList();
  return match.isNotEmpty ? match[0].group(1).toString() : null;
}

/// Try to find an int inbetween two pieces of text
int? getIntBetweenStrings(
  String data,
  String startString,
  String endString,
) {
  final stringBetweenStrings =
      getStringBetweenStrings(data, startString, endString);
  return stringBetweenStrings != null ? int.parse(stringBetweenStrings) : null;
}

/// Get all regex matches
List<String> getAllGlobalGroupMatches(String str, RegExp regex) {
  final regexResults = regex.allMatches(str).toList();
  final results = <String>[];
  for (var match in regexResults) {
    final m = match.group(1);
    if (m != null) results.add(m);
  }

  return results;
}

/// Get all matches of `<a>DATA</a>`
List<String> parseAnchorsToArray(String str) {
  final regex = RegExp(r'<a href=".*?">(.*?)<\/a>');
  return getAllGlobalGroupMatches(str, regex);
}

/// An exception to be thrown whenever a parser fails by not finding an expected pattern.
class ParserException implements Exception {
  /// The error message to report
  final String message;

  // ignore: public_member_api_docs
  const ParserException(this.message);
}

/// Throw a `ParserException` if variable is null
dynamic assertNotNull({
  required dynamic variable,
  String errorMessage =
      "Unexpected null-value occured. Is the provided document corrupt, or has Jisho been updated?",
}) {
  if (variable == null) {
    throw ParserException(errorMessage);
  }
  return variable!;
}
