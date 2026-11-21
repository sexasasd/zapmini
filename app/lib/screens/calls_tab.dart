import 'package:flutter/material.dart';

class CallsTab extends StatelessWidget {
  const CallsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final calls = const [
      {'name': 'Mamãe', 'time': 'Hoje, 09:10', 'type': 'voz', 'in': true},
      {'name': 'Família ZapMini', 'time': 'Ontem, 19:30', 'type': 'vídeo', 'in': false},
      {'name': 'Papai', 'time': 'Ontem, 08:15', 'type': 'voz', 'in': true},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Chamadas')),
      floatingActionButton: FloatingActionButton(onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione um contato no chat para iniciar chamada (UI pronta; WebRTC/sinalização na Fase 3).')));
      }, child: const Icon(Icons.add_call)),
      body: ListView.separated(
        itemCount: calls.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final c = calls[i];
          final incoming = c['in'] as bool;
          return ListTile(
            leading: CircleAvatar(child: Text((c['name'] as String)[0])),
            title: Text(c['name'] as String),
            subtitle: Row(children: [
              Icon(incoming ? Icons.call_received : Icons.call_made, size: 16, color: incoming ? Colors.green : Colors.blue),
              const SizedBox(width: 4),
              Text(c['time'] as String),
            ]),
            trailing: Icon(c['type'] == 'vídeo' ? Icons.videocam : Icons.call, color: const Color(0xFF128C7E)),
          );
        },
      ),
    );
  }
}
