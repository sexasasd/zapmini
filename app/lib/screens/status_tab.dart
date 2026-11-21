import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';

class StatusTab extends StatelessWidget {
  const StatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Status')),
      floatingActionButton: FloatingActionButton(onPressed: () => _addStatus(context), child: const Icon(Icons.edit)),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFF128C7E), foregroundColor: Colors.white, child: Icon(Icons.person)),
            title: Text(app.currentUser?.name ?? 'Meu status'),
            subtitle: const Text('Toque para adicionar atualização de status'),
            onTap: () => _addStatus(context),
          ),
          const Padding(padding: EdgeInsets.all(12), child: Text('Atualizações recentes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          ...app.statuses.map((s) => ListTile(
                leading: CircleAvatar(child: Text(s.author.isNotEmpty ? s.author[0] : '?')),
                title: Text(s.author),
                subtitle: Text('${s.text}\n${DateFormat('dd/MM HH:mm').format(s.createdAt)}'),
                isThreeLine: true,
              )),
        ],
      ),
    );
  }

  void _addStatus(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Novo status'),
      content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'O que está acontecendo?')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        FilledButton(onPressed: () async {
          if (ctrl.text.trim().isEmpty) return;
          await context.read<AppState>().addStatus(ctrl.text.trim());
          if (ctx.mounted) Navigator.pop(ctx);
        }, child: const Text('Publicar')),
      ],
    ));
  }
}
