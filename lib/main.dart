import 'package:bus_app/src/bus_data/bus_data_loader.dart';
import 'package:bus_app/src/pages/main_page.dart';
import 'package:bus_app/src/storage/local_storage.dart';
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
    return MaterialApp(
      title: '桃園公車-自主學習',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedLabelStyle: TextStyle(fontSize: 24),
          unselectedLabelStyle: TextStyle(fontSize: 24),
        ),
      ),
      home: const MainPage(),
    );
  }
}
