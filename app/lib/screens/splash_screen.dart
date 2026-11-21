import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, app, _) {
      if (!app.initialized) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      Future.microtask(() {
        if (!context.mounted) return;
        final next = app.currentUser == null ? const LoginScreen() : const HomeScreen();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => next));
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    });
  }
}
