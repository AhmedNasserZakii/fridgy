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
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/shopping/presentation/logic/cart_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/cart_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listenWhen: (p, c) => p.actionStatus != c.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == CartActionStatus.failure &&
            state.message != null) {
          AppSnackBar.show(context, state.message!);
        }
        if (state.actionStatus == CartActionStatus.orderPlaced &&
            state.placedOrder != null) {
          AppSnackBar.show(context, LocaleKeys.shoppingOrderPlaced.tr());
          Navigator.of(context).pushReplacementNamed(
            AppRoute.shoppingOrderDetail,
            arguments: state.placedOrder!.id,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BackTitleHeader(title: LocaleKeys.shoppingCart.tr()),
                ),
                Expanded(child: _body(context, cubit, state)),
                if (state.status == CartStatus.success)
                  FixedBottomActions(
                    primaryLabel: LocaleKeys.shoppingPlaceOrder.tr(),
                    onPrimaryPressed:
                        state.actionStatus == CartActionStatus.working
                            ? null
                            : cubit.placeOrder,
                    isPrimaryLoading:
                        state.actionStatus == CartActionStatus.working,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, CartCubit cubit, CartState state) {
    switch (state.status) {
      case CartStatus.failure:
        return InlineErrorView(
          message: state.message ?? LocaleKeys.shoppingLoadFailed.tr(),
          onRetry: cubit.load,
        );
      case CartStatus.empty:
        return Center(
          child: Text(
            LocaleKeys.shoppingCartEmpty.tr(),
            style: AppTextStyles.secondaryBodyRegular14Text,
          ),
        );
      case CartStatus.loading:
        return const Skeletonizer(
          enabled: true,
          child: ListTile(title: Text('Cart item'), subtitle: Text('qty')),
        );
      case CartStatus.success:
        final cart = state.cart!;
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: cart.items.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index == cart.items.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  LocaleKeys.shoppingSubtotal.tr(
                    args: ['${cart.subtotal} ${cart.currency}'],
                  ),
                  style: AppTextStyles.titleBold20,
                ),
              );
            }
            final item = cart.items[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Row(
                children: [
                  CustomNetworkImage(
                    imageUrl: item.imageUrl ?? '',
                    width: 56,
                    height: 56,
                    borderRadius: 10,
                    placeholderColor: AppColors.backgroundSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: AppTextStyles.bodySemiBold16),
                        Text(
                          '${item.quantity} ${FoodItemFormatters.unitLabel(item.unit)}',
                          style: AppTextStyles.secondaryBodyRegular14Text,
                        ),
                        Text(
                          '${item.lineTotal} ${item.currency}',
                          style: AppTextStyles.secondaryBodyRegular14Text,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => cubit.removeItem(item.id),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            );
          },
        );
    }
  }
}
