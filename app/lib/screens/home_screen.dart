import 'package:flutter/material.dart';
import 'chats_tab.dart';
import 'status_tab.dart';
import 'calls_tab.dart';
import 'settings_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final tabs = const [ChatsTab(), StatusTab(), CallsTab(), SettingsTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: 'Conversas'),
          NavigationDestination(icon: Icon(Icons.circle_outlined), label: 'Status'),
          NavigationDestination(icon: Icon(Icons.call), label: 'Chamadas'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Config.'),
        ],
      ),
    );
  }
}
