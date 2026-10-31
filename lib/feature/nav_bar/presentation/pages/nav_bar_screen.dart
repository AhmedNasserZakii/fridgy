import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/di/service_locator.dart';
import 'package:fridgy/core/theme/styles/app_colors.dart';
import 'package:fridgy/core/utils/app_route.dart';
import 'package:fridgy/feature/home/presentation/pages/home_screen.dart';
import 'package:fridgy/feature/inventory/presentation/logic/my_fridge_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/pages/my_fridge_screen.dart';
import 'package:fridgy/feature/more/presentation/pages/more_screen.dart';
import 'package:fridgy/feature/nav_bar/presentation/logic/nav_bar_cubit.dart';
import 'package:fridgy/feature/nav_bar/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:fridgy/feature/shopping/presentation/logic/cart_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/catalog_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/shopping_hub_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/shopping_list_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/pages/shopping_screen.dart';

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
                MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => getIt<ShoppingHubCubit>()),
                    BlocProvider(create: (_) => getIt<ShoppingListCubit>()),
                    BlocProvider(create: (_) => getIt<CatalogCubit>()),
                    BlocProvider(create: (_) => getIt<CartCubit>()),
                  ],
                  child: const ShoppingScreen(),
                ),
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
                  Navigator.of(context).pushNamed(AppRoute.fridgeAi),
            ),
          ),
        );
      },
    );
  }
}
