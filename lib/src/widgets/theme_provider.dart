import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../storage/app_theme.dart';

class ThemeProvider extends StatefulWidget {
  final Widget Function(BuildContext context, ThemeData themeData) builder;

  const ThemeProvider({super.key, required this.builder});

  static ThemeChangeNotifier of(BuildContext context) {
    return Provider.of<ThemeChangeNotifier>(context, listen: false);
  }

  @override
  State<ThemeProvider> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChangeNotifier>(
        create: (_) => ThemeChangeNotifier(localStorage.appTheme),
        child:
            Consumer<ThemeChangeNotifier>(builder: (context, notifier, child) {
          final Brightness brightness;

          switch (notifier.theme) {
            case AppTheme.followSystem:
              brightness =
                  View.of(context).platformDispatcher.platformBrightness;
              break;
            case AppTheme.light:
              brightness = Brightness.light;
              break;
            case AppTheme.dark:
              brightness = Brightness.dark;
              break;
          }
          final accentColor = localStorage.accentColor;

          final themeData = ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: accentColor, brightness: brightness),
            useMaterial3: true,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedLabelStyle: TextStyle(fontSize: 24),
              unselectedLabelStyle: TextStyle(fontSize: 24),
            ),
          );

          return widget.builder(context, themeData);
        }));
  }
}

class ThemeChangeNotifier extends ChangeNotifier implements ReassembleHandler {
  AppTheme _theme;

  AppTheme get theme => _theme;

  ThemeChangeNotifier(this._theme);

  void setTheme(AppTheme theme) {
    _theme = theme;
    notifyListeners();
  }

  void setAccentColor(Color? color) {
    localStorage.accentColor = color;
    notifyListeners();
  }

  /// Handle hot reload
  @override
  void reassemble() {
    setTheme(localStorage.appTheme);
  }
}
