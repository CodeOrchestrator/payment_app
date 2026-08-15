import 'package:flutter/material.dart';
import 'package:payment/app/router/app_router.dart';
import 'package:payment/core/di/di_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: sl<AppRouter>().router,
    );
  }
}
