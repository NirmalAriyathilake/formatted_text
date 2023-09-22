import 'package:flutter/material.dart';

import '../constants/defaults.dart';
import '../models/formatter.dart';

mixin FormattedTextUtils {
  static List<InlineSpan> formattedSpans(
    BuildContext context,
    String data, {
    TextStyle? style,
    bool showFormattingCharacters = false,
    List<FormattedTextFormatter>? formatters,
  }) {
    final List<InlineSpan> children = [];
    final appliedStyles = <TextStyle>[style ?? const TextStyle()];
    final appliedFormatters = <FormattedTextFormatter>[];

    /// Custom formatters or default formatters
    final dataFormatters = List<FormattedTextFormatter>.from(
        formatters ?? FormattedTextDefaults.formattedTextDefaultFormatters);

    /// Sorted formatters according to pattern length
    /// to get the best pattern match first
    dataFormatters.sort(
      (a, b) => b.patternChars.length.compareTo(a.patternChars.length),
    );

    /// formatter patterns joined into a string
    final dataFormattersChars =
        dataFormatters.map((e) => e.patternChars).join();

    String currentDataSubstring = '';
    bool formatterFound = false;

    /// Go through each char
    int i = 0;

    // To avoid neverending loop
    int safetyCount = 0;

    while (i < data.length && safetyCount < data.length) {
      safetyCount++;

      /// If the data char not part of formatter patterns
      /// Failing this check doesn't mean it is a formatter pattern
      if (!dataFormattersChars.contains(data[i])) {
        currentDataSubstring += data[i];

        i++;
        continue;
      }

      /// Check if match the current fomatter
      if (appliedFormatters.isNotEmpty) {
        final lastFormatter = appliedFormatters.last;

        if ((i + appliedFormatters.last.patternChars.length) <= data.length) {
          final substring =
              data.substring(i, i + lastFormatter.patternChars.length);

          if (substring == lastFormatter.patternChars) {
            final currentStyle = appliedStyles.removeLast();

            children.add(TextSpan(
              text: currentDataSubstring,
              style: currentStyle,
            ));

            /// Show closing pattern
            if (showFormattingCharacters) {
              children.add(TextSpan(
                text: lastFormatter.patternChars,
                style: currentStyle.copyWith(
                    color: (currentStyle.color ?? Theme.of(context).hintColor)
                        .withOpacity(0.2)),
              ));
            }

            /// Reset
            currentDataSubstring = '';
            appliedFormatters.removeLast();

            i += lastFormatter.patternChars.length;
            continue;
          }
        }
      }

      /// For each formatter
      formatterFound = false;

      for (final formatter in dataFormatters) {
        final formatterLength = formatter.patternChars.length;

        /// If the formatter length exceed maximum possible pattern length
        if (i + formatterLength > data.length) {
          continue;
        }

        final substring = data.substring(i, i + formatterLength);

        /// Check if the current char is part of the pattern
        /// get the substring matching the length of the pattern and compare
        if (substring == formatter.patternChars) {
          // If the matched formatter is already applied but
          // not the last applied formatter do nothing
          if (appliedFormatters.contains(formatter)) {
            break;
          }

          i += formatterLength;
          formatterFound = true;

          /// If an ongoing data is available apply the last style
          /// before opening a new formattter
          if (currentDataSubstring.isNotEmpty) {
            final currentStyle = appliedStyles.last;

            children.add(TextSpan(
              text: currentDataSubstring,
              style: currentStyle,
            ));

            /// Reset
            currentDataSubstring = '';
          }

          /// Merge the current style and the formatter style
          final newStyle = appliedStyles.last.merge(formatter.style);

          appliedStyles.add(
            newStyle,
          );

          appliedFormatters.add(formatter);

          /// Show opening pattern
          if (showFormattingCharacters) {
            children.add(TextSpan(
              text: formatter.patternChars,
              style: newStyle.copyWith(
                  color: (newStyle.color ?? Theme.of(context).hintColor)
                      .withOpacity(0.2)),
            ));
          }

          break;
        }
      }

      /// If no formatter applied
      if (!formatterFound) {
        currentDataSubstring += data[i];
        i++;
      }
    }

    /// if the current pattern is not closed yet apply the started pattern
    if (currentDataSubstring.isNotEmpty) {
      children.add(TextSpan(
        text: currentDataSubstring,
        style: appliedStyles.last,
      ));
    }

    return children;
  }
}
