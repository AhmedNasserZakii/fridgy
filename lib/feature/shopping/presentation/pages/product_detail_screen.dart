import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/custom_network_image.dart';
import 'package:fridgy/core/shared_widgets/fixed_bottom_actions.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/shopping/presentation/logic/product_detail_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/product_detail_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailCubit, ProductDetailState>(
      listenWhen: (p, c) => p.actionStatus != c.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == ProductDetailActionStatus.failure &&
            state.message != null) {
          AppSnackBar.show(context, state.message!);
        }
        if (state.actionStatus == ProductDetailActionStatus.addedToCart) {
          AppSnackBar.show(context, LocaleKeys.shoppingAddedToCart.tr());
        }
        if (state.actionStatus == ProductDetailActionStatus.addedToList) {
          AppSnackBar.show(context, LocaleKeys.shoppingAddedToList.tr());
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProductDetailCubit>();
        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BackTitleHeader(
                    title: LocaleKeys.shoppingProductDetail.tr(),
                  ),
                ),
                Expanded(child: _body(context, cubit, state)),
                if (state.status == ProductDetailStatus.success)
                  FixedBottomActions(
                    primaryLabel: LocaleKeys.shoppingAddToCart.tr(),
                    onPrimaryPressed:
                        state.actionStatus == ProductDetailActionStatus.working
                            ? null
                            : cubit.addToCart,
                    isPrimaryLoading:
                        state.actionStatus == ProductDetailActionStatus.working,
                    secondaryLabel: LocaleKeys.shoppingAddToList.tr(),
                    onSecondaryPressed:
                        state.actionStatus == ProductDetailActionStatus.working
                            ? null
                            : cubit.addToList,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _body(
    BuildContext context,
    ProductDetailCubit cubit,
    ProductDetailState state,
  ) {
    switch (state.status) {
      case ProductDetailStatus.failure:
        return InlineErrorView(
          message: state.message ?? LocaleKeys.shoppingLoadFailed.tr(),
          onRetry: () => cubit.load(productId),
        );
      case ProductDetailStatus.loading:
        return const Skeletonizer(
          enabled: true,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 200, width: double.infinity),
                SizedBox(height: 16),
                Text('Product name placeholder'),
              ],
            ),
          ),
        );
      case ProductDetailStatus.success:
        final product = state.product!;
        final price = product.price;
        final priceText = price == null
            ? ''
            : '${price == price.roundToDouble() ? price.round() : price} ${product.currency ?? ''}';
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: CustomNetworkImage(
                  imageUrl: product.imageUrl ?? '',
                  placeholderColor: AppColors.backgroundSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(product.name, style: AppTextStyles.titleBold20),
            const SizedBox(height: 4),
            Text(
              FoodItemFormatters.categoryLabel(product.category),
              style: AppTextStyles.secondaryBodyRegular14Text,
            ),
            if (priceText.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(priceText, style: AppTextStyles.bodySemiBold16),
            ],
            const SizedBox(height: 20),
            Text(
              LocaleKeys.quantityLabel.tr(),
              style: AppTextStyles.secondaryBodyRegular14Text,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: state.quantity > 1
                      ? () => cubit.quantityChanged(state.quantity - 1)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('${state.quantity}', style: AppTextStyles.titleBold20),
                IconButton(
                  onPressed: () => cubit.quantityChanged(state.quantity + 1),
                  icon: const Icon(Icons.add_circle_outline),
                ),
                const SizedBox(width: 8),
                Text(
                  FoodItemFormatters.unitLabel(product.unit),
                  style: AppTextStyles.secondaryBodyRegular14Text,
                ),
              ],
            ),
          ],
        );
    }
  }
}
