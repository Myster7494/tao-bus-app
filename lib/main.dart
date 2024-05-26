import 'package:bus_app/src/bus_data/bus_data_loader.dart';
import 'package:bus_app/src/pages/main_page.dart';
import 'package:bus_app/src/storage/local_storage.dart';
import 'package:bus_app/src/widgets/theme_provider.dart';
import 'package:flutter/material.dart';

final LocalStorage localStorage = LocalStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BusDataLoader.loadAllData();
  await localStorage.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      builder: (context, themeData) => MaterialApp(
        title: '桃園公車-自主學習',
        theme: themeData,
        home: const MainPage(),
      ),
    );
  }
}
