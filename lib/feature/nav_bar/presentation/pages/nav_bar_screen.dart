import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/constants/locale_keys.dart';
import 'package:fridgy/core/shared_widgets/app_snack_bar.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/di/service_locator.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/home/presentation/pages/home_screen.dart';
import 'package:fridgy/feature/inventory/presentation/logic/my_fridge_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/pages/my_fridge_screen.dart';
import 'package:fridgy/feature/more/presentation/pages/more_screen.dart';
import 'package:fridgy/feature/nav_bar/presentation/logic/nav_bar_cubit.dart';
import 'package:fridgy/feature/nav_bar/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:fridgy/feature/nav_bar/presentation/widgets/coming_soon_view.dart';

class NavBarScreen extends StatelessWidget {
  const NavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarCubit, int>(
      builder: (context, index) {
        return Scaffold(
          backgroundColor: AppColors.surfaceDefault,
          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: index,
              children: [
                const HomeScreen(),
                BlocProvider(
                  create: (_) => getIt<MyFridgeCubit>(),
                  child: MyFridgeScreen(
                    onAddTap: () =>
                        Navigator.of(context).pushNamed(AppRoute.addFood),
                    onItemTap: (id) =>
                        Navigator.of(context)
                            .pushNamed(AppRoute.foodDetail, arguments: id),
                  ),
                ),
                ComingSoonView(title: LocaleKeys.navShopping.tr()),
                const MoreScreen(),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: AppBottomNavBar(
              selectedIndex: index,
              onSelect: (i) => context.read<NavBarCubit>().select(i),
              onCenterTap: () =>
                  AppSnackBar.show(context, LocaleKeys.comingSoon.tr()),
            ),
          ),
        );
      },
    );
  }
}
