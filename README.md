[![pub package](https://img.shields.io/pub/v/formatted_text.svg)](https://pub.dartlang.org/packages/formatted_text)
[![MIT License](https://img.shields.io/badge/License-BSD-purple.svg)](https://opensource.org/licenses/BSD-3-Clause)

- [Introduction](#introduction)
- [Getting Started](#getting-Started)
- [Usage examples](#usage-examples)
  - [Text View](#text-view)
  - [Text Editing Controller](#text-editing-controller)
  - [Selection controls](#selection-controls)
  - [Custom Formatters](#custom-formatters)
  - [Custom Toolbar Actions](#custom-toolbar-actions)

</br>

## Introduction

---

- Formatted Text is a Text formatting package.
- Under the hood this package use regex for matching patterns and applying `TextStyle` provided for each pattern.
- One text can be wrapped aroung with multiple patterns to apply multiple `TextStyles` merged together. ( All `TextStyles` should be able to merged together )

- This package includes,
  - Text View
  - Text Editing Controller
  - Selection toolbar

</br>

### Packages

formatted_text          - [![pub package](https://img.shields.io/static/v1?label=formatted_text&message=v1.0.0&color=orange)](https://pub.dartlang.org/packages/formatted_text)

formatted_text_hooks    - [![pub package](https://img.shields.io/static/v1?label=formatted_text_hooks&message=v1.0.0&color=orange)](https://pub.dartlang.org/packages/formatted_text_hooks)

</br>

## Getting Started

---

### Add as dependency

```yaml
dependencies:    
  formatted_text: [latest-version]   
```

If you are using `flutter_hooks` use `formatted_text_hooks`

```yaml
dependencies:  
  formatted_text_hooks: [latest-version]   
```

</br>

### Import package

```dart
import 'package:formatted_text/formatted_text.dart';
```

If using `formatted_text_hooks`

```dart
import 'package:formatted_text_hooks/formatted_text_hooks.dart';
```

</br>

## Usage examples

---

### Text View

</br>

#### Bold

```dart
FormattedText('*This text is bold*');
```

![Bold Text Image](/raw/bold_text.png)

#### Italic

```dart
FormattedText('_This text is Italic_');
```

![Bold Text Image](/raw/italic_text.png)

Strikethrough (`~`) and Underline (`#`) are also available as default formatters

</br>

### Text Editing Controller

```dart
final textEditingController = FormattedTextEditingController();
```

or

```dart
final textEditingController = useFormattedTextController();
```

</br>

### Selection controls

</br>

To display custom selection controls,

```dart
selectionControls: FormattedTextSelectionControls(),
```

Modify cut / copy / paste / select all action availability using `Toolbar Options`

```dart
toolbarOptions: ToolbarOptions(
  cut: false,
  copy: false,
  paste: false,
  selectAll: true,
)
```

</br>

### Custom Formatters

- Providing custom formatters will override the default formatters.
- Formatters use regex for finding matches. Escape `patternChars` except the first char.

```dart
FormattedText(
  '==This text is orange==',
  formatters: [
    ... FormattedTextDefaults.formattedTextDefaultFormatters, // To add default formatters
    FormattedTextFormatter(
      patternChars: '==', // Pattern char(s)
      style: TextStyle(color: Colors.orange),
    )
  ],
)
```

</br>

### Custom Toolbar Actions

- Providing custom actions will override the default actions except cut / copy / paste / select all.
- Don't escape `patternChars`.

```dart
selectionControls: FormattedTextSelectionControls(
  actions: [
    ... FormattedTextDefaults.formattedTextToolbarDefaultActions, // To add default actions
    FormattedTextToolbarAction(
      label: 'Orange',
      patternChars: '==',
    )
  ],
)
```
