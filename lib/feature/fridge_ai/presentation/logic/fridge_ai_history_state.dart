import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/conversation_summary_entity.dart';

enum FridgeAiHistoryStatus { initial, loading, loadingMore, success, failure }

class FridgeAiHistoryState extends Equatable {
  const FridgeAiHistoryState({
    this.status = FridgeAiHistoryStatus.initial,
    this.conversations = const [],
    this.page = 1,
    this.hasMore = false,
    this.errorMessage,
  });

  final FridgeAiHistoryStatus status;
  final List<ConversationSummaryEntity> conversations;
  final int page;
  final bool hasMore;
  final String? errorMessage;

  FridgeAiHistoryState copyWith({
    FridgeAiHistoryStatus? status,
    List<ConversationSummaryEntity>? conversations,
    int? page,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FridgeAiHistoryState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        conversations,
        page,
        hasMore,
        errorMessage,
      ];
}
