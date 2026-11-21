import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import 'chat_screen.dart';
import 'contacts_screen.dart';
import 'new_group_screen.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final chats = app.chats;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZapMini'),
        actions: [
          IconButton(icon: const Icon(Icons.group_add), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewGroupScreen()))),
          IconButton(icon: const Icon(Icons.person_add), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsScreen()))),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsScreen())), child: const Icon(Icons.message)),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final c = chats[i];
          final time = c.lastMessageAt == null ? '' : DateFormat('HH:mm').format(c.lastMessageAt!);
          return ListTile(
            leading: CircleAvatar(backgroundColor: const Color(0xFF128C7E), foregroundColor: Colors.white, child: Text(c.avatar)),
            title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(c.lastMessage ?? 'Sem mensagens', maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              if (c.unread > 0) Container(margin: const EdgeInsets.only(top: 4), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(10)), child: Text('${c.unread}', style: const TextStyle(color: Colors.white, fontSize: 11))),
            ]),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(chatId: c.id))),
          );
        },
      ),
    );
  }
}
