import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/services/storage.service.dart';
import '../shared/services/user.services.dart';
import '../shared/services/selected_user.service.dart';
import '../shared/repositories/repositories.imports.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerLazySingleton<IStorageService>(
    () => StorageService(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<IUserService>(() => UserService());

  getIt.registerLazySingleton<IUserRepository>(
    () => UserRepository(userService: getIt<IUserService>()),
  );

  getIt.registerLazySingleton<IUserStorageRepository>(
    () => UserStorageRepository(storageService: getIt<IStorageService>()),
  );

  getIt.registerSingleton<SelectedUserService>(SelectedUserService());
}
