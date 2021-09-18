import 'package:flutter/cupertino.dart';

class FormattedTextFormatter {
  const FormattedTextFormatter({
    required this.patternChars,
    required this.style,
  }) : pattern = r'\' +
            patternChars +
            '([^\\' +
            patternChars +
            ']+)\\' +
            patternChars;

  final String pattern;
  final String patternChars;
  final TextStyle style;
}
