import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/quick_reply_entity.dart';

class QuickReplyModel {
  QuickReplyModel({required this.label, this.message});

  final String label;
  final String? message;

  factory QuickReplyModel.fromJson(Map<String, dynamic> json) {
    return QuickReplyModel(
      label: json[ApiKeys.label] as String,
      message: json[ApiKeys.message] as String?,
    );
  }

  QuickReplyEntity toEntity() {
    return QuickReplyEntity(label: label, message: message);
  }
}
