import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_message_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';

class ConversationDetailEntity extends Equatable {
  const ConversationDetailEntity({
    required this.conversationId,
    required this.mode,
    required this.messages,
  });

  final String conversationId;
  final FridgeAiMode mode;
  final List<FridgeAiMessageEntity> messages;

  @override
  List<Object?> get props => [conversationId, mode, messages];
}
