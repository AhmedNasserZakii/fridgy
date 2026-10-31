import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/presentation/logic/my_fridge_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/my_fridge_state.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/category_filter_row.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/filter_sheet.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/fridge_empty_view.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/fridge_search_field.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/my_fridge_header.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/out_of_stock_banner.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/rest_section.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/storage_filter_row.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/use_soon_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyFridgeScreen extends StatefulWidget {
  const MyFridgeScreen({
    required this.onAddTap,
    required this.onItemTap,
    super.key,
  });

  final VoidCallback onAddTap;
  final ValueChanged<String> onItemTap;

  @override
  State<MyFridgeScreen> createState() => _MyFridgeScreenState();
}

class _MyFridgeScreenState extends State<MyFridgeScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<MyFridgeCubit>().state.query,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification, MyFridgeCubit cubit) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 300) {
      cubit.loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyFridgeCubit>();
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: BlocConsumer<MyFridgeCubit, MyFridgeState>(
        listenWhen: (previous, current) => previous.query != current.query,
        listener: (context, state) {
          if (_searchController.text != state.query) {
            _searchController.text = state.query;
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 12, 0),
                child: MyFridgeHeader(onAddTap: widget.onAddTap),
              ),
              Expanded(child: _buildBody(context, cubit, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MyFridgeCubit cubit,
    MyFridgeState state,
  ) {
    switch (state.status) {
      case MyFridgeStatus.failure:
        return InlineErrorView(
          message: state.message ?? LocaleKeys.inventoryLoadFailed.tr(),
          onRetry: cubit.load,
        );
      case MyFridgeStatus.loading:
        return _buildLoading(cubit, state);
      case MyFridgeStatus.empty:
        return _buildEmptyShell(cubit, state, fullEmpty: true);
      case MyFridgeStatus.success:
      case MyFridgeStatus.loadingMore:
        if (state.showFridgeEmpty) {
          return _buildEmptyShell(cubit, state, fullEmpty: false);
        }
        return _buildList(context, cubit, state);
    }
  }

  Widget _buildFilters(MyFridgeCubit cubit, MyFridgeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  LocaleKeys.activeItemsCount.tr(
                    args: ['${state.activeCount}'],
                  ),
                  style: AppTextStyles.secondaryBodyRegular14Text,
                ),
              ),
              TextButton(
                onPressed: () => showMyFridgeFilterSheet(
                  context: context,
                  cubit: cubit,
                  state: state,
                ),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  LocaleKeys.sortAndFilter.tr(),
                  style: AppTextStyles.bodySemiBold16Brand,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: StorageFilterRow(
            selected: state.storage,
            onSelected: cubit.setStorage,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: FridgeSearchField(
            controller: _searchController,
            onChanged: cubit.setQuery,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: CategoryFilterRow(
            selected: state.category,
            onSelected: cubit.setCategory,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildList(
    BuildContext context,
    MyFridgeCubit cubit,
    MyFridgeState state,
  ) {
    return RefreshIndicator(
      color: AppColors.brandPrimary,
      onRefresh: cubit.refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) => _onScroll(n, cubit),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsetsDirectional.only(bottom: 24),
          children: [
            _buildFilters(cubit, state),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: UseSoonSection(
                items: state.useSoonItems,
                onItemTap: widget.onItemTap,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: RestSection(
                items: state.restItems,
                onItemTap: widget.onItemTap,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: OutOfStockBanner(
                items: state.outOfStockItems,
                activeCount: state.activeCount,
              ),
            ),
            if (state.status == MyFridgeStatus.loadingMore)
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

  Widget _buildLoading(MyFridgeCubit cubit, MyFridgeState state) {
    final items = MyFridgeCubit.skeletonItems();
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsetsDirectional.only(bottom: 24),
        children: [
          _buildFilters(cubit, state),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
            child: UseSoonSection(items: items, onItemTap: (_) {}),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyShell(
    MyFridgeCubit cubit,
    MyFridgeState state, {
    required bool fullEmpty,
  }) {
    return RefreshIndicator(
      color: AppColors.brandPrimary,
      onRefresh: cubit.refresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFilters(cubit, state),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 20,
                      ),
                      child: SizedBox(
                        height: fullEmpty ? constraints.maxHeight - 280 : 420,
                        child: FridgeEmptyView(onAddTap: widget.onAddTap),
                      ),
                    ),
                    if (!fullEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 20,
                        ),
                        child: OutOfStockBanner(
                          items: state.outOfStockItems,
                          activeCount: state.activeCount,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
