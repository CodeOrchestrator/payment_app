import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:payment/app/router/route_paths.dart';
import 'package:payment/core/di/di_container.dart';
import 'package:payment/features/home/presentation/bloc/home_bloc.dart';
import 'package:payment/features/home/presentation/pages/home_page.dart';
import 'package:payment/features/splash/splash_page.dart';

class AppRoutes {
  static List<RouteBase> routes = [
    GoRoute(path: RoutePaths.splash, builder: (context, state) => SplashPage()),
    GoRoute(
      path: RoutePaths.home,
      builder: (context, state) =>
          BlocProvider(create: (context) => sl<HomeBloc>(), child: HomePage()),
    ),
  ];
}
