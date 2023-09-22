import 'package:equatable/equatable.dart';

class FormattedTextContextMenuItem extends Equatable {
  const FormattedTextContextMenuItem({
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
