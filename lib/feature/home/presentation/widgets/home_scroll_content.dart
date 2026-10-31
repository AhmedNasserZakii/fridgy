import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/auth/domain/entities/user_entity.dart';
import 'package:fridgy/feature/home/domain/entities/home_dashboard_entity.dart';
import 'package:fridgy/feature/home/presentation/logic/home_cubit.dart';
import 'package:fridgy/feature/home/presentation/widgets/fridgy_suggests_card.dart';
import 'package:fridgy/feature/home/presentation/widgets/home_greeting_header.dart';
import 'package:fridgy/feature/home/presentation/widgets/home_search_field.dart';
import 'package:fridgy/feature/home/presentation/widgets/kitchen_categories_grid.dart';
import 'package:fridgy/feature/home/presentation/widgets/kitchen_overview_card.dart';
import 'package:fridgy/feature/home/presentation/widgets/quick_actions_row.dart';
import 'package:fridgy/feature/home/presentation/widgets/use_first_section.dart';
import 'package:fridgy/feature/home/presentation/widgets/weekly_impact_card.dart';
import 'package:fridgy/feature/nav_bar/presentation/logic/nav_bar_cubit.dart';

class HomeScrollContent extends StatelessWidget {
  const HomeScrollContent({
    required this.dashboard,
    required this.user,
    required this.onRefresh,
    super.key,
  });

  final HomeDashboardEntity dashboard;
  final UserEntity? user;
  final Future<void> Function() onRefresh;

  /// Opens Notifications, then refreshes Home so the bell dot and counts are
  /// correct when coming back (D12).
  Future<void> _openNotifications(BuildContext context) async {
    final homeCubit = context.read<HomeCubit>();
    await Navigator.of(context).pushNamed(AppRoute.notifications);
    await homeCubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
          child: HomeGreetingHeader(
            user: user,
            hasUnreadNotifications: dashboard.unreadNotificationsCount > 0,
            onBellTap: () => _openNotifications(context),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.brandPrimary,
            onRefresh: onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      HomeSearchField(
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoute.search),
                      ),
                      const SizedBox(height: 16),
                      KitchenOverviewCard(
                        totalItems: dashboard.totalItems,
                        expiringSoonCount: dashboard.expiringSoonCount,
                        onViewFridge: () =>
                            context.read<NavBarCubit>().select(1),
                        onExpiringTap: () => Navigator.of(
                          context,
                        ).pushNamed(AppRoute.expiringSoon),
                      ),
                      const SizedBox(height: 16),
                      const QuickActionsRow(),
                      const SizedBox(height: 16),
                      if (dashboard.totalItems == 0 &&
                          dashboard.useFirst.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            LocaleKeys.kitchenEmpty.tr(),
                            style: AppTextStyles.secondaryBodyRegular14Text,
                            textAlign: TextAlign.center,
                          ),
                        )
                      else
                        UseFirstSection(
                          items: dashboard.useFirst,
                          onSeeAll: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoute.expiringSoon),
                        ),
                      const SizedBox(height: 16),
                      const KitchenCategoriesGrid(),
                      if (dashboard.weeklyImpact != null) ...[
                        const SizedBox(height: 16),
                        WeeklyImpactCard(impact: dashboard.weeklyImpact!),
                      ],
                      if (dashboard.suggestion != null) ...[
                        const SizedBox(height: 16),
                        FridgySuggestsCard(suggestion: dashboard.suggestion!),
                      ],
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
