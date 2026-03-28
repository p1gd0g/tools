import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:myapp/time/timestamp.dart';

final logger = Logger();

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/${TimestampConverter.route}',
      builder: (context, state) => const TimestampConverter(),
    ),
  ],
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  logger.i('App started');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(title: "p1gd0g's tools", routerConfig: router);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        children: [
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                context.go('/${TimestampConverter.route}');
              },
              child: Container(
                alignment: Alignment.center,
                width: 200,
                height: 200,
                child: const Text('时间戳转换'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
