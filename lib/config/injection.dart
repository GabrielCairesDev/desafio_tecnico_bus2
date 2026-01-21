import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/services/storage.service.dart';
import '../shared/services/user.services.dart';
import '../shared/services/selected_user.service.dart';
import '../shared/repositories/repositories.imports.dart';
import '../features/home/viewmodel/home.viewmodel.dart';
import '../features/details/viewmodel/details.viewmodel.dart';
import '../features/users/viewmodel/users.viewmodel.dart';

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

  getIt.registerFactory<HomeViewModel>(
    () => HomeViewModel(
      userRepository: getIt<IUserRepository>(),
      selectedUserService: getIt<SelectedUserService>(),
    ),
  );

  getIt.registerFactory<DetailsViewModel>(
    () => DetailsViewModel(
      userStorageRepository: getIt<IUserStorageRepository>(),
      selectedUserService: getIt<SelectedUserService>(),
    ),
  );

  getIt.registerFactory<UsersViewModel>(
    () => UsersViewModel(
      userStorageRepository: getIt<IUserStorageRepository>(),
      selectedUserService: getIt<SelectedUserService>(),
    ),
  );
}
