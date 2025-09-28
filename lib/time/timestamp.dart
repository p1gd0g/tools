import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Timestamp2TimeDate extends StatelessWidget {
  const Timestamp2TimeDate({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TimestampConverterController());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Obx(() {
                  controller.timerCounter.value;
                  return Text(
                    '当前时间戳：${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
                  );
                }),
                IconButton(
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
                  // align center
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
            TextField(
              decoration: const InputDecoration(labelText: '输入时间戳（支持秒和毫秒）'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.userInputTimestamp.value = value;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  var dt = controller.convertTimestamp();
                  if (dt == null) {
                    return const SizedBox.shrink();
                  }

                  return Text('时间：$dt');
                }),
                Obx(() {
                  var dt = controller.convertTimestamp();
                  if (dt == null) {
                    return const SizedBox.shrink();
                  }

                  return IconButton(
                    onPressed: () {
                      var dt = controller.convertTimestamp();
                      if (dt == null) {
                        Get.snackbar('错误', '请输入有效的时间戳');
                        return;
                      }
                      // copy to clipboard
                      Clipboard.setData(ClipboardData(text: dt.toString()));
                      Get.snackbar('提示', '已复制到剪贴板');
                    },
                    icon: const Icon(Icons.copy),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimestampConverter extends StatelessWidget {
  const TimestampConverter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('时间戳转换')),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [Timestamp2TimeDate()],
          ),
        ),
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

  DateTime? convertTimestamp() {
    var input = userInputTimestamp.value;

    if (input.isEmpty) {
      return null;
    }

    var timestamp = int.tryParse(input) ?? 0;
    if (timestamp <= 0) {
      return null;
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
    return dateTime;
  }
}
