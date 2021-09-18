import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/text_formatter.dart';
import '../models/toolbar_action.dart';

mixin FormattedTextDefaults {
  static const List<FormattedTextFormatter> formattedTextDefaultFormatters = [
    FormattedTextFormatter(
      patternChars: '*',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    FormattedTextFormatter(
      patternChars: '_',
      style: TextStyle(fontStyle: FontStyle.italic),
    ),
    FormattedTextFormatter(
      patternChars: '~',
      style: TextStyle(decoration: TextDecoration.lineThrough),
    ),
    FormattedTextFormatter(
      patternChars: '#',
      style: TextStyle(decoration: TextDecoration.underline),
    ),
  ];

  static const List<FormattedTextToolbarAction>
      formattedTextToolbarDefaultActions = [
    FormattedTextToolbarAction(
      patternChars: '*',
      label: 'Bold',
    ),
    FormattedTextToolbarAction(
      patternChars: '_',
      label: 'Italic',
    ),
    FormattedTextToolbarAction(
      patternChars: '~',
      label: 'Strikethrough',
    ),
    FormattedTextToolbarAction(
      patternChars: '#',
      label: 'Underline',
    ),
  ];
}
