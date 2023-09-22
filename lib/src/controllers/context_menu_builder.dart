import 'package:flutter/material.dart';

import '../../formatted_text.dart';

class FormattedTextContextMenuBuilder {
  static AdaptiveTextSelectionToolbar adaptiveTextSelectionToolbar({
    required EditableTextState editableTextState,
    List<FormattedTextContextMenuItem>? items,
  }) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: [
        ...editableTextState.contextMenuButtonItems,
        for (final item in items ??
            FormattedTextDefaults.formattedTextDefaultContextMenuItems)
          _buildContextMenuButtonItem(
            editableTextState: editableTextState,
            label: item.label,
            patternChars: item.patternChars,
          )
      ],
    );
  }

  static ContextMenuButtonItem buildContextMenuButtonItem({
    required EditableTextState editableTextState,
    required FormattedTextContextMenuItem item,
  }) {
    return _buildContextMenuButtonItem(
      editableTextState: editableTextState,
      label: item.label,
      patternChars: item.patternChars,
    );
  }

  static ContextMenuButtonItem _buildContextMenuButtonItem({
    required EditableTextState editableTextState,
    required String label,
    required String patternChars,
  }) {
    return ContextMenuButtonItem(
      onPressed: () {
        final TextEditingValue value = editableTextState.textEditingValue;

        editableTextState.updateEditingValue(
          TextEditingValue(
            text:
                '${value.selection.textBefore(value.text)}$patternChars${value.selection.textInside(value.text)}$patternChars${value.selection.textAfter(value.text)}',
            selection: TextSelection.collapsed(
              offset: value.selection.end + (2 * patternChars.length),
            ),
          ),
        );
      },
      label: label,
    );
  }
}
