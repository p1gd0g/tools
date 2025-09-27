import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class TimestampConverter extends StatelessWidget {
  const TimestampConverter({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TimestampConverterController());

    return Scaffold(
      appBar: AppBar(title: const Text('时间戳转换')),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              // copy to clipboard
              Clipboard.setData(
                ClipboardData(
                  text: (DateTime.now().millisecondsSinceEpoch ~/ 1000)
                      .toString(),
                ),
              );
              Get.snackbar('提示', '已复制到剪贴板');
            },
            child: Obx(() {
              controller.timerCounter.value;
              return Text(
                '当前时间戳：${DateTime.now().millisecondsSinceEpoch ~/ 1000}（点击复制）',
              );
            }),
          ),
          TextField(
            decoration: const InputDecoration(labelText: '输入时间戳（支持秒和毫秒）'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              controller.userInputTimestamp.value = value;
            },
          ),
          Obx(() {
            if (controller.userInputTimestamp.value.isEmpty) {
              return const SizedBox.shrink();
            }
            var input = controller.userInputTimestamp.value;
            var timestamp = int.tryParse(input) ?? 0;
            if (timestamp <= 0) {
              return const Text('请输入有效的时间戳');
            }
            // 判断输入是秒还是毫秒
            DateTime dateTime;
            if (input.length > 10) {
              // 毫秒
              dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            } else {
              // 秒
              dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
            }
            return Text('转换结果：$dateTime');
          }),
        ],
      ),
    );
  }
}

class TimestampConverterController extends GetxController {
  var timerCounter = 0.obs;
  var userInputTimestamp = ''.obs;

  @override
  void onInit() {
    super.onInit();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      timerCounter.value++;
    });
  }
}
