import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/food_card.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/presentation/logic/expiring_soon_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/expiring_soon_state.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/expiring_soon_header.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/list_footer_note.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/sort_chip.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExpiringSoonScreen extends StatelessWidget {
  const ExpiringSoonScreen({super.key});

  bool _onScroll(ScrollNotification notification, ExpiringSoonCubit cubit) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 300) {
      cubit.loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpiringSoonCubit>();
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: BackTitleHeader(
                title: LocaleKeys.expiringSoonTitle.tr(),
                trailing: InkWell(
                  onTap: () =>
                      AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
                  borderRadius: BorderRadius.circular(11),
                  child: SvgPicture.asset(
                    AppAssets.icSlidersHorizontal,
                    width: 22,
                    height: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<ExpiringSoonCubit, ExpiringSoonState>(
                builder: (context, state) => _buildBody(context, cubit, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ExpiringSoonCubit cubit,
    ExpiringSoonState state,
  ) {
    switch (state.status) {
      case ExpiringSoonStatus.failure:
        return InlineErrorView(
          message: state.message ?? LocaleKeys.anErrorOccurred.tr(),
          onRetry: cubit.load,
        );
      case ExpiringSoonStatus.loading:
        return _buildSkeleton();
      case ExpiringSoonStatus.empty:
        return _buildEmpty(cubit);
      case ExpiringSoonStatus.success:
      case ExpiringSoonStatus.loadingMore:
        return _buildList(context, cubit, state);
    }
  }

  Widget _buildList(
    BuildContext context,
    ExpiringSoonCubit cubit,
    ExpiringSoonState state,
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
            ExpiringSoonHeader(total: state.total),
            const SizedBox(height: 16),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SortChip(label: LocaleKeys.sortSoonestFirst.tr()),
            ),
            const SizedBox(height: 16),
            for (final item in state.items) ...[
              FoodCard(
                item: item,
                onTap: () =>
                    AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
              ),
              const SizedBox(height: 16),
            ],
            if (state.status == ExpiringSoonStatus.loadingMore)
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
            ListFooterNote(text: LocaleKeys.expiringFooterNote.tr()),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(ExpiringSoonCubit cubit) {
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
                  LocaleKeys.expiringEmpty.tr(),
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
    final items = ExpiringSoonCubit.skeletonItems();
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
        children: [
          Text('Items to enjoy first', style: AppTextStyles.bodyRegular16),
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SortChip(label: LocaleKeys.sortSoonestFirst.tr()),
          ),
          const SizedBox(height: 16),
          for (final FoodItemEntity item in items) ...[
            FoodCard(item: item),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
