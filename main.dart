import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';
import 'utils/theme_manager.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize theme manager
  final themeManager = ThemeManager();
  await themeManager.initialize();
  
  runApp(FinanceCalculatorApp(themeManager: themeManager));
}

class FinanceCalculatorApp extends StatelessWidget {
  final ThemeManager themeManager;
  
  const FinanceCalculatorApp({
    super.key,
    required this.themeManager,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeManager,
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: 'Finance Calculator',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeManager.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
