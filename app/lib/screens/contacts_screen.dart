import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'chat_screen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Contatos')),
      floatingActionButton: FloatingActionButton(onPressed: () => _addContact(context), child: const Icon(Icons.person_add)),
      body: ListView(
        children: [
          const Padding(padding: EdgeInsets.all(12), child: Text('Contatos aprovados só podem conversar com o perfil infantil. Responsável aprova pendentes.', style: TextStyle(color: Colors.grey))),
          ...app.contacts.map((c) => ListTile(
                leading: CircleAvatar(backgroundColor: c.approved ? const Color(0xFF128C7E) : Colors.orange, foregroundColor: Colors.white, child: Text(c.avatar)),
                title: Text(c.name),
                subtitle: Text(c.approved ? c.subtitle : '${c.subtitle} • pendente'),
                trailing: c.approved
                    ? IconButton(icon: const Icon(Icons.chat), onPressed: () async {
                        final chat = await context.read<AppState>().createDirectChat(c);
                        if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatScreen(chatId: chat.id)));
                      })
                    : TextButton(onPressed: () => context.read<AppState>().approveContact(c.id), child: const Text('Aprovar')),
              )),
        ],
      ),
    );
  }

  void _addContact(BuildContext context) {
    final name = TextEditingController();
    final sub = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Novo contato / convite'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Nome')),
        TextField(controller: sub, decoration: const InputDecoration(labelText: 'Relação (família/amigo)')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        FilledButton(onPressed: () async {
          if (name.text.trim().isEmpty) return;
          await context.read<AppState>().addContact(name.text.trim(), sub.text.trim().isEmpty ? 'Família' : sub.text.trim());
          if (ctx.mounted) Navigator.pop(ctx);
        }, child: const Text('Adicionar')),
      ],
    ));
  }
}
