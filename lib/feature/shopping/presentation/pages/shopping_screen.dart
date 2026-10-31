import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/shopping/domain/entities/shopping_hub_tab.dart';
import 'package:fridgy/feature/shopping/presentation/logic/cart_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/cart_state.dart';
import 'package:fridgy/feature/shopping/presentation/logic/shopping_hub_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/shopping_list_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/shopping_list_state.dart';
import 'package:fridgy/feature/shopping/presentation/widgets/catalog/catalog_panel.dart';
import 'package:fridgy/feature/shopping/presentation/widgets/hub/shopping_hub_header.dart';
import 'package:fridgy/feature/shopping/presentation/widgets/hub/shopping_hub_segment.dart';
import 'package:fridgy/feature/shopping/presentation/widgets/list/shopping_list_panel.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ShoppingListCubit, ShoppingListState>(
          listenWhen: (previous, current) =>
              previous.actionStatus != current.actionStatus,
          listener: (context, state) {
            if (state.actionStatus == ShoppingListActionStatus.failure &&
                state.message != null) {
              AppSnackBar.show(context, state.message!);
            }
            if (state.actionStatus == ShoppingListActionStatus.success &&
                state.intake != null) {
              final intake = state.intake!;
              context.read<ShoppingListCubit>().clearAction();
              Navigator.of(context)
                  .pushNamed(AppRoute.shoppingFridgeIntake, arguments: intake)
                  .then((_) {
                    if (context.mounted) {
                      context.read<ShoppingListCubit>().load();
                    }
                  });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.surfaceDefault,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 8, 0),
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, cartState) {
                  return ShoppingHubHeader(
                    cartCount: cartState.cart?.itemCount ?? 0,
                    onCartTap: () =>
                        Navigator.of(context).pushNamed(AppRoute.shoppingCart),
                    onOrdersTap: () =>
                        Navigator.of(context)
                            .pushNamed(AppRoute.shoppingOrders),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: BlocBuilder<ShoppingHubCubit, ShoppingHubTab>(
                builder: (context, tab) {
                  return ShoppingHubSegment(
                    tab: tab,
                    onChanged: context.read<ShoppingHubCubit>().select,
                  );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<ShoppingHubCubit, ShoppingHubTab>(
                builder: (context, tab) {
                  if (tab == ShoppingHubTab.list) {
                    return ShoppingListPanel(
                      onAddTap: () async {
                        final added = await Navigator.of(context)
                            .pushNamed(AppRoute.shoppingAddListItem);
                        if (added == true && context.mounted) {
                          context.read<ShoppingListCubit>().load();
                        }
                      },
                    );
                  }
                  return CatalogPanel(
                    onProductTap: (id) {
                      Navigator.of(context).pushNamed(
                        AppRoute.shoppingProductDetail,
                        arguments: id,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
