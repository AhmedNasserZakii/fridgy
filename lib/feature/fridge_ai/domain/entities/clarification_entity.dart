import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_item_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/quick_reply_entity.dart';

class ClarificationEntity extends Equatable {
  const ClarificationEntity({
    required this.targetItem,
    required this.quickReplies,
    this.hint,
    this.note,
    this.cancelLabel,
    this.cancelMessage,
  });

  final ProposedItemEntity targetItem;
  final List<QuickReplyEntity> quickReplies;
  final String? hint;
  final String? note;
  final String? cancelLabel;
  final String? cancelMessage;

  @override
  List<Object?> get props => [
        targetItem,
        quickReplies,
        hint,
        note,
        cancelLabel,
        cancelMessage,
      ];
}
