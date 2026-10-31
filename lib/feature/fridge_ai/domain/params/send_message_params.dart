import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';

class SendMessageParams {
  const SendMessageParams({
    required this.mode,
    required this.message,
    this.conversationId,
  });

  final FridgeAiMode mode;
  final String message;
  final String? conversationId;
}
