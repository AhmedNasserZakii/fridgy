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
import 'package:fridgy/feature/inventory/domain/entities/expiry_status.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_item_entity.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/inventory/presentation/logic/search_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/search_state.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/recent_searches_list.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/search_guidance_box.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/search_input.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/search_results_count.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onRecentTap(String query) {
    _controller.value = TextEditingValue(
      text: query,
      selection: TextSelection.collapsed(offset: query.length),
    );
    context.read<SearchCubit>().submit(query);
  }

  bool _onScroll(ScrollNotification notification, SearchCubit cubit) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 300) {
      cubit.loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: BackTitleHeader(
                title: LocaleKeys.searchScreenTitle.tr(),
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
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: SearchInput(
                controller: _controller,
                onChanged: cubit.onQueryChanged,
                onSubmitted: cubit.submit,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
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
    SearchCubit cubit,
    SearchState state,
  ) {
    switch (state.status) {
      case SearchStatus.failure:
        return InlineErrorView(
          message: state.message ?? LocaleKeys.anErrorOccurred.tr(),
          onRetry: cubit.retry,
        );
      case SearchStatus.loading:
        return _buildSkeleton();
      case SearchStatus.empty:
        return Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
            child: Text(
              LocaleKeys.searchNoMatches.tr(args: [state.query]),
              style: AppTextStyles.secondaryBodyRegular14Text,
              textAlign: TextAlign.center,
            ),
          ),
        );
      case SearchStatus.idle:
        return _buildIdle(state);
      case SearchStatus.success:
      case SearchStatus.loadingMore:
        return _buildResults(cubit, state);
    }
  }

  Widget _buildIdle(SearchState state) {
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
      children: [
        RecentSearchesList(searches: state.recentSearches, onTap: _onRecentTap),
        if (state.recentSearches.isNotEmpty) const SizedBox(height: 16),
        const SearchGuidanceBox(),
      ],
    );
  }

  Widget _buildResults(SearchCubit cubit, SearchState state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) => _onScroll(n, cubit),
      child: ListView.separated(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
        itemCount: state.items.length + 2,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return SearchResultsCount(
              count: state.total,
              firstName: state.firstName,
            );
          }
          if (index == state.items.length + 1) {
            return state.status == SearchStatus.loadingMore
                ? const Padding(
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
                  )
                : const SizedBox.shrink();
          }
          return FoodCard(
            item: state.items[index - 1],
            onTap: () => AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
          );
        },
      ),
    );
  }

  Widget _buildSkeleton() {
    final now = DateTime.now().toUtc();
    FoodItemEntity fake(String id) => FoodItemEntity(
          id: 'skeleton_$id',
          name: 'Food item name',
          quantity: 250,
          unit: FoodUnit.g,
          storage: StorageLocation.fridge,
          isPartlyUsed: false,
          expiryDate: now,
          daysLeft: 1,
          expiryStatus: ExpiryStatus.useSoon,
          addedAt: now,
        );
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
        children: [
          Text(
            'Loading matches in your kitchen',
            style: AppTextStyles.secondaryBodyRegular14Text,
          ),
          const SizedBox(height: 16),
          FoodCard(item: fake('1')),
          const SizedBox(height: 16),
          FoodCard(item: fake('2')),
          const SizedBox(height: 16),
          FoodCard(item: fake('3')),
        ],
      ),
    );
  }
}
