import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/conversation_summary_entity.dart';
import 'package:fridgy/feature/fridge_ai/domain/entities/fridge_ai_mode.dart';
import 'package:fridgy/feature/fridge_ai/presentation/logic/fridge_ai_history_cubit.dart';
import 'package:fridgy/feature/fridge_ai/presentation/logic/fridge_ai_history_state.dart';
import 'package:fridgy/feature/fridge_ai/presentation/widgets/fridge_ai_history_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FridgeAiHistoryScreen extends StatelessWidget {
  const FridgeAiHistoryScreen({super.key});

  static final ConversationSummaryEntity _skeletonItem =
      ConversationSummaryEntity(
    id: 'skeleton',
    mode: FridgeAiMode.addFood,
    title: 'Loading conversation title',
    preview: 'Loading conversation preview text for skeleton.',
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  bool _onScroll(ScrollNotification notification, FridgeAiHistoryCubit cubit) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 300) {
      cubit.loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FridgeAiHistoryCubit>();

    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: BackTitleHeader(
                title: LocaleKeys.fridgeAiHistoryTitle.tr(),
              ),
            ),
            Expanded(
              child: BlocBuilder<FridgeAiHistoryCubit, FridgeAiHistoryState>(
                builder: (context, state) {
                  if (state.status == FridgeAiHistoryStatus.failure &&
                      state.conversations.isEmpty) {
                    return InlineErrorView(
                      message:
                          state.errorMessage ?? LocaleKeys.anErrorOccurred.tr(),
                      onRetry: () => cubit.load(refresh: true),
                    );
                  }

                  if (state.status == FridgeAiHistoryStatus.success &&
                      state.conversations.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          LocaleKeys.fridgeAiHistoryEmpty.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyRegular16,
                        ),
                      ),
                    );
                  }

                  final loading =
                      state.status == FridgeAiHistoryStatus.loading &&
                          state.conversations.isEmpty;
                  final count = loading ? 4 : state.conversations.length;

                  return NotificationListener<ScrollNotification>(
                    onNotification: (n) => _onScroll(n, cubit),
                    child: Skeletonizer(
                      enabled: loading,
                      child: ListView.separated(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          20,
                          8,
                          20,
                          24,
                        ),
                        itemCount: count,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final conversation = loading
                              ? _skeletonItem
                              : state.conversations[index];
                          return FridgeAiHistoryTile(
                            conversation: conversation,
                            onTap: loading
                                ? () {}
                                : () =>
                                    Navigator.of(context).pop(conversation.id),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
