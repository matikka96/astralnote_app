import 'package:astralnote_app/env.dart';
import 'package:astralnote_app/my_app.dart';
import 'package:flutter/material.dart';

void main() {
  Environment().init(FlavorConfig.prod);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
