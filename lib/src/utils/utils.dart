import 'package:flutter/material.dart';

import '../constants/defaults.dart';
import '../models/text_formatter.dart';

mixin FormattedTextUtils {
  static List<InlineSpan> formattedSpans(
    BuildContext context,
    String data, {
    TextStyle? style,
    bool showFormattingCharacters = false,
    List<FormattedTextFormatter>? formatters,
  }) {
    final List<InlineSpan> children = [];
    final Pattern pattern = RegExp(
        (formatters ?? FormattedTextDefaults.formattedTextDefaultFormatters)
            .map((formatter) => formatter.pattern)
            .join('|'),
        multiLine: true);

    data.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        final matchStr = match[0] ?? '';

        TextStyle myStyle = const TextStyle();
        int prefixLength = 0;

        for (final entry in (formatters ??
            FormattedTextDefaults.formattedTextDefaultFormatters)) {
          final pattern = entry.pattern;
          if (RegExp(pattern).hasMatch(matchStr)) {
            myStyle = myStyle.merge(entry.style);
            prefixLength += entry.patternChars.length;
          }
        }

        final word =
            matchStr.substring(prefixLength, matchStr.length - prefixLength);

        if (showFormattingCharacters) {
          children.add(_getPrefixTextSpan(context, matchStr, prefixLength));
        }

        children.add(TextSpan(
          text: word,
          style: style?.merge(myStyle) ?? myStyle,
        ));

        if (showFormattingCharacters) {
          children.add(_getSuffixTextSpan(context, matchStr, prefixLength));
        }
        return "";
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return "";
      },
    );

    return children;
  }

  static TextSpan _getPrefixTextSpan(
      BuildContext context, String matchStr, int prefixLength) {
    final prefix =
        matchStr.substring(matchStr.length - prefixLength, matchStr.length);

    return _buildCharTextSpan(context, prefix);
  }

  static TextSpan _getSuffixTextSpan(
      BuildContext context, String matchStr, int suffixLength) {
    final suffix = matchStr.substring(0, suffixLength);

    return _buildCharTextSpan(context, suffix);
  }

  static TextSpan _buildCharTextSpan(BuildContext context, String char) {
    return TextSpan(
      text: char,
      style: TextStyle(
        color: Theme.of(context).hintColor.withOpacity(0.2),
      ),
    );
  }
}
