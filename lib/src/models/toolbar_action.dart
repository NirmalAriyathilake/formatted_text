import 'package:equatable/equatable.dart';

class FormattedTextToolbarAction extends Equatable {
  const FormattedTextToolbarAction({
    required this.label,
    required this.patternChars,
  });

  final String label;
  final String patternChars;

  @override
  List<Object?> get props => [
        label,
        patternChars,
      ];
}
