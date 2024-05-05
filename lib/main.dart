import 'package:flutter/material.dart';
import 'package:fast_location/src/routes/app_router.dart';
import 'package:fast_location/src/shared/storage/hive_configuration.dart';
import 'package:fast_location/src/modules/history/page/history_page.dart';
import 'package:fast_location/src/modules/home/page/home_page.dart';
import 'package:fast_location/src/modules/initial/page/initial_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HiveConfiguration.initHiveDatabase().then((_) {
    const myApp = MyApp();
    runApp(myApp);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Location',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InitialPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        AppRouter.home: (_) => const HomePage(),
        AppRouter.history: (_) => const HistoryPage(),
      },
    );
  }
}
