import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/network_services/server_failure.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_message_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_consumption_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_item_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/send_message_result_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/params/send_image_params.dart';
import 'package:fridgy/feature/fridge_ai/domain/params/send_message_params.dart';
import 'package:fridgy/feature/fridge_ai/domain/repos/fridge_ai_repo.dart';
import 'package:fridgy/feature/fridge_ai/presentation/logic/fridge_ai_state.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/inventory/domain/params/upsert_food_params.dart';
import 'package:fridgy/feature/inventory/domain/repos/inventory_repo.dart';

class FridgeAiCubit extends Cubit<FridgeAiState> {
  FridgeAiCubit({required this._fridgeAiRepo, required this._inventoryRepo})
      : super(const FridgeAiState());

  final FridgeAiRepo _fridgeAiRepo;
  final InventoryRepo _inventoryRepo;

  void selectMode(FridgeAiMode mode) {
    if (state.hasConversation) {
      emit(
        state.copyWith(
          mode: mode,
          emptyPhase: FridgeAiEmptyPhase.prompts,
          messages: const [],
          clearConversationId: true,
          status: FridgeAiStatus.idle,
          clearError: true,
          confirmingSucceeded: false,
          clearConfirmedItems: true,
          clearPendingImage: true,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        mode: mode,
        emptyPhase: FridgeAiEmptyPhase.prompts,
        clearError: true,
        confirmingSucceeded: false,
        clearConfirmedItems: true,
      ),
    );
  }

  void setPendingImage({required String path, String? name}) {
    emit(
      state.copyWith(
        pendingImagePath: path,
        pendingImageName: name,
        emptyPhase: FridgeAiEmptyPhase.prompts,
        clearError: true,
      ),
    );
  }

  void clearPendingImage() {
    emit(state.copyWith(clearPendingImage: true));
  }

  Future<void> sendMessage(String raw) async {
    if (state.isBusy) return;

    final message = raw.trim();
    if (state.hasPendingImage) {
      await _sendImage(caption: message.isEmpty ? null : message);
      return;
    }
    if (message.isEmpty) return;

    emit(
      state.copyWith(
        status: FridgeAiStatus.sending,
        clearError: true,
        clearToast: true,
      ),
    );

    final result = await _fridgeAiRepo.sendMessage(
      SendMessageParams(
        mode: state.mode,
        message: message,
        conversationId: state.conversationId,
      ),
    );

    if (isClosed) return;
    _handleSendResult(result);
  }

  Future<void> _sendImage({String? caption}) async {
    final path = state.pendingImagePath;
    if (path == null || path.isEmpty || state.isBusy) return;

    emit(
      state.copyWith(
        status: FridgeAiStatus.sending,
        clearError: true,
        clearToast: true,
      ),
    );

    final result = await _fridgeAiRepo.sendImage(
      SendImageParams(
        mode: state.mode,
        imagePath: path,
        message: caption,
        conversationId: state.conversationId,
        fileName: state.pendingImageName,
      ),
    );

    if (isClosed) return;
    _handleSendResult(result, localImagePath: path);
  }

  void _handleSendResult(
    Either<ServerFailure, SendMessageResultEntity> result, {
    String? localImagePath,
  }) {
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FridgeAiStatus.failure,
          errorMessage: failure.message,
          toastMessage: failure.message,
          toastId: state.toastId + 1,
        ),
      ),
      (data) {
        final userMessage = localImagePath == null
            ? data.userMessage
            : data.userMessage.copyWith(localImagePath: localImagePath);
        final nextMessages = List<FridgeAiMessageEntity>.from(state.messages)
          ..add(userMessage)
          ..add(data.assistantMessage);
        emit(
          state.copyWith(
            status: FridgeAiStatus.idle,
            conversationId: data.conversationId,
            mode: data.mode,
            messages: nextMessages,
            clearPendingImage: true,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> openConversation(String conversationId) async {
    if (state.isBusy) return;

    emit(
      state.copyWith(
        status: FridgeAiStatus.loadingConversation,
        clearError: true,
        clearToast: true,
        clearPendingImage: true,
      ),
    );

    final result = await _fridgeAiRepo.getConversationMessages(conversationId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FridgeAiStatus.failure,
          errorMessage: failure.message,
          toastMessage: failure.message,
          toastId: state.toastId + 1,
        ),
      ),
      (detail) => emit(
        state.copyWith(
          status: FridgeAiStatus.idle,
          conversationId: detail.conversationId,
          mode: detail.mode,
          messages: detail.messages,
          emptyPhase: FridgeAiEmptyPhase.prompts,
          confirmingSucceeded: false,
          clearConfirmedItems: true,
          clearError: true,
        ),
      ),
    );
  }

  void startNewChat() {
    emit(const FridgeAiState());
  }

  Future<void> confirmProposedItems(List<ProposedItemEntity> items) async {
    if (items.isEmpty || state.isBusy) return;

    emit(
      state.copyWith(
        status: FridgeAiStatus.confirming,
        clearError: true,
        clearToast: true,
        confirmingSucceeded: false,
      ),
    );

    final completeItems = items.where((e) => e.isComplete).toList();
    if (completeItems.isEmpty) return;

    for (final item in completeItems) {
      final result = await _inventoryRepo.create(
        UpsertFoodParams(
          name: item.name,
          quantity: item.quantity!,
          unit: item.unit,
          category: item.category,
          storage: StorageLocation.fridge,
          purchaseDate: DateTime.now(),
          expiryDate: item.expiresAt,
          isPartlyUsed: false,
        ),
      );
      if (isClosed) return;
      final failed = result.fold((f) => f.message, (_) => null);
      if (failed != null) {
        emit(
          state.copyWith(
            status: FridgeAiStatus.failure,
            errorMessage: failed,
            toastMessage: failed,
            toastId: state.toastId + 1,
          ),
        );
        return;
      }
    }

    emit(
      state.copyWith(
        status: FridgeAiStatus.idle,
        confirmingSucceeded: true,
        confirmedItems: completeItems,
        clearToast: true,
      ),
    );
  }

  Future<void> confirmProposedConsumptions(
    List<ProposedConsumptionEntity> items,
  ) async {
    if (items.isEmpty || state.isBusy) return;

    emit(
      state.copyWith(
        status: FridgeAiStatus.confirming,
        clearError: true,
        clearToast: true,
        confirmingSucceeded: false,
      ),
    );

    for (final item in items) {
      final result = await _inventoryRepo.consume(
        item.inventoryItemId,
        quantity: item.quantity,
      );
      if (isClosed) return;
      final failed = result.fold((f) => f.message, (_) => null);
      if (failed != null) {
        emit(
          state.copyWith(
            status: FridgeAiStatus.failure,
            errorMessage: failed,
            toastMessage: failed,
            toastId: state.toastId + 1,
          ),
        );
        return;
      }
    }

    emit(
      state.copyWith(
        status: FridgeAiStatus.idle,
        confirmingSucceeded: true,
        confirmedItems: [
          for (final item in items)
            ProposedItemEntity(
              id: item.id,
              name: item.name,
              quantity: item.quantity,
              unit: item.unit,
            ),
        ],
        clearToast: true,
      ),
    );
  }
}
