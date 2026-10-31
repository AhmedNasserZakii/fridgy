import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/shared_widgets/primary_button.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/feature/shopping/domain/entities/shopping_list_item_entity.dart';
import 'package:fridgy/feature/shopping/presentation/logic/shopping_list_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/shopping_list_state.dart';
import 'package:fridgy/feature/shopping/presentation/widgets/list/shopping_list_empty_view.dart';
import 'package:fridgy/feature/shopping/presentation/widgets/list/shopping_list_row.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShoppingListPanel extends StatelessWidget {
  const ShoppingListPanel({required this.onAddTap, super.key});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final cubit = context.read<ShoppingListCubit>();
        switch (state.status) {
          case ShoppingListStatus.failure:
            return InlineErrorView(
              message: state.message ?? LocaleKeys.shoppingLoadFailed.tr(),
              onRetry: cubit.load,
            );
          case ShoppingListStatus.loading:
            return Skeletonizer(
              enabled: true,
              child: _ListBody(
                items: List.generate(
                  4,
                  (i) => ShoppingListItemEntity(
                    id: 'sk_$i',
                    name: 'Loading item',
                    quantity: 1,
                    isChecked: false,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                ),
                checkedCount: 0,
                onToggle: (_) {},
                onDelete: (_) {},
                onComplete: null,
                onAddTap: onAddTap,
                working: false,
              ),
            );
          case ShoppingListStatus.empty:
            return ShoppingListEmptyView(onAddTap: onAddTap);
          case ShoppingListStatus.success:
            return _ListBody(
              items: state.items,
              checkedCount: state.checkedCount,
              onToggle: cubit.toggle,
              onDelete: cubit.delete,
              onComplete: state.checkedCount > 0
                  ? cubit.completePurchase
                  : null,
              onAddTap: onAddTap,
              working: state.actionStatus == ShoppingListActionStatus.working,
            );
        }
      },
    );
  }
}

class _ListBody extends StatelessWidget {
  const _ListBody({
    required this.items,
    required this.checkedCount,
    required this.onToggle,
    required this.onDelete,
    required this.onComplete,
    required this.onAddTap,
    required this.working,
  });

  final List<ShoppingListItemEntity> items;
  final int checkedCount;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final VoidCallback? onComplete;
  final VoidCallback onAddTap;
  final bool working;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => context.read<ShoppingListCubit>().load(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return ShoppingListRow(
                  item: item,
                  onToggle: () => onToggle(item.id),
                  onDelete: () => onDelete(item.id),
                );
              },
            ),
          ),
        ),
        ColoredBox(
          color: AppColors.surfaceDefault,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                children: [
                  if (onComplete != null) ...[
                    PrimaryButton(
                      label: LocaleKeys.shoppingCompletePurchase.tr(
                        args: ['$checkedCount'],
                      ),
                      onPressed: working ? null : onComplete,
                      isLoading: working,
                    ),
                    const SizedBox(height: 8),
                  ],
                  PrimaryButton(
                    label: LocaleKeys.shoppingAddItem.tr(),
                    onPressed: onAddTap,
                    isStroked: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
