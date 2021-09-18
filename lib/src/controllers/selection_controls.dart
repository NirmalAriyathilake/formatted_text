import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../constants/defaults.dart';
import '../models/toolbar_action.dart';

class FormattedTextSelectionControls extends MaterialTextSelectionControls {
  // Padding between the toolbar and the anchor.
  FormattedTextSelectionControls({
    this.actions,
  });

  final List<FormattedTextToolbarAction>? actions;

  static const double _kToolbarContentDistance = 8.0;
  static const double _kToolbarContentDistanceBelow = 20.0;

  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset selectionMidpoint,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ClipboardStatusNotifier clipboardStatus,
      Offset? lastSecondaryTapDownPosition) {
    final TextSelectionPoint startTextSelectionPoint = endpoints[0];
    final TextSelectionPoint endTextSelectionPoint =
        endpoints.length > 1 ? endpoints[1] : endpoints[0];
    final Offset anchorAbove = Offset(
        globalEditableRegion.left + selectionMidpoint.dx,
        globalEditableRegion.top +
            startTextSelectionPoint.point.dy -
            textLineHeight -
            _kToolbarContentDistance);
    final Offset anchorBelow = Offset(
      globalEditableRegion.left + selectionMidpoint.dx,
      globalEditableRegion.top +
          endTextSelectionPoint.point.dy +
          _kToolbarContentDistanceBelow,
    );

    return FormattedTextToolbar(
      anchorAbove: anchorAbove,
      anchorBelow: anchorBelow,
      clipboardStatus: clipboardStatus,
      delegate: delegate,
      items: actions,
      handleCopy: canCopy(delegate)
          ? () => handleCopy(delegate, clipboardStatus)
          : null,
      handleCut: canCut(delegate) ? () => handleCut(delegate) : null,
      handlePaste: canPaste(delegate) ? () => handlePaste(delegate) : null,
      handleSelectAll:
          canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
    );
  }
}

class FormattedTextToolbar extends StatefulWidget {
  const FormattedTextToolbar({
    Key? key,
    required this.anchorAbove,
    required this.anchorBelow,
    required this.clipboardStatus,
    required this.handleCopy,
    required this.handleCut,
    required this.handlePaste,
    required this.handleSelectAll,
    this.items,
    required this.delegate,
  }) : super(key: key);

  final Offset anchorAbove;
  final Offset anchorBelow;
  final ClipboardStatusNotifier clipboardStatus;
  final TextSelectionDelegate delegate;
  final VoidCallback? handleCopy;
  final VoidCallback? handleCut;
  final VoidCallback? handlePaste;
  final VoidCallback? handleSelectAll;
  final List<FormattedTextToolbarAction>? items;

  @override
  _FormattedTextToolbarState createState() => _FormattedTextToolbarState();
}

class _FormattedTextToolbarState extends State<FormattedTextToolbar> {
  @override
  void didUpdateWidget(FormattedTextToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.clipboardStatus != oldWidget.clipboardStatus) {
      widget.clipboardStatus.addListener(_onChangedClipboardStatus);
      oldWidget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
    widget.clipboardStatus.update();
  }

  @override
  void dispose() {
    if (!widget.clipboardStatus.disposed) {
      widget.clipboardStatus.removeListener(_onChangedClipboardStatus);
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.clipboardStatus.addListener(_onChangedClipboardStatus);
    widget.clipboardStatus.update();
  }

  void _onChangedClipboardStatus() {
    setState(() {
      // Inform the widget that the value of clipboardStatus has changed.
    });
  }

  Widget _buildToolbarButton({
    required String label,
    String? patternChars,
    VoidCallback? onPressed,
  }) {
    assert(onPressed != null || patternChars != null);
    return TextSelectionToolbarTextButton(
      onPressed: onPressed ?? () => _formatText(patternChars!),
      padding: const EdgeInsets.all(8.0),
      child: Text(label),
    );
  }

  void _formatText(String patternChars) {
    final TextEditingValue value = widget.delegate.textEditingValue;

    widget.delegate.userUpdateTextEditingValue(
      TextEditingValue(
        text: value.selection.textBefore(value.text) +
            '$patternChars${value.selection.textInside(value.text)}$patternChars' +
            value.selection.textAfter(value.text),
        selection: TextSelection.collapsed(
          offset: value.selection.end + (2 * patternChars.length),
        ),
      ),
      SelectionChangedCause.toolBar,
    );
    widget.delegate
        .bringIntoView(widget.delegate.textEditingValue.selection.extent);
    widget.delegate.hideToolbar();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return TextSelectionToolbar(
      anchorAbove: widget.anchorAbove,
      anchorBelow: widget.anchorBelow,
      toolbarBuilder: (BuildContext context, Widget child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).canvasColor,
          ),
          child: child,
        );
      },
      children: <Widget>[
        if (widget.handleCut != null)
          _buildToolbarButton(
            label: localizations.cutButtonLabel,
            onPressed: widget.handleCut!,
          ),
        if (widget.handleCopy != null)
          _buildToolbarButton(
            label: localizations.copyButtonLabel,
            onPressed: widget.handleCopy!,
          ),
        if (widget.handlePaste != null &&
            widget.clipboardStatus.value == ClipboardStatus.pasteable)
          _buildToolbarButton(
            label: localizations.pasteButtonLabel,
            onPressed: widget.handlePaste!,
          ),
        if (widget.handleSelectAll != null)
          _buildToolbarButton(
            label: localizations.selectAllButtonLabel,
            onPressed: widget.handleSelectAll!,
          ),
        for (final item in widget.items ?? FormattedTextDefaults.formattedTextToolbarDefaultActions)
          _buildToolbarButton(
            label: item.label,
            patternChars: item.patternChars,
          )
      ],
    );
  }
}
