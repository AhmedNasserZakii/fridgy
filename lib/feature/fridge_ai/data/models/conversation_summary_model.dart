import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/conversation_summary_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';

class ConversationSummaryModel {
  ConversationSummaryModel({
    required this.id,
    required this.mode,
    required this.title,
    required this.preview,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String mode;
  final String title;
  final String preview;
  final String createdAt;
  final String updatedAt;

  factory ConversationSummaryModel.fromJson(Map<String, dynamic> json) {
    return ConversationSummaryModel(
      id: json[ApiKeys.id] as String,
      mode: json[ApiKeys.mode] as String,
      title: json[ApiKeys.title] as String,
      preview: json[ApiKeys.preview] as String,
      createdAt: json[ApiKeys.createdAt] as String,
      updatedAt: json[ApiKeys.updatedAt] as String,
    );
  }

  ConversationSummaryEntity toEntity() {
    return ConversationSummaryEntity(
      id: id,
      mode: FridgeAiMode.fromApi(mode),
      title: title,
      preview: preview,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
