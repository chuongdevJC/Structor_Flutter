import 'package:flutter/material.dart';
import 'buildconfig/build_config.dart';
import 'core/common/enums/environment.dart';
import 'di/injection.dart';
import 'pages/application/application.dart';

Future<void> mainCommon(JCEnvironment environment) async {
  await BuildConfig.init(environment);
  await configureDependencies();
  runApp(Application());
}
