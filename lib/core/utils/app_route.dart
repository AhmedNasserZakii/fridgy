import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fridgy/core/di/service_locator.dart';
import 'package:fridgy/feature/auth/domain/repos/auth_repo.dart';
import 'package:fridgy/feature/auth/presentation/logic/login_cubit.dart';
import 'package:fridgy/feature/auth/presentation/logic/register_cubit.dart';
import 'package:fridgy/feature/auth/presentation/pages/sign_in_screen.dart';
import 'package:fridgy/feature/auth/presentation/pages/sign_up_screen.dart';
import 'package:fridgy/feature/fridge_ai/presentation/logic/fridge_ai_cubit.dart';
import 'package:fridgy/feature/fridge_ai/presentation/logic/fridge_ai_history_cubit.dart';
import 'package:fridgy/feature/fridge_ai/presentation/pages/fridge_ai_history_screen.dart';
import 'package:fridgy/feature/fridge_ai/presentation/pages/fridge_ai_screen.dart';
import 'package:fridgy/feature/home/presentation/logic/home_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/expiring_soon_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/food_detail_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/food_form_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/search_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/pages/add_food_screen.dart';
import 'package:fridgy/feature/inventory/presentation/pages/expiring_soon_screen.dart';
import 'package:fridgy/feature/inventory/presentation/pages/food_detail_screen.dart';
import 'package:fridgy/feature/inventory/presentation/pages/food_form_screen.dart';
import 'package:fridgy/feature/inventory/presentation/pages/search_screen.dart';
import 'package:fridgy/feature/more/presentation/logic/appearance_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/edit_profile_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/more_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/notification_settings_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/units_cubit.dart';
import 'package:fridgy/feature/more/presentation/pages/appearance_screen.dart';
import 'package:fridgy/feature/more/presentation/pages/edit_profile_screen.dart';
import 'package:fridgy/feature/more/presentation/pages/help_screen.dart';
import 'package:fridgy/feature/more/presentation/pages/notification_settings_screen.dart';
import 'package:fridgy/feature/more/presentation/pages/privacy_screen.dart';
import 'package:fridgy/feature/more/presentation/pages/units_screen.dart';
import 'package:fridgy/feature/nav_bar/presentation/logic/nav_bar_cubit.dart';
import 'package:fridgy/feature/nav_bar/presentation/pages/nav_bar_screen.dart';
import 'package:fridgy/feature/notification/presentation/logic/notifications_cubit.dart';
import 'package:fridgy/feature/notification/presentation/pages/notifications_screen.dart';
import 'package:fridgy/feature/onboarding/presentation/pages/onboarding_steps_screen.dart';
import 'package:fridgy/feature/onboarding/presentation/pages/welcome_screen.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_cubit.dart';
import 'package:fridgy/feature/profile_setup/presentation/pages/profile_setup_screen.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_entity.dart';
import 'package:fridgy/feature/shopping/presentation/logic/add_list_item_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/cart_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/fridge_intake_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/order_detail_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/orders_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/product_detail_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/pages/add_list_item_screen.dart';
import 'package:fridgy/feature/shopping/presentation/pages/cart_screen.dart';
import 'package:fridgy/feature/shopping/presentation/pages/fridge_intake_screen.dart';
import 'package:fridgy/feature/shopping/presentation/pages/order_detail_screen.dart';
import 'package:fridgy/feature/shopping/presentation/pages/orders_screen.dart';
import 'package:fridgy/feature/shopping/presentation/pages/product_detail_screen.dart';
import 'package:fridgy/feature/splash/view/splash_screen.dart';

abstract class AppRoute {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String signUp = '/sign-up';
  static const String signIn = '/sign-in';
  static const String profileSetup = '/profile-setup';
  static const String profileSetupEdit = '/profile-setup-edit';
  static const String home = '/home';
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String expiringSoon = '/expiring-soon';
  static const String addFood = '/add-food';
  static const String addFoodManual = '/add-food/manual';
  static const String foodDetail = '/inventory-detail';
  static const String foodEdit = '/inventory-edit';
  static const String editProfile = '/edit-profile';
  static const String notificationSettings = '/notification-settings';
  static const String appearance = '/appearance';
  static const String units = '/units';
  static const String privacy = '/privacy';
  static const String help = '/help';
  static const String fridgeAi = '/fridge-ai';
  static const String fridgeAiHistory = '/fridge-ai/history';
  static const String shoppingAddListItem = '/shopping/add-list-item';
  static const String shoppingProductDetail = '/shopping/product';
  static const String shoppingCart = '/shopping/cart';
  static const String shoppingOrders = '/shopping/orders';
  static const String shoppingOrderDetail = '/shopping/order';
  static const String shoppingFridgeIntake = '/shopping/fridge-intake';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              SplashScreen(onSplashFinished: () => _onSplashFinished()),
        );
      case welcome:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => WelcomeScreen(
            onGetStarted: () {
              navigatorKey.currentState?.pushNamed(onboarding);
            },
            onSignIn: () {
              navigatorKey.currentState?.pushNamed(signIn);
            },
          ),
        );
      case onboarding:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OnboardingStepsScreen(
            onFinished: () {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                signUp,
                (route) => route.settings.name == welcome,
              );
            },
            onSkip: () {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                signUp,
                (route) => route.settings.name == welcome,
              );
            },
          ),
        );
      case signUp:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<RegisterCubit>(),
            child: const SignUpScreen(),
          ),
        );
      case signIn:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: const SignInScreen(),
          ),
        );
      case profileSetup:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProfileSetupCubit>(param1: false),
            child: const ProfileSetupScreen(),
          ),
        );
      case profileSetupEdit:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProfileSetupCubit>(param1: true),
            child: const ProfileSetupScreen(),
          ),
        );
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<HomeCubit>()),
              BlocProvider(create: (_) => getIt<NavBarCubit>()),
              BlocProvider(create: (_) => getIt<MoreCubit>()),
            ],
            child: const NavBarScreen(),
          ),
        );
      case search:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<SearchCubit>(),
            child: const SearchScreen(),
          ),
        );
      case notifications:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<NotificationsCubit>(),
            child: const NotificationsScreen(),
          ),
        );
      case expiringSoon:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<ExpiringSoonCubit>(),
            child: const ExpiringSoonScreen(),
          ),
        );
      case addFood:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AddFoodScreen(),
        );
      case addFoodManual:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<FoodFormCubit>()..init(),
            child: const FoodFormScreen(),
          ),
        );
      case foodDetail:
        final itemId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<FoodDetailCubit>()..load(itemId),
            child: FoodDetailScreen(itemId: itemId),
          ),
        );
      case foodEdit:
        final itemId = settings.arguments as String?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<FoodFormCubit>()..init(itemId: itemId),
            child: FoodFormScreen(itemId: itemId),
          ),
        );
      case editProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<EditProfileCubit>(),
            child: const EditProfileScreen(),
          ),
        );
      case notificationSettings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<NotificationSettingsCubit>(),
            child: const NotificationSettingsScreen(),
          ),
        );
      case appearance:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<AppearanceCubit>(),
            child: const AppearanceScreen(),
          ),
        );
      case units:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<UnitsCubit>(),
            child: const UnitsScreen(),
          ),
        );
      case privacy:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PrivacyScreen(),
        );
      case help:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HelpScreen(),
        );
      case fridgeAi:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<FridgeAiCubit>(),
            child: const FridgeAiScreen(),
          ),
        );
      case fridgeAiHistory:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<FridgeAiHistoryCubit>()..load(),
            child: const FridgeAiHistoryScreen(),
          ),
        );
      case shoppingAddListItem:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<AddListItemCubit>(),
            child: const AddListItemScreen(),
          ),
        );
      case shoppingProductDetail:
        final productId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProductDetailCubit>()..load(productId),
            child: ProductDetailScreen(productId: productId),
          ),
        );
      case shoppingCart:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<CartCubit>(),
            child: const CartScreen(),
          ),
        );
      case shoppingOrders:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<OrdersCubit>(),
            child: const OrdersScreen(),
          ),
        );
      case shoppingOrderDetail:
        final orderId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<OrderDetailCubit>()..load(orderId),
            child: OrderDetailScreen(orderId: orderId),
          ),
        );
      case shoppingFridgeIntake:
        final intake = settings.arguments as FridgeIntakeEntity;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<FridgeIntakeCubit>(param1: intake),
            child: const FridgeIntakeScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }

  /// Lands on Fridgy AI with the nav shell underneath so Back returns home.
  static void openMainApp([NavigatorState? navigator]) {
    final nav = navigator ?? navigatorKey.currentState;
    if (nav == null) return;
    nav.pushNamedAndRemoveUntil(home, (_) => false);
    nav.pushNamed(fridgeAi);
  }

  static Future<void> _onSplashFinished() async {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    final authRepo = getIt<AuthRepo>();
    final hasToken = await authRepo.hasAccessToken();
    if (!hasToken) {
      navigator.pushReplacementNamed(welcome);
      return;
    }

    final user = authRepo.getCachedUser();
    if (user != null && user.profileCompleted) {
      openMainApp(navigator);
      return;
    }

    navigator.pushReplacementNamed(profileSetup);
  }
}
