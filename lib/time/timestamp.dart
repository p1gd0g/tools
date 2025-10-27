import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TimeDate2Timestamp extends StatelessWidget {
  const TimeDate2Timestamp({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TimestampConverterController());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () => {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2100),
                ).then((value) {
                  if (value != null) {
                    controller.userInputDateTime.value = DateTime(
                      value.year,
                      value.month,
                      value.day,
                      controller.userInputDateTime.value.hour,
                      controller.userInputDateTime.value.minute,
                    );
                  }
                }),
              },
              child: Obx(
                // format date to yyyy-MM-dd
                () => Text(
                  '选择日期：${controller.userInputDateTime.value.toString().substring(0, 10)}',
                ),
              ),
            ),
            TextButton(
              onPressed: () => {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  if (value != null) {
                    controller.userInputDateTime.value = DateTime(
                      controller.userInputDateTime.value.year,
                      controller.userInputDateTime.value.month,
                      controller.userInputDateTime.value.day,
                      value.hour,
                      value.minute,
                    );
                  }
                }),
              },
              child: Obx(
                () => Text(
                  '选择时间：${controller.userInputDateTime.value.toString().substring(11, 16)}',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  return Text(
                    '时间戳：${controller.userInputDateTime.value.millisecondsSinceEpoch ~/ 1000}',
                  );
                }),
                IconButton(
                  onPressed: () {
                    var dt = controller.userInputDateTime.value;
                    var timestamp = dt.millisecondsSinceEpoch ~/ 1000;
                    // copy to clipboard
                    Clipboard.setData(
                      ClipboardData(text: timestamp.toString()),
                    );
                    Get.snackbar('提示', '已复制到剪贴板');
                  },
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Timestamp2TimeDate extends StatelessWidget {
  const Timestamp2TimeDate({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TimestampConverterController());
    final textCtrl = TextEditingController(
      text: controller.userInputTimestamp.value,
    );
    final focusNode = FocusNode();

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
            MouseRegion(
              onEnter: (_) async {
                // focus and select all text when mouse hovers
                focusNode.requestFocus();

                if (textCtrl.text.isEmpty) {
                  await Clipboard.getData(Clipboard.kTextPlain).then((value) {
                    if (value != null &&
                        value.text != null &&
                        int.tryParse(value.text!) != null) {
                      textCtrl.text = value.text!;
                      controller.userInputTimestamp.value = value.text!;
                    }
                  });
                }

                textCtrl.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: textCtrl.text.length,
                );
              },
              child: TextField(
                controller: textCtrl,
                focusNode: focusNode,
                decoration: const InputDecoration(labelText: '输入时间戳（支持秒和毫秒）'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.userInputTimestamp.value = value;
                },
              ),
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

  // static const String route = '时间戳';
  // static const String route = r'时间戳';
  static String route = Uri.encodeComponent('时间戳');
  // static const String route = '%E6%97%B6%E9%97%B4%E6%88%B3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('时间戳转换')),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [Timestamp2TimeDate(), TimeDate2Timestamp()],
          ),
        ),
      ),
    );
  }
}

class TimestampConverterController extends GetxController {
  var timerCounter = 0.obs;
  var userInputTimestamp = ''.obs;
  var userInputDateTime = DateTime.now().obs;

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
