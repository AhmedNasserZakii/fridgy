import 'package:equatable/equatable.dart';

class QuickReplyEntity extends Equatable {
  const QuickReplyEntity({required this.label, this.message});

  final String label;

  /// When non-null, tapping sends this as the next user message.
  /// When null, the app focuses the composer for free text (e.g. "Other").
  final String? message;

  @override
  List<Object?> get props => [label, message];
}
