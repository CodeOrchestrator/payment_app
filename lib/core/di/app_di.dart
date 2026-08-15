import 'package:payment/app/router/app_router.dart';
import 'package:payment/core/di/di_container.dart';

void initApp() {
  sl.registerLazySingleton(() => AppRouter());
}
