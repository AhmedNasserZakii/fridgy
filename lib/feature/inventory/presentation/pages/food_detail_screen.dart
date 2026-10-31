import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/back_title_header.dart';
import 'package:fridgy/core/shared_widgets/fixed_bottom_actions.dart';
import 'package:fridgy/core/shared_widgets/inline_error_view.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/theme/styles/app_text_styles.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/inventory/presentation/logic/food_detail_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/food_detail_state.dart';
import 'package:fridgy/feature/inventory/presentation/utils/food_item_formatters.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/detail_info_card.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/detail_info_row.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/detail_status_chips.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/food_detail_hero_image.dart';
import 'package:fridgy/feature/inventory/presentation/widgets/food_flow/guidance_box.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodDetailCubit, FoodDetailState>(
      listenWhen: (prev, curr) =>
          prev.consumeSucceeded != curr.consumeSucceeded ||
          prev.message != curr.message,
      listener: (context, state) {
        if (state.consumeSucceeded) {
          Navigator.of(context).pop(true);
          return;
        }
        if (state.message != null && !state.consumeLoading) {
          AppSnackBar.show(context, state.message!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<FoodDetailCubit>();

        if (state.status == FoodDetailStatus.failure) {
          return Scaffold(
            backgroundColor: AppColors.surfaceDefault,
            body: SafeArea(
              child: InlineErrorView(
                message: state.message ?? LocaleKeys.inventoryLoadFailed.tr(),
                onRetry: () => cubit.load(itemId),
              ),
            ),
          );
        }

        final loading = state.status == FoodDetailStatus.loading ||
            state.status == FoodDetailStatus.initial;
        final item = state.item;

        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20,
                  ),
                  child: BackTitleHeader(
                    title: LocaleKeys.foodDetailsTitle.tr(),
                    trailing: InkWell(
                      onTap: loading || item == null
                          ? null
                          : () => Navigator.of(context).pushNamed(
                                AppRoute.foodEdit,
                                arguments: item.id,
                              ),
                      borderRadius: BorderRadius.circular(11),
                      child: SvgPicture.asset(
                        AppAssets.icPencilLine,
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Skeletonizer(
                    enabled: loading,
                    child: SingleChildScrollView(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        20,
                        8,
                        20,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FoodDetailHeroImage(imageUrl: item?.imageUrl),
                          const SizedBox(height: 16),
                          if (item != null) DetailStatusChips(item: item),
                          const SizedBox(height: 12),
                          Text(
                            item?.name ?? 'Food item name',
                            style: AppTextStyles.headlineBold30,
                          ),
                          const SizedBox(height: 16),
                          DetailInfoCard(
                            children: [
                              DetailInfoRow(
                                label: LocaleKeys.quantityRemaining.tr(),
                                value: item == null
                                    ? '—'
                                    : FoodItemFormatters.quantityLabel(item),
                              ),
                              DetailInfoRow(
                                label: LocaleKeys.storageLabel.tr(),
                                value: item == null
                                    ? '—'
                                    : FoodItemFormatters.storageLabel(
                                        item.storage,
                                      ),
                              ),
                              DetailInfoRow(
                                label: LocaleKeys.expirationDateLabel.tr(),
                                value: item?.expiryDate == null
                                    ? '—'
                                    : DateFormat(
                                        'd MMM yyyy',
                                      ).format(item!.expiryDate!),
                              ),
                              DetailInfoRow(
                                label: LocaleKeys.purchasedOn.tr(),
                                value: item?.purchaseDate == null
                                    ? '—'
                                    : DateFormat(
                                        'd MMM yyyy',
                                      ).format(item!.purchaseDate!),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          GuidanceBox(
                            text: LocaleKeys.foodDetailGuidance.tr(),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: TextButton(
                              onPressed: () => AppSnackBar.show(
                                context,
                                LocaleKeys.comingSoon.tr(),
                              ),
                              child: Text(
                                LocaleKeys.deleteFoodItem.tr(),
                                style: AppTextStyles.errorCaptionRegular12
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                FixedBottomActions(
                  primaryLabel: LocaleKeys.markAsConsumed.tr(),
                  isPrimaryLoading: state.consumeLoading,
                  onPrimaryPressed:
                      loading || item == null || state.consumeLoading
                          ? null
                          : cubit.consume,
                  secondaryLabel: LocaleKeys.findARecipe.tr(),
                  onSecondaryPressed: () => AppSnackBar.show(
                    context,
                    LocaleKeys.comingSoon.tr(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
