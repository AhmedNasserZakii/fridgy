import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fridgy/core/connection/network_info.dart';
import 'package:fridgy/core/local_storage/local_storage.dart';
import 'package:fridgy/core/local_storage/secure_storage.dart';
import 'package:fridgy/core/network_services/api_service.dart';
import 'package:fridgy/core/network_services/mock/mock_interceptor.dart';
import 'package:fridgy/core/network_services/token_interceptor.dart';
import 'package:fridgy/core/network_services/web_constant.dart';
import 'package:fridgy/core/theme/theme_controller.dart';
import 'package:fridgy/feature/auth/domain/repos/auth_repo.dart';
import 'package:fridgy/feature/auth/domain/repos/auth_repo_impl.dart';
import 'package:fridgy/feature/auth/presentation/logic/login_cubit.dart';
import 'package:fridgy/feature/auth/presentation/logic/register_cubit.dart';
import 'package:fridgy/feature/fridge_ai/domain/repos/fridge_ai_repo.dart';
import 'package:fridgy/feature/fridge_ai/domain/repos/fridge_ai_repo_impl.dart';
import 'package:fridgy/feature/fridge_ai/presentation/logic/fridge_ai_cubit.dart';
import 'package:fridgy/feature/fridge_ai/presentation/logic/fridge_ai_history_cubit.dart';
import 'package:fridgy/feature/home/domain/repos/home_repo.dart';
import 'package:fridgy/feature/home/domain/repos/home_repo_impl.dart';
import 'package:fridgy/feature/home/presentation/logic/home_cubit.dart';
import 'package:fridgy/feature/inventory/data/data_source/recent_searches_local_data_source.dart';
import 'package:fridgy/feature/inventory/domain/repos/inventory_repo.dart';
import 'package:fridgy/feature/inventory/domain/repos/inventory_repo_impl.dart';
import 'package:fridgy/feature/inventory/presentation/logic/expiring_soon_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/food_detail_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/food_form_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/my_fridge_cubit.dart';
import 'package:fridgy/feature/inventory/presentation/logic/search_cubit.dart';
import 'package:fridgy/feature/more/domain/repos/more_repo.dart';
import 'package:fridgy/feature/more/domain/repos/more_repo_impl.dart';
import 'package:fridgy/feature/more/domain/repos/notification_settings_repo.dart';
import 'package:fridgy/feature/more/domain/repos/notification_settings_repo_impl.dart';
import 'package:fridgy/feature/more/presentation/logic/appearance_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/edit_profile_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/more_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/notification_settings_cubit.dart';
import 'package:fridgy/feature/more/presentation/logic/units_cubit.dart';
import 'package:fridgy/feature/nav_bar/presentation/logic/nav_bar_cubit.dart';
import 'package:fridgy/feature/notification/domain/repos/notification_repo.dart';
import 'package:fridgy/feature/notification/domain/repos/notification_repo_impl.dart';
import 'package:fridgy/feature/notification/presentation/logic/notifications_cubit.dart';
import 'package:fridgy/feature/profile_setup/domain/repos/profile_setup_repo.dart';
import 'package:fridgy/feature/profile_setup/domain/repos/profile_setup_repo_impl.dart';
import 'package:fridgy/feature/profile_setup/presentation/logic/profile_setup_cubit.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_entity.dart';
import 'package:fridgy/feature/shopping/domain/repos/shopping_repo.dart';
import 'package:fridgy/feature/shopping/domain/repos/shopping_repo_impl.dart';
import 'package:fridgy/feature/shopping/presentation/logic/add_list_item_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/cart_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/catalog_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/fridge_intake_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/order_detail_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/orders_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/product_detail_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/shopping_hub_cubit.dart';
import 'package:fridgy/feature/shopping/presentation/logic/shopping_list_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerLazySingleton<LocalStorage>(() => LocalStorage(prefs: getIt()));
  getIt.registerLazySingleton<SecureStorage>(SecureStorage.new);
  getIt.registerLazySingleton<ThemeController>(
    () => ThemeController(localStorage: getIt()),
  );
  getIt.registerLazySingleton<Connectivity>(Connectivity.new);
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: getIt()),
  );

  getIt.registerLazySingleton<Dio>(() {
    final secureStorage = getIt<SecureStorage>();
    final localStorage = getIt<LocalStorage>();

    final refreshDio = Dio(
      BaseOptions(
        baseUrl: WebConstant.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    )..interceptors.add(MockInterceptor());

    final dio = Dio(
      BaseOptions(
        baseUrl: WebConstant.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      ),
    );

    dio.interceptors.addAll([
      MockInterceptor(),
      TokenInterceptor(
        secureStorage: secureStorage,
        localStorage: localStorage,
        refreshDio: refreshDio,
      ),
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
      ),
    ]);

    return dio;
  });

  getIt.registerLazySingleton<ApiService>(
    () => ApiService(dio: getIt(), localStorage: getIt()),
  );

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      apiService: getIt(),
      networkInfo: getIt(),
      secureStorage: getIt(),
      localStorage: getIt(),
    ),
  );

  getIt.registerLazySingleton<ProfileSetupRepo>(
    () => ProfileSetupRepoImpl(
      apiService: getIt(),
      networkInfo: getIt(),
      localStorage: getIt(),
    ),
  );

  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(
      apiService: getIt(),
      networkInfo: getIt(),
      authRepo: getIt(),
    ),
  );

  getIt.registerLazySingleton<InventoryRepo>(
    () => InventoryRepoImpl(apiService: getIt(), networkInfo: getIt()),
  );

  getIt.registerLazySingleton<NotificationRepo>(
    () => NotificationRepoImpl(apiService: getIt(), networkInfo: getIt()),
  );

  getIt.registerLazySingleton<MoreRepo>(
    () => MoreRepoImpl(
      apiService: getIt(),
      networkInfo: getIt(),
      localStorage: getIt(),
    ),
  );

  getIt.registerLazySingleton<NotificationSettingsRepo>(
    () =>
        NotificationSettingsRepoImpl(apiService: getIt(), networkInfo: getIt()),
  );

  getIt.registerLazySingleton<RecentSearchesLocalDataSource>(
    () => RecentSearchesLocalDataSource(prefs: getIt()),
  );

  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(authRepo: getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(authRepo: getIt()));
  getIt.registerFactoryParam<ProfileSetupCubit, bool, void>(
    (isEditMode, _) =>
        ProfileSetupCubit(profileSetupRepo: getIt(), isEditMode: isEditMode),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(homeRepo: getIt()));
  getIt.registerFactory<NavBarCubit>(NavBarCubit.new);
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(
      inventoryRepo: getIt(),
      recentSearches: getIt(),
      authRepo: getIt(),
    ),
  );
  getIt.registerFactory<ExpiringSoonCubit>(
    () => ExpiringSoonCubit(inventoryRepo: getIt()),
  );
  getIt.registerFactory<MyFridgeCubit>(
    () => MyFridgeCubit(inventoryRepo: getIt()),
  );
  getIt.registerFactory<FoodDetailCubit>(
    () => FoodDetailCubit(inventoryRepo: getIt()),
  );
  getIt.registerFactory<FoodFormCubit>(
    () => FoodFormCubit(inventoryRepo: getIt()),
  );
  getIt.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(notificationRepo: getIt()),
  );
  getIt.registerFactory<MoreCubit>(() => MoreCubit(authRepo: getIt()));
  getIt.registerFactory<EditProfileCubit>(
    () => EditProfileCubit(moreRepo: getIt(), authRepo: getIt()),
  );
  getIt.registerFactory<NotificationSettingsCubit>(
    () => NotificationSettingsCubit(notificationSettingsRepo: getIt()),
  );
  getIt.registerFactory<AppearanceCubit>(
    () => AppearanceCubit(themeController: getIt()),
  );
  getIt.registerFactory<UnitsCubit>(() => UnitsCubit(localStorage: getIt()));

  getIt.registerLazySingleton<FridgeAiRepo>(
    () => FridgeAiRepoImpl(apiService: getIt(), networkInfo: getIt()),
  );
  getIt.registerFactory<FridgeAiCubit>(
    () => FridgeAiCubit(fridgeAiRepo: getIt(), inventoryRepo: getIt()),
  );
  getIt.registerFactory<FridgeAiHistoryCubit>(
    () => FridgeAiHistoryCubit(fridgeAiRepo: getIt()),
  );

  getIt.registerLazySingleton<ShoppingRepo>(
    () => ShoppingRepoImpl(apiService: getIt(), networkInfo: getIt()),
  );
  getIt.registerFactory<ShoppingHubCubit>(ShoppingHubCubit.new);
  getIt.registerFactory<ShoppingListCubit>(
    () => ShoppingListCubit(shoppingRepo: getIt()),
  );
  getIt.registerFactory<CatalogCubit>(
    () => CatalogCubit(shoppingRepo: getIt()),
  );
  getIt.registerFactory<CartCubit>(() => CartCubit(shoppingRepo: getIt()));
  getIt.registerFactory<OrdersCubit>(() => OrdersCubit(shoppingRepo: getIt()));
  getIt.registerFactory<OrderDetailCubit>(
    () => OrderDetailCubit(shoppingRepo: getIt()),
  );
  getIt.registerFactory<AddListItemCubit>(
    () => AddListItemCubit(shoppingRepo: getIt()),
  );
  getIt.registerFactory<ProductDetailCubit>(
    () => ProductDetailCubit(shoppingRepo: getIt()),
  );
  getIt.registerFactoryParam<FridgeIntakeCubit, FridgeIntakeEntity, void>(
    (intake, _) => FridgeIntakeCubit(shoppingRepo: getIt(), intake: intake),
  );
}
