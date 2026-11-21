import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZapMiniRoot());
}

class ZapMiniRoot extends StatelessWidget {
  const ZapMiniRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..init(),
      child: MaterialApp(
        title: 'ZapMini',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF128C7E), primary: const Color(0xFF128C7E), secondary: const Color(0xFF25D366)),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF128C7E), foregroundColor: Colors.white),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Color(0xFF25D366), foregroundColor: Colors.white),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
