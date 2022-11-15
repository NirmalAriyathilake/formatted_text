import 'package:flutter/widgets.dart';

class FormattedTextFormatter {
  const FormattedTextFormatter({
    required this.patternChars,
    required this.style,
  });

  final String patternChars;
  final TextStyle style;

  @override
  String toString() {
    return 'FormattedTextFormatter(patternChars: $patternChars, style: $style)';
  }
}
