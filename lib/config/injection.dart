import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/services/storage.service.dart';
import '../shared/services/user.services.dart';

final getIt = GetIt.instance;

Future<void> setupInjection() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerLazySingleton<IStorageService>(
    () => StorageService(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<IUserService>(() => UserService());
}
