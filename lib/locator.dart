import 'package:get_it/get_it.dart';

import 'core/services/API.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => API());
  // locator.registerLazySingleton(() => UserModel());
}
