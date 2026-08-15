import 'package:flutter/cupertino.dart';
import 'package:payment/app/my_app.dart';
import 'package:payment/core/di/di_container.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(MyApp());
}
