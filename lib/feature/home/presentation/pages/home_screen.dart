import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/feature/home/presentation/logic/home_cubit.dart';
import 'package:fridgy/feature/home/presentation/logic/home_state.dart';
import 'package:fridgy/feature/home/presentation/widgets/home_error_view.dart';
import 'package:fridgy/feature/home/presentation/widgets/home_scroll_content.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        switch (state.status) {
          case HomeStatus.failure:
            return HomeErrorView(
              message: state.message ?? LocaleKeys.anErrorOccurred.tr(),
              onRetry: () => context.read<HomeCubit>().load(),
            );
          case HomeStatus.loading:
            return Skeletonizer(
              enabled: true,
              child: HomeScrollContent(
                dashboard: HomeCubit.skeletonDashboard(),
                user: state.user,
                onRefresh: () => context.read<HomeCubit>().refresh(),
              ),
            );
          case HomeStatus.loaded:
            final dashboard = state.dashboard;
            if (dashboard == null) {
              return HomeErrorView(
                message: LocaleKeys.anErrorOccurred.tr(),
                onRetry: () => context.read<HomeCubit>().load(),
              );
            }
            return HomeScrollContent(
              dashboard: dashboard,
              user: state.user,
              onRefresh: () => context.read<HomeCubit>().refresh(),
            );
        }
      },
    );
  }
}
