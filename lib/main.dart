import 'dart:async';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/time/timestamp.dart';
import 'dart:developer' as developer;
import 'package:stack_trace/stack_trace.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((
  //   x,
  // ) {
  //   FirebaseAnalytics.instance.logAppOpen();
  // });

  usePathUrlStrategy();

  runApp(
    GetMaterialApp(
      title: "p1gd0g's tools",

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

      routes: {
        '/${TimestampConverter().runtimeType}': (context) =>
            const TimestampConverter(),
      },

      // theme: AppTheme.light,
      home: Scaffold(
        body: Wrap(
          // alignment: WrapAlignment.center,
          // runAlignment: WrapAlignment.center,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(const TimestampConverter());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 200,
                  child: Text('时间戳转换'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
