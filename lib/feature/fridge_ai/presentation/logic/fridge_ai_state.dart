import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_message_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/proposed_item_entity.dart';

enum FridgeAiStatus { idle, sending, loadingConversation, confirming, failure }

enum FridgeAiEmptyPhase { welcome, prompts }

class FridgeAiState extends Equatable {
  const FridgeAiState({
    this.mode = FridgeAiMode.addFood,
    this.status = FridgeAiStatus.idle,
    this.emptyPhase = FridgeAiEmptyPhase.welcome,
    this.conversationId,
    this.messages = const [],
    this.pendingImagePath,
    this.pendingImageName,
    this.errorMessage,
    this.toastMessage,
    this.toastId = 0,
    this.confirmingSucceeded = false,
    this.confirmedItems = const [],
  });

  final FridgeAiMode mode;
  final FridgeAiStatus status;
  final FridgeAiEmptyPhase emptyPhase;
  final String? conversationId;
  final List<FridgeAiMessageEntity> messages;
  final String? pendingImagePath;
  final String? pendingImageName;
  final String? errorMessage;
  final String? toastMessage;
  final int toastId;
  final bool confirmingSucceeded;
  final List<ProposedItemEntity> confirmedItems;

  bool get isBusy =>
      status == FridgeAiStatus.sending ||
      status == FridgeAiStatus.loadingConversation ||
      status == FridgeAiStatus.confirming;

  bool get hasConversation => messages.isNotEmpty;

  bool get showSuccess => confirmingSucceeded && confirmedItems.isNotEmpty;

  bool get hasPendingImage =>
      pendingImagePath != null && pendingImagePath!.isNotEmpty;

  FridgeAiState copyWith({
    FridgeAiMode? mode,
    FridgeAiStatus? status,
    FridgeAiEmptyPhase? emptyPhase,
    String? conversationId,
    List<FridgeAiMessageEntity>? messages,
    String? pendingImagePath,
    String? pendingImageName,
    String? errorMessage,
    String? toastMessage,
    int? toastId,
    bool? confirmingSucceeded,
    List<ProposedItemEntity>? confirmedItems,
    bool clearConversationId = false,
    bool clearPendingImage = false,
    bool clearError = false,
    bool clearToast = false,
    bool clearConfirmedItems = false,
  }) {
    return FridgeAiState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      emptyPhase: emptyPhase ?? this.emptyPhase,
      conversationId:
          clearConversationId ? null : (conversationId ?? this.conversationId),
      messages: messages ?? this.messages,
      pendingImagePath: clearPendingImage
          ? null
          : (pendingImagePath ?? this.pendingImagePath),
      pendingImageName: clearPendingImage
          ? null
          : (pendingImageName ?? this.pendingImageName),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      toastMessage: clearToast ? null : (toastMessage ?? this.toastMessage),
      toastId: toastId ?? this.toastId,
      confirmingSucceeded: confirmingSucceeded ?? this.confirmingSucceeded,
      confirmedItems: clearConfirmedItems
          ? const []
          : (confirmedItems ?? this.confirmedItems),
    );
  }

  @override
  List<Object?> get props => [
        mode,
        status,
        emptyPhase,
        conversationId,
        messages,
        pendingImagePath,
        pendingImageName,
        errorMessage,
        toastMessage,
        toastId,
        confirmingSucceeded,
        confirmedItems,
      ];
}
