import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/shopping/domain/entities/order_status.dart';
import 'package:fridgy/feature/shopping/presentation/logic/orders_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/orders_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BackTitleHeader(title: LocaleKeys.shoppingOrders.tr()),
            ),
            Expanded(
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  final cubit = context.read<OrdersCubit>();
                  switch (state.status) {
                    case OrdersStatus.failure:
                      return InlineErrorView(
                        message:
                            state.message ?? LocaleKeys.shoppingLoadFailed.tr(),
                        onRetry: cubit.load,
                      );
                    case OrdersStatus.empty:
                      return Center(
                        child: Text(
                          LocaleKeys.shoppingOrdersEmpty.tr(),
                          style: AppTextStyles.secondaryBodyRegular14Text,
                        ),
                      );
                    case OrdersStatus.loading:
                      return Skeletonizer(
                        enabled: true,
                        child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (_, _) => const ListTile(
                            title: Text('Order'),
                            subtitle: Text('status'),
                          ),
                        ),
                      );
                    case OrdersStatus.success:
                      return RefreshIndicator(
                        onRefresh: cubit.load,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          itemCount: state.orders.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final order = state.orders[index];
                            return Material(
                              color: AppColors.surfaceDefault,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => Navigator.of(context).pushNamed(
                                  AppRoute.shoppingOrderDetail,
                                  arguments: order.id,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.borderDefault,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              LocaleKeys.shoppingOrderId.tr(
                                                args: [order.id],
                                              ),
                                              style:
                                                  AppTextStyles.bodySemiBold16,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _statusLabel(order.status),
                                              style: AppTextStyles
                                                  .secondaryBodyRegular14Text,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${order.total} ${order.currency}',
                                        style: AppTextStyles.bodySemiBold16,
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
                },
              ),
            ),
          ],
        ),
      ),
    );
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
