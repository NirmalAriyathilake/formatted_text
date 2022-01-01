import 'package:flutter/material.dart';

import '../models/text_formatter.dart';
import '../utils/utils.dart';

class FormattedTextEditingController extends TextEditingController {
  FormattedTextEditingController({
    String? text,
    this.formatters,
  }) : super(text: text);

  FormattedTextEditingController.fromValue(
    TextEditingValue? value, {
    this.formatters,
  })  : assert(
          value == null ||
              !value.composing.isValid ||
              value.isComposingRangeValid,
          'New TextEditingValue $value has an invalid non-empty composing range '
          '${value.composing}. It is recommended to use a valid composing range, '
          'even for readonly text fields',
        ),
        super(text: value?.text);

  final List<FormattedTextFormatter>? formatters;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<InlineSpan> children = FormattedTextUtils.formattedSpans(
      context,
      text,
      style: style,
      showFormattingCharacters: true,
      formatters: formatters,
    );

    return TextSpan(style: style, children: children);
  }

  @override
  String get text => value.text;

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  @override
  set value(TextEditingValue newValue) {
    assert(
      !newValue.composing.isValid || newValue.isComposingRangeValid,
      'New TextEditingValue $newValue has an invalid non-empty composing range '
      '${newValue.composing}. It is recommended to use a valid composing range, '
      'even for readonly text fields',
    );
    super.value = newValue;
  }
}
