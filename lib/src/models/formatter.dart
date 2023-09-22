import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class FormattedTextFormatter extends Equatable {
  const FormattedTextFormatter({
    required this.patternChars,
    required this.style,
  });

  final String patternChars;
  final TextStyle style;

  @override
  List<Object?> get props => [
        patternChars,
        style,
      ];

  @override
  String toString() {
    return 'FormattedTextFormatter(patternChars: $patternChars, style: $style)';
  }
}
