import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';

class ConversationSummaryEntity extends Equatable {
  const ConversationSummaryEntity({
    required this.id,
    required this.mode,
    required this.title,
    required this.preview,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final FridgeAiMode mode;
  final String title;
  final String preview;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, mode, title, preview, createdAt, updatedAt];
}
