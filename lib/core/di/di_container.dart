import 'package:get_it/get_it.dart';
import 'package:payment/core/di/app_di.dart';
import 'package:payment/features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  initApp();
  sl.registerFactory(() => HomeBloc());
}
