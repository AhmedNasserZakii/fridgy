import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/conversation_summary_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/repos/fridge_ai_repo.dart';
import 'package:fridgy/feature/fridge_ai/presentation/logic/fridge_ai_history_state.dart';

class FridgeAiHistoryCubit extends Cubit<FridgeAiHistoryState> {
  FridgeAiHistoryCubit({required this._fridgeAiRepo})
      : super(const FridgeAiHistoryState());

  final FridgeAiRepo _fridgeAiRepo;

  Future<void> load({bool refresh = false}) async {
    if (state.status == FridgeAiHistoryStatus.loading) return;

    emit(
      state.copyWith(
        status: FridgeAiHistoryStatus.loading,
        clearError: true,
        conversations: refresh ? const [] : state.conversations,
      ),
    );

    final result = await _fridgeAiRepo.getConversations(page: 1);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FridgeAiHistoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: FridgeAiHistoryStatus.success,
          conversations: page.items,
          hasMore: page.meta.hasMore,
          page: page.meta.page,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.status == FridgeAiHistoryStatus.loadingMore ||
        state.status == FridgeAiHistoryStatus.loading) {
      return;
    }

    emit(state.copyWith(status: FridgeAiHistoryStatus.loadingMore));
    final nextPage = state.page + 1;
    final result = await _fridgeAiRepo.getConversations(page: nextPage);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FridgeAiHistoryStatus.success,
          errorMessage: failure.message,
        ),
      ),
      (page) {
        final merged = List<ConversationSummaryEntity>.from(state.conversations)
          ..addAll(page.items);
        emit(
          state.copyWith(
            status: FridgeAiHistoryStatus.success,
            conversations: merged,
            hasMore: page.meta.hasMore,
            page: page.meta.page,
            clearError: true,
          ),
        );
      },
    );
  }
}
