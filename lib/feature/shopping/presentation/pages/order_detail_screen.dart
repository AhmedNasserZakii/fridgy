import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/fixed_bottom_actions.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/shopping/domain/entities/order_status.dart';
import 'package:fridgy/feature/shopping/presentation/logic/order_detail_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/order_detail_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailCubit, OrderDetailState>(
      listenWhen: (p, c) => p.actionStatus != c.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == OrderDetailActionStatus.failure &&
            state.message != null) {
          AppSnackBar.show(context, state.message!);
        }
        if (state.actionStatus == OrderDetailActionStatus.intakeReady &&
            state.intake != null) {
          Navigator.of(
            context,
          ).pushNamed(AppRoute.shoppingFridgeIntake, arguments: state.intake);
        }
      },
      builder: (context, state) {
        final cubit = context.read<OrderDetailCubit>();
        final canComplete =
            state.order?.canMarkReceived == true ||
            state.order?.status == OrderStatus.received;
        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BackTitleHeader(
                    title: LocaleKeys.shoppingOrderDetail.tr(),
                  ),
                ),
                Expanded(child: _body(context, cubit, state)),
                if (state.status == OrderDetailStatus.success &&
                    state.order?.status != OrderStatus.addedToFridge &&
                    canComplete)
                  FixedBottomActions(
                    primaryLabel: LocaleKeys.shoppingMarkReceived.tr(),
                    onPrimaryPressed:
                        state.actionStatus == OrderDetailActionStatus.working
                        ? null
                        : cubit.markReceived,
                    isPrimaryLoading:
                        state.actionStatus == OrderDetailActionStatus.working,
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
    OrderDetailCubit cubit,
    OrderDetailState state,
  ) {
    switch (state.status) {
      case OrderDetailStatus.failure:
        return InlineErrorView(
          message: state.message ?? LocaleKeys.shoppingLoadFailed.tr(),
          onRetry: () => cubit.load(orderId),
        );
      case OrderDetailStatus.loading:
        return const Skeletonizer(
          enabled: true,
          child: ListTile(title: Text('Order'), subtitle: Text('lines')),
        );
      case OrderDetailStatus.success:
        final order = state.order!;
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              LocaleKeys.shoppingOrderId.tr(args: [order.id]),
              style: AppTextStyles.titleBold20,
            ),
            const SizedBox(height: 4),
            Text(
              _statusLabel(order.status),
              style: AppTextStyles.secondaryBodyRegular14Text,
            ),
            const SizedBox(height: 16),
            for (final item in order.items) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: Text(
                  '${item.name} · ${item.quantity} ${FoodItemFormatters.unitLabel(item.unit)}',
                  style: AppTextStyles.bodySemiBold16,
                ),
              ),
            ],
            Text(
              '${order.total} ${order.currency}',
              style: AppTextStyles.titleBold20,
            ),
          ],
        );
    }
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return LocaleKeys.shoppingOrderStatusPlaced.tr();
      case OrderStatus.received:
        return LocaleKeys.shoppingOrderStatusReceived.tr();
      case OrderStatus.addedToFridge:
        return LocaleKeys.shoppingOrderStatusAdded.tr();
    }
  }
}
