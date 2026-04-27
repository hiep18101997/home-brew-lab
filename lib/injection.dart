import 'package:get_it/get_it.dart';
import 'database.dart';
import 'features/beans/data/datasources/beans_drift_datasource.dart';
import 'features/beans/data/repositories/bean_repository_impl.dart';
import 'features/beans/domain/repositories/bean_repository.dart';
import 'features/beans/domain/usecases/get_beans.dart';
import 'features/beans/domain/usecases/create_bean.dart';
import 'features/beans/domain/usecases/delete_bean.dart';
import 'features/beans/presentation/bloc/beans_bloc.dart';
import 'features/brew/data/datasources/brew_logs_drift_datasource.dart';
import 'features/brew/data/repositories/brew_repository_impl.dart';
import 'features/brew/domain/repositories/brew_repository.dart';
import 'features/brew/domain/usecases/get_brew_logs.dart';
import 'features/brew/domain/usecases/create_brew_log.dart';
import 'features/brew/domain/usecases/delete_brew_log.dart';
import 'features/brew/presentation/bloc/brew_bloc.dart';
import 'features/analytics/data/datasources/analytics_datasource.dart';
import 'features/analytics/data/repositories/analytics_repository_impl.dart';
import 'features/analytics/domain/repositories/analytics_repository.dart';
import 'features/analytics/domain/usecases/get_analytics.dart';
import 'features/analytics/presentation/bloc/analytics_bloc.dart';
import 'features/grinder/data/datasources/grinder_static_datasource.dart';
import 'features/grinder/data/repositories/grinder_repository_impl.dart';
import 'features/grinder/domain/repositories/grinder_repository.dart';
import 'features/grinder/domain/usecases/get_all_grinders.dart';
import 'features/grinder/domain/usecases/get_grinders_by_brand.dart';
import 'features/grinder/domain/usecases/get_grinder_settings.dart';
import 'features/grinder/presentation/bloc/grinder_bloc.dart';
import 'features/recipe/data/datasources/recipe_drift_datasource.dart';
import 'features/recipe/data/repositories/recipe_repository_impl.dart';
import 'features/recipe/domain/repositories/recipe_repository.dart';
import 'features/recipe/domain/usecases/get_recipes.dart';
import 'features/recipe/domain/usecases/get_recipe_by_id.dart';
import 'features/recipe/domain/usecases/create_recipe.dart';
import 'features/recipe/presentation/bloc/recipe_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Database
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Data Sources
  getIt.registerLazySingleton<BeansDriftDataSource>(
    () => BeansDriftDataSource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<BrewLogsDriftDataSource>(
    () => BrewLogsDriftDataSource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<AnalyticsDataSource>(
    () => AnalyticsDataSource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<RecipeDriftDataSource>(
    () => RecipeDriftDataSource(getIt<AppDatabase>()),
  );

  // Repositories
  getIt.registerLazySingleton<BeanRepository>(
    () => BeanRepositoryImpl(getIt<BeansDriftDataSource>()),
  );
  getIt.registerLazySingleton<BrewRepository>(
    () => BrewRepositoryImpl(getIt<BrewLogsDriftDataSource>()),
  );
  getIt.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(getIt<AnalyticsDataSource>()),
  );
  getIt.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(getIt<RecipeDriftDataSource>()),
  );

  // Use Cases - Beans
  getIt.registerFactory(() => GetBeans(getIt<BeanRepository>()));
  getIt.registerFactory(() => CreateBean(getIt<BeanRepository>()));
  getIt.registerFactory(() => DeleteBean(getIt<BeanRepository>()));

  // Use Cases - Brew
  getIt.registerFactory(() => GetBrewLogs(getIt<BrewRepository>()));
  getIt.registerFactory(() => CreateBrewLog(getIt<BrewRepository>()));
  getIt.registerFactory(() => DeleteBrewLog(getIt<BrewRepository>()));

  // Use Cases - Analytics
  getIt.registerFactory(() => GetAnalytics(getIt<AnalyticsRepository>()));

  // Data Sources - Grinder
  getIt.registerLazySingleton<GrinderStaticDataSource>(
    () => GrinderStaticDataSource(),
  );

  // Repositories - Grinder
  getIt.registerLazySingleton<GrinderRepository>(
    () => GrinderRepositoryImpl(getIt<GrinderStaticDataSource>()),
  );

  // Use Cases - Grinder
  getIt.registerFactory(() => GetAllGrinders(getIt<GrinderRepository>()));
  getIt.registerFactory(() => GetGrindersByBrand(getIt<GrinderRepository>()));
  getIt.registerFactory(() => GetGrinderSettings(getIt<GrinderRepository>()));

  // Use Cases - Recipe
  getIt.registerFactory(() => GetRecipes(getIt<RecipeRepository>()));
  getIt.registerFactory(() => GetRecipeById(getIt<RecipeRepository>()));
  getIt.registerFactory(() => CreateRecipe(getIt<RecipeRepository>()));

  // BLoCs
  getIt.registerFactory(() => BeansBloc(
    getBeans: getIt<GetBeans>(),
    createBean: getIt<CreateBean>(),
    deleteBean: getIt<DeleteBean>(),
  ));
  getIt.registerFactory(() => BrewBloc(
    getBrewLogs: getIt<GetBrewLogs>(),
    createBrewLog: getIt<CreateBrewLog>(),
    deleteBrewLog: getIt<DeleteBrewLog>(),
  ));
  getIt.registerFactory(() => AnalyticsBloc(
    getAnalytics: getIt<GetAnalytics>(),
  ));
  getIt.registerFactory(() => GrinderBloc(
    getAllGrinders: getIt<GetAllGrinders>(),
    getGrindersByBrand: getIt<GetGrindersByBrand>(),
    getGrinderSettings: getIt<GetGrinderSettings>(),
  ));
  getIt.registerFactory(() => RecipeBloc(
    getRecipes: getIt<GetRecipes>(),
    getRecipeById: getIt<GetRecipeById>(),
    createRecipe: getIt<CreateRecipe>(),
    repository: getIt<RecipeRepository>(),
  ));
}
