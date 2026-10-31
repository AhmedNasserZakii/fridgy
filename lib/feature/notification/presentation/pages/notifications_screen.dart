import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/notification/domain/entities/notification_entity.dart';
import 'package:fridgy/feature/notification/presentation/logic/notification_group.dart';
import 'package:fridgy/feature/notification/presentation/logic/notifications_cubit.dart';
import 'package:fridgy/feature/notification/presentation/logic/notifications_state.dart';
import 'package:fridgy/feature/notification/presentation/widgets/notification_card.dart';
import 'package:fridgy/feature/notification/presentation/widgets/notification_group_header.dart';
import 'package:fridgy/feature/notification/presentation/widgets/unread_chip.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  bool _onScroll(ScrollNotification notification, NotificationsCubit cubit) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 300) {
      cubit.loadMore();
    }
    return false;
  }

  void _onNotificationTap(
    BuildContext context,
    NotificationsCubit cubit,
    NotificationEntity notification,
  ) {
    cubit.markRead(notification.id);
    if (notification.action != null) {
      // D7 / D11: no destination screen yet.
      AppSnackBar.show(context, LocaleKeys.comingSoon.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: BlocConsumer<NotificationsCubit, NotificationsState>(
          listenWhen: (previous, current) =>
              previous.messageId != current.messageId &&
              current.message != null &&
              current.status != NotificationsStatus.failure,
          listener: (context, state) =>
              AppSnackBar.show(context, state.message!),
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20,
                  ),
                  child: BackTitleHeader(
                    title: LocaleKeys.notificationsScreenTitle.tr(),
                    trailing: InkWell(
                      onTap: cubit.markAllRead,
                      borderRadius: BorderRadius.circular(11),
                      child: SvgPicture.asset(
                        AppAssets.icCheckCheck,
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(child: _buildBody(context, cubit, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationsCubit cubit,
    NotificationsState state,
  ) {
    switch (state.status) {
      case NotificationsStatus.failure:
        return InlineErrorView(
          message: state.message ?? LocaleKeys.anErrorOccurred.tr(),
          onRetry: cubit.load,
        );
      case NotificationsStatus.loading:
        return _buildSkeleton();
      case NotificationsStatus.empty:
        return _buildEmpty(cubit);
      case NotificationsStatus.success:
      case NotificationsStatus.loadingMore:
        return _buildList(context, cubit, state);
    }
  }

  Widget _buildList(
    BuildContext context,
    NotificationsCubit cubit,
    NotificationsState state,
  ) {
    return RefreshIndicator(
      color: AppColors.brandPrimary,
      onRefresh: cubit.refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) => _onScroll(n, cubit),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
          children: [
            if (state.unreadCount > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UnreadChip(count: state.unreadCount),
                  GestureDetector(
                    onTap: cubit.markAllRead,
                    child: Text(
                      LocaleKeys.markAllAsRead.tr(),
                      style: AppTextStyles.secondaryBodyRegular14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            for (final NotificationGroup group in state.groups) ...[
              NotificationGroupHeader(date: group.date),
              const SizedBox(height: 16),
              for (final notification in group.items) ...[
                NotificationCard(
                  notification: notification,
                  onTap: () => _onNotificationTap(context, cubit, notification),
                ),
                const SizedBox(height: 16),
              ],
            ],
            if (state.status == NotificationsStatus.loadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.brandPrimary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(NotificationsCubit cubit) {
    return RefreshIndicator(
      color: AppColors.brandPrimary,
      onRefresh: cubit.refresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
                child: Text(
                  LocaleKeys.notificationsEmpty.tr(),
                  style: AppTextStyles.secondaryBodyRegular14Text,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    final items = NotificationsCubit.skeletonItems();
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
        children: [
          NotificationGroupHeader(date: DateTime.now()),
          const SizedBox(height: 16),
          for (final notification in items) ...[
            NotificationCard(notification: notification, onTap: () {}),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
