import 'package:get_it/get_it.dart';

import 'core/services/API.dart';
import './core/viewmodels/ToiletModel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => API());
  locator.registerLazySingleton(() => ToiletModel());
  // locator.registerLazySingleton(() => UserModel());
}
