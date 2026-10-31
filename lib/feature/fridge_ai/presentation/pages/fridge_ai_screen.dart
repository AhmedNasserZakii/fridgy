import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/helper/print_debug.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';
import 'package:fridgy/feature/fridge_ai/presentation/logic/fridge_ai_cubit.dart';
import 'package:fridgy/feature/fridge_ai/presentation/logic/fridge_ai_state.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_conversation_view.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_empty_content.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_header.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_image_source_sheet.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_message_composer.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_mode_segment.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_pending_image_preview.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_success_content.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_welcome_content.dart';
import 'package:image_picker/image_picker.dart';

class FridgeAiScreen extends StatefulWidget {
  const FridgeAiScreen({super.key});

  @override
  State<FridgeAiScreen> createState() => _FridgeAiScreenState();
}

class _FridgeAiScreenState extends State<FridgeAiScreen> {
  late final TextEditingController _messageController;
  late final FocusNode _composerFocus;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _composerFocus = FocusNode();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _composerFocus.dispose();
    super.dispose();
  }

  Future<void> _openHistory() async {
    final conversationId = await Navigator.of(
      context,
    ).pushNamed(AppRoute.fridgeAiHistory);
    if (!mounted || conversationId is! String || conversationId.isEmpty) {
      return;
    }
    await context.read<FridgeAiCubit>().openConversation(conversationId);
  }

  void _send([String? override]) {
    final text = override ?? _messageController.text;
    _messageController.clear();
    context.read<FridgeAiCubit>().sendMessage(text);
  }

  Future<void> _attachImage() async {
    final source = await showFridgeAiImageSourceSheet(context);
    if (!mounted || source == null) return;

    try {
      final file = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (!mounted || file == null) return;
      context.read<FridgeAiCubit>().setPendingImage(
            path: file.path,
            name: file.name,
          );
    } catch (error, stackTrace) {
      printDebug(
        message: 'fridge_ai pickImage: $error',
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      AppSnackBar.show(context, LocaleKeys.anErrorOccurred.tr());
    }
  }

  Widget _emptyBody(FridgeAiState state, FridgeAiCubit cubit) {
    if (state.emptyPhase == FridgeAiEmptyPhase.welcome) {
      return SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 8),
        child: FridgeAiWelcomeContent(
          onSelectMode: state.isBusy ? (_) {} : cubit.selectMode,
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 8),
      child: FridgeAiEmptyContent(
        mode: state.mode,
        onPromptTap: state.isBusy ? (_) {} : _send,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: BlocConsumer<FridgeAiCubit, FridgeAiState>(
          listenWhen: (previous, current) =>
              previous.toastId != current.toastId &&
              current.toastMessage != null,
          listener: (context, state) {
            AppSnackBar.show(context, state.toastMessage!);
          },
          builder: (context, state) {
            final hint = state.mode == FridgeAiMode.addFood
                ? LocaleKeys.fridgeAiComposerHintAdd.tr()
                : LocaleKeys.fridgeAiComposerHintUse.tr();
            final cubit = context.read<FridgeAiCubit>();
            final showSuccess = state.showSuccess;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FridgeAiHeader(onHistory: state.isBusy ? null : _openHistory),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 12),
                  child: FridgeAiModeSegment(
                    mode: state.mode,
                    onChanged:
                        state.isBusy || showSuccess ? (_) {} : cubit.selectMode,
                  ),
                ),
                Expanded(
                  child: showSuccess
                      ? FridgeAiSuccessContent(
                          mode: state.mode,
                          items: state.confirmedItems,
                          onViewFridge: () {
                            Navigator.of(context).popUntil(
                              (route) =>
                                  route.isFirst ||
                                  route.settings.name == AppRoute.home,
                            );
                          },
                          onContinue: cubit.startNewChat,
                        )
                      : state.hasConversation
                          ? FridgeAiConversationView(
                              messages: state.messages,
                              isSending: state.status == FridgeAiStatus.sending,
                              isConfirming:
                                  state.status == FridgeAiStatus.confirming,
                              onConfirmItems: (message) => cubit
                                  .confirmProposedItems(message.proposedItems!),
                              onConfirmConsumptions: (message) =>
                                  cubit.confirmProposedConsumptions(
                                message.proposedConsumptions!,
                              ),
                              onQuickReply: (reply) {
                                if (reply.message != null) {
                                  _send(reply.message);
                                }
                              },
                              onClarificationOther: () =>
                                  _composerFocus.requestFocus(),
                              onClarificationCancel: (message) {
                                final cancel =
                                    message.clarification?.cancelMessage;
                                if (cancel != null && cancel.isNotEmpty) {
                                  _send(cancel);
                                } else {
                                  cubit.startNewChat();
                                }
                              },
                            )
                          : _emptyBody(state, cubit),
                ),
                if (!showSuccess) ...[
                  if (state.hasPendingImage)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        20,
                        0,
                        20,
                        8,
                      ),
                      child: FridgeAiPendingImagePreview(
                        path: state.pendingImagePath!,
                        onRemove: cubit.clearPendingImage,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 4),
                    child: FridgeAiMessageComposer(
                      hint: state.hasPendingImage
                          ? LocaleKeys.fridgeAiComposerHintImage.tr()
                          : hint,
                      controller: _messageController,
                      focusNode: _composerFocus,
                      enabled: !state.isBusy,
                      onAttachImage: state.isBusy ? () {} : _attachImage,
                      onMic: () =>
                          AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
                      onSend: state.isBusy ? () {} : _send,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
