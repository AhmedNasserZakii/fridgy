import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/app_assets.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/shared_widgets/fixed_bottom_actions.dart';
import 'package:fridgy/core/shared_widgets/segmented_progress_bar.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_cubit.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_state.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/options_error_view.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/setup_header.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/steps/diet_step.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/steps/food_favorites_step.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/steps/kitchen_step.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/steps/notifications_step.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/steps/setup_done_step.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/steps/workout_frequency_step.dart';
import 'package:fridgy/feature/profile_setup/presentation/widgets/steps/workout_step.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileSetupCubit, ProfileSetupState>(
      listenWhen: (previous, current) =>
          previous.currentStep != current.currentStep ||
          previous.submitStatus != current.submitStatus,
      listener: (context, state) {
        if (_pageController.hasClients &&
            _pageController.page?.round() != state.currentStep) {
          _pageController.animateToPage(
            state.currentStep,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
          );
        }

        if (state.submitStatus == SubmitStatus.failure &&
            state.submitError != null) {
          AppSnackBar.show(context, state.submitError!);
        }

        if (state.isEditMode && state.submitStatus == SubmitStatus.success) {
          AppSnackBar.show(context, LocaleKeys.preferencesSaved.tr());
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfileSetupCubit>();
        final isEdit = state.isEditMode;
        final showBack = isEdit
            ? true
            : state.currentStep > 0 && state.currentStep < 6;
        final isSubmitting = state.submitStatus == SubmitStatus.loading;
        final optionsFailed =
            state.optionsStatus == OptionsStatus.failure &&
            (isEdit || state.currentStep == 1 || state.currentStep == 2);

        return PopScope(
          canPop: isEdit && state.currentStep == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            final shouldPop = cubit.back();
            if (shouldPop) {
              Navigator.of(context).maybePop();
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.surfaceDefault,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SetupHeader(
                      stepNumber: state.displayStepNumber,
                      totalSteps: state.progressSegmentCount,
                      showBack: showBack,
                      onBack: () {
                        final shouldPop = cubit.back();
                        if (shouldPop) {
                          Navigator.of(context).maybePop();
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: SegmentedProgressBar(
                      segmentCount: state.progressSegmentCount,
                      currentIndex: state.currentStep,
                    ),
                  ),
                  Expanded(
                    child: optionsFailed
                        ? OptionsErrorView(
                            message:
                                state.optionsError ??
                                LocaleKeys.optionsLoadFailed.tr(),
                            onRetry: cubit.load,
                          )
                        : PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: isEdit
                                ? const [FoodFavoritesStep(), DietStep()]
                                : const [
                                    KitchenStep(),
                                    FoodFavoritesStep(),
                                    DietStep(),
                                    WorkoutStep(),
                                    WorkoutFrequencyStep(),
                                    NotificationsStep(),
                                    SetupDoneStep(),
                                  ],
                          ),
                  ),
                  if (!optionsFailed)
                    _buildActions(context, state, cubit, isSubmitting),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActions(
    BuildContext context,
    ProfileSetupState state,
    ProfileSetupCubit cubit,
    bool isSubmitting,
  ) {
    if (state.isEditMode) {
      return FixedBottomActions(
        primaryLabel: state.currentStep == 1
            ? LocaleKeys.saveChanges.tr()
            : LocaleKeys.continueLabel.tr(),
        primaryTrailingIcon: AppAssets.icArrowRight,
        onPrimaryPressed: state.canContinue && !isSubmitting
            ? cubit.continueStep
            : null,
        isPrimaryLoading: isSubmitting,
        secondaryLabel: LocaleKeys.illDoThisLater.tr(),
        onSecondaryPressed: isSubmitting ? null : cubit.skipStep,
      );
    }

    if (state.currentStep == 6) {
      return FixedBottomActions(
        primaryLabel: LocaleKeys.letsExploreFridgy.tr(),
        primaryTrailingIcon: AppAssets.icArrowRight,
        onPrimaryPressed: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoute.home, (_) => false);
        },
      );
    }

    if (state.currentStep == 5) {
      return FixedBottomActions(
        primaryLabel: LocaleKeys.enableNotifications.tr(),
        primaryTrailingIcon: AppAssets.icArrowRight,
        onPrimaryPressed: isSubmitting ? null : cubit.enableNotifications,
        isPrimaryLoading: isSubmitting,
        secondaryLabel: LocaleKeys.maybeLater.tr(),
        onSecondaryPressed: isSubmitting ? null : cubit.maybeLater,
      );
    }

    return FixedBottomActions(
      primaryLabel: LocaleKeys.continueLabel.tr(),
      primaryTrailingIcon: AppAssets.icArrowRight,
      onPrimaryPressed: state.canContinue ? cubit.continueStep : null,
      secondaryLabel: LocaleKeys.illDoThisLater.tr(),
      onSecondaryPressed: cubit.skipStep,
    );
  }
}
