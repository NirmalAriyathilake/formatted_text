import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../formatted_text.dart';

mixin FormattedTextDefaults {
  static const List<FormattedTextContextMenuItem>
      formattedTextDefaultContextMenuItems = [
    FormattedTextContextMenuItem(
      patternChars: '*',
      label: 'Bold',
    ),
    FormattedTextContextMenuItem(
      patternChars: '_',
      label: 'Italic',
    ),
    FormattedTextContextMenuItem(
      patternChars: '~',
      label: 'Strikethrough',
    ),
    FormattedTextContextMenuItem(
      patternChars: '#',
      label: 'Underline',
    ),
  ];

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

  static List<ContextMenuButtonItem> formattedTextDefaultContextMenuButtonItems(
          EditableTextState editableTextState) =>
      formattedTextDefaultContextMenuItems
          .map(
            (item) =>
                FormattedTextContextMenuBuilder.buildContextMenuButtonItem(
              editableTextState: editableTextState,
              item: item,
            ),
          )
          .toList();
}
