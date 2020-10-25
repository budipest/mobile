import 'package:get_it/get_it.dart';

import './core/services/api.dart';
import './core/viewmodels/ToiletModel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // locator.registerLazySingleton(() => API('toilets'));
  locator.registerLazySingleton(() => ToiletModel());
  // locator.registerLazySingleton(() => UserModel());
}
