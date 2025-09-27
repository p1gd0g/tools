import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stack_trace/stack_trace.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  // Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((
  //   x,
  // ) {
  //   FirebaseAnalytics.instance.logAppOpen();
  // });

  runApp(
    GetMaterialApp(
      logWriterCallback: (value, {isError = false}) {
        // void defaultLogWriterCallback(String value, {bool isError = false}) {
        if (isError || Get.isLogEnable) {
          developer.log(
            '[${DateTime.now()}] $value\n${Trace.current().terse.frames.getRange(1, 4).join('\n')}',
            name: 'GETX',
          );
        }
        // }
      },
      // theme: AppTheme.light,
    ),
  );
}
