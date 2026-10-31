import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/my_fridge/filter_chip_text.dart';
import 'package:fridgy/feature/shopping/domain/entities/catalog_product_entity.dart';
import 'package:fridgy/feature/shopping/presentation/logic/catalog_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/catalog_state.dart';
import 'package:fridgy/feature/shopping/presentation/widgets/catalog/catalog_product_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CatalogPanel extends StatefulWidget {
  const CatalogPanel({required this.onProductTap, super.key});

  final ValueChanged<String> onProductTap;

  @override
  State<CatalogPanel> createState() => _CatalogPanelState();
}

class _CatalogPanelState extends State<CatalogPanel> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<CatalogCubit>().state.query,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification, CatalogCubit cubit) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 240) {
      cubit.loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CatalogCubit>();
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: cubit.queryChanged,
                decoration: InputDecoration(
                  hintText: LocaleKeys.shoppingSearchCatalog.tr(),
                  filled: true,
                  fillColor: AppColors.backgroundSecondary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  FilterChipText(
                    label: LocaleKeys.categoryAllFood.tr(),
                    selected: state.category == null,
                    onTap: () => cubit.categoryChanged(null),
                  ),
                  const SizedBox(width: 8),
                  for (final category in FoodCategory.values) ...[
                    FilterChipText(
                      label: FoodItemFormatters.categoryLabel(category),
                      selected: state.category == category,
                      onTap: () => cubit.categoryChanged(category),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildBody(context, cubit, state)),
          ],
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    CatalogCubit cubit,
    CatalogState state,
  ) {
    switch (state.status) {
      case CatalogStatus.failure:
        return InlineErrorView(
          message: state.message ?? LocaleKeys.shoppingLoadFailed.tr(),
          onRetry: cubit.load,
        );
      case CatalogStatus.empty:
        return Center(
          child: Text(
            LocaleKeys.shoppingCatalogEmpty.tr(),
            style: AppTextStyles.secondaryBodyRegular14Text,
          ),
        );
      case CatalogStatus.loading:
        return Skeletonizer(
          enabled: true,
          child: _Grid(
            items: List.generate(
              6,
              (i) => CatalogProductEntity(
                id: 'sk_$i',
                name: 'Product name',
                defaultQuantity: 1,
              ),
            ),
            onProductTap: (_) {},
            onNotification: (_) => false,
          ),
        );
      case CatalogStatus.loadingMore:
      case CatalogStatus.success:
        return _Grid(
          items: state.items,
          onProductTap: widget.onProductTap,
          onNotification: (n) => _onScroll(n, cubit),
        );
    }
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.items,
    required this.onProductTap,
    required this.onNotification,
  });

  final List<CatalogProductEntity> items;
  final ValueChanged<String> onProductTap;
  final NotificationListenerCallback<ScrollNotification> onNotification;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
          return CatalogProductCard(
            product: product,
            onTap: () => onProductTap(product.id),
          );
        },
      ),
    );
  }
}
