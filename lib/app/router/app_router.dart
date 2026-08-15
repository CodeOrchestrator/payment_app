import 'package:go_router/go_router.dart';
import 'package:payment/app/router/app_routes.dart';
import 'package:payment/app/router/route_paths.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    routes: AppRoutes.routes,
    initialLocation: RoutePaths.splash,
  );
}
