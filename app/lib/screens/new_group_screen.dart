import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});
  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final _name = TextEditingController();
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final contacts = app.contacts.where((c) => c.approved).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Novo grupo')),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(12), child: TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nome do grupo', border: OutlineInputBorder()))),
          const ListTile(title: Text('Selecione participantes')),
          Expanded(
            child: ListView(
              children: contacts.map((c) => CheckboxListTile(
                value: _selected.contains(c.id),
                onChanged: (v) => setState(() => v == true ? _selected.add(c.id) : _selected.remove(c.id)),
                title: Text(c.name),
                secondary: CircleAvatar(child: Text(c.avatar)),
              )).toList(),
            ),
          ),
          Padding(padding: const EdgeInsets.all(12), child: SizedBox(width: double.infinity, child: FilledButton(onPressed: () async {
            final name = _name.text.trim();
            if (name.isEmpty || _selected.isEmpty) return;
            final members = contacts.where((c) => _selected.contains(c.id)).toList();
            await context.read<AppState>().createGroup(name, members);
            if (context.mounted) Navigator.pop(context);
          }, child: const Text('Criar grupo')))),
        ],
      ),
    );
  }
}
