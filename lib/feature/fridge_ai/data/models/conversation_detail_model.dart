import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/fridge_ai/data/models/fridge_ai_message_model.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/conversation_detail_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';

class ConversationDetailModel {
  ConversationDetailModel({
    required this.conversationId,
    required this.mode,
    required this.messages,
  });

  final String conversationId;
  final String mode;
  final List<FridgeAiMessageModel> messages;

  factory ConversationDetailModel.fromJson(Map<String, dynamic> json) {
    final rawMessages = json[ApiKeys.messages];
    return ConversationDetailModel(
      conversationId: json[ApiKeys.conversationId] as String,
      mode: json[ApiKeys.mode] as String,
      messages: rawMessages is List
          ? rawMessages
              .whereType<Map>()
              .map(
                (e) => FridgeAiMessageModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList()
          : const [],
    );
  }

  ConversationDetailEntity toEntity() {
    return ConversationDetailEntity(
      conversationId: conversationId,
      mode: FridgeAiMode.fromApi(mode),
      messages: messages.map((e) => e.toEntity()).toList(),
    );
  }
}
