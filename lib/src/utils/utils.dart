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
    final styles = <TextStyle>[style ?? const TextStyle()];
    final patterns = <String>[];

    /// custom formatters or default formatters
    final dataFormatters = List<FormattedTextFormatter>.from(
        formatters ?? FormattedTextDefaults.formattedTextDefaultFormatters);

    /// sorted formatters according to pattern length
    /// to get the best pattern match first
    dataFormatters.sort(
      (a, b) => b.patternChars.length.compareTo(a.patternChars.length),
    );

    String currentDataSubstring = '';
    bool formatterFound = false;

    /// go through each char
    int i = 0;

    // To avoid neverending loop
    int safetyCount = 0;

    while (i < data.length && safetyCount < data.length) {
      safetyCount++;
      if (data[i] == ' ') {
        currentDataSubstring += ' ';

        i++;
        continue;
      } else if (data[i] == '\\') {
        currentDataSubstring += '';

        i++;
        continue;
      }

      /// for each formatter
      formatterFound = false;

      for (final formatter in dataFormatters) {
        final formatterLength = formatter.patternChars.length;

        if (i + formatterLength > data.length) {
          continue;
        }

        final substring = data.substring(i, i + formatterLength);

        /// check if the current char is part of the pattern
        /// get the substring matching the length of the pattern and compare
        if (substring == formatter.patternChars) {
          i += formatterLength;
          formatterFound = true;

          /// check if a pattern is open & it matches the current opened pattern
          if (patterns.isNotEmpty && formatter.patternChars == patterns.last) {
            final currentStyle = styles.removeLast();

            if (showFormattingCharacters) {
              children.add(TextSpan(
                text: formatter.patternChars,
                style: currentStyle.copyWith(
                    color: (currentStyle.color ?? Theme.of(context).hintColor)
                        .withOpacity(0.2)),
              ));
            }

            children.add(TextSpan(
              text: currentDataSubstring,
              style: currentStyle,
            ));

            if (showFormattingCharacters) {
              children.add(TextSpan(
                text: formatter.patternChars,
                style: currentStyle.copyWith(
                    color: (currentStyle.color ?? Theme.of(context).hintColor)
                        .withOpacity(0.2)),
              ));
            }

            /// reset
            currentDataSubstring = '';
            patterns.removeLast();

            break;
          } else {
            /// if an ongoing data is available apply the last style
            if (currentDataSubstring.isNotEmpty) {
              final currentStyle = styles.last;

              if (showFormattingCharacters && patterns.isNotEmpty) {
                children.add(TextSpan(
                  text: patterns.last,
                  style: currentStyle.copyWith(
                      color: (currentStyle.color ?? Theme.of(context).hintColor)
                          .withOpacity(0.2)),
                ));
              }

              children.add(TextSpan(
                text: currentDataSubstring,
                style: currentStyle,
              ));

              /// reset
              currentDataSubstring = '';
            }

            /// merge the current style and the formatter style
            styles.add(
              styles.last.merge(formatter.style),
            );

            patterns.add(formatter.patternChars);

            break;
          }
        }
      }

      if (!formatterFound) {
        currentDataSubstring += data[i];
        i++;
      }
    }

    if (currentDataSubstring.isNotEmpty) {
      children.add(TextSpan(
        text: currentDataSubstring,
        style: styles.last,
      ));
    }

    return children;
  }
}
