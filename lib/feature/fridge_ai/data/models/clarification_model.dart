import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/fridge_ai/data/models/proposed_item_model.dart';
import 'package:fridgy/feature/fridge_ai/data/models/quick_reply_model.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/clarification_entity.dart';

class ClarificationModel {
  ClarificationModel({
    required this.targetItem,
    required this.quickReplies,
    this.hint,
    this.note,
    this.cancelLabel,
    this.cancelMessage,
  });

  final ProposedItemModel targetItem;
  final List<QuickReplyModel> quickReplies;
  final String? hint;
  final String? note;
  final String? cancelLabel;
  final String? cancelMessage;

  factory ClarificationModel.fromJson(Map<String, dynamic> json) {
    final repliesRaw = json[ApiKeys.quickReplies];
    final replies = repliesRaw is List
        ? repliesRaw
            .whereType<Map>()
            .map((e) => QuickReplyModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <QuickReplyModel>[];

    return ClarificationModel(
      targetItem: ProposedItemModel.fromJson(
        Map<String, dynamic>.from(json[ApiKeys.targetItem] as Map),
      ),
      quickReplies: replies,
      hint: json[ApiKeys.hint] as String?,
      note: json[ApiKeys.note] as String?,
      cancelLabel: json[ApiKeys.cancelLabel] as String?,
      cancelMessage: json[ApiKeys.cancelMessage] as String?,
    );
  }

  ClarificationEntity toEntity() {
    return ClarificationEntity(
      targetItem: targetItem.toEntity(),
      quickReplies: quickReplies.map((e) => e.toEntity()).toList(),
      hint: hint,
      note: note,
      cancelLabel: cancelLabel,
      cancelMessage: cancelMessage,
    );
  }
}
