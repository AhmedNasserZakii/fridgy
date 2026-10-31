import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';

class SendImageParams {
  const SendImageParams({
    required this.mode,
    required this.imagePath,
    this.message,
    this.conversationId,
    this.fileName,
    this.mimeType,
  });

  final FridgeAiMode mode;
  final String imagePath;
  final String? message;
  final String? conversationId;
  final String? fileName;
  final String? mimeType;
}
