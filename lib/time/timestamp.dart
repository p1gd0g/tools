import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timestamp.g.dart';

// --- Providers ---

@riverpod
class UserInputTimestamp extends _$UserInputTimestamp {
  @override
  String build() => '';
  void update(String value) => state = value;
}

@riverpod
class UserInputDateTime extends _$UserInputDateTime {
  @override
  DateTime build() => DateTime.now();
  void update(DateTime value) => state = value;
}

@riverpod
Stream<int> timerTick(Ref ref) async* {
  var count = 0;
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    yield count++;
  }
}

// --- Helpers ---

DateTime? _convertTimestamp(String input) {
  if (input.isEmpty) return null;
  var timestamp = int.tryParse(input) ?? 0;
  if (timestamp <= 0) return null;
  if (input.length > 10) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  } else {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }
}

void _copyAndNotify(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('已复制到剪贴板')));
}

// --- Widgets ---

class DateTime2Timestamp extends ConsumerWidget {
  const DateTime2Timestamp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDateTime = ref.watch(userInputDateTimeProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2100),
                ).then((value) {
                  if (value != null) {
                    final current = ref.read(userInputDateTimeProvider);
                    ref
                        .read(userInputDateTimeProvider.notifier)
                        .update(
                          DateTime(
                            value.year,
                            value.month,
                            value.day,
                            current.hour,
                            current.minute,
                          ),
                        );
                  }
                });
              },
              child: Text('选择日期：${userDateTime.toString().substring(0, 10)}'),
            ),
            TextButton(
              onPressed: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  if (value != null) {
                    final current = ref.read(userInputDateTimeProvider);
                    ref
                        .read(userInputDateTimeProvider.notifier)
                        .update(
                          DateTime(
                            current.year,
                            current.month,
                            current.day,
                            value.hour,
                            value.minute,
                          ),
                        );
                  }
                });
              },
              child: Text('选择时间：${userDateTime.toString().substring(11, 16)}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('时间戳：${userDateTime.millisecondsSinceEpoch ~/ 1000}'),
                IconButton(
                  onPressed: () {
                    var timestamp = userDateTime.millisecondsSinceEpoch ~/ 1000;
                    _copyAndNotify(context, timestamp.toString());
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

class Timestamp2DateTime extends ConsumerStatefulWidget {
  const Timestamp2DateTime({super.key});

  @override
  ConsumerState<Timestamp2DateTime> createState() => _Timestamp2DateTimeState();
}

class _Timestamp2DateTimeState extends ConsumerState<Timestamp2DateTime> {
  late final TextEditingController _textCtrl;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(
      text: ref.read(userInputTimestampProvider),
    );
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 当前时间戳（每秒刷新）
            Consumer(
              builder: (context, ref, _) {
                ref.watch(timerTickProvider);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '当前时间戳：${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
                    ),
                    IconButton(
                      onPressed: () {
                        _copyAndNotify(
                          context,
                          (DateTime.now().millisecondsSinceEpoch ~/ 1000)
                              .toString(),
                        );
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                );
              },
            ),
            MouseRegion(
              onEnter: (_) async {
                _focusNode.requestFocus();
                if (_textCtrl.text.isEmpty) {
                  await Clipboard.getData(Clipboard.kTextPlain).then((value) {
                    if (value != null &&
                        value.text != null &&
                        int.tryParse(value.text!) != null) {
                      _textCtrl.text = value.text!;
                      ref
                          .read(userInputTimestampProvider.notifier)
                          .update(value.text!);
                    }
                  });
                } else {
                  _textCtrl.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _textCtrl.text.length,
                  );
                }
              },
              child: TextField(
                controller: _textCtrl,
                focusNode: _focusNode,
                decoration: const InputDecoration(labelText: '输入时间戳（支持秒和毫秒）'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  ref.read(userInputTimestampProvider.notifier).update(value);
                },
              ),
            ),
            // 转换结果
            Consumer(
              builder: (context, ref, _) {
                final userTimestamp = ref.watch(userInputTimestampProvider);
                final dt = _convertTimestamp(userTimestamp);
                if (dt == null) return const SizedBox.shrink();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('时间：$dt'),
                    IconButton(
                      onPressed: () {
                        _copyAndNotify(context, dt.toString());
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TimestampConverter extends StatelessWidget {
  const TimestampConverter({super.key});

  static String route = Uri.encodeComponent('时间戳');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('时间戳转换')),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Timestamp2DateTime(), DateTime2Timestamp()],
          ),
        ),
      ),
    );
  }
}
