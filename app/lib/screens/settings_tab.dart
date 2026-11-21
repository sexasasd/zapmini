import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import 'login_screen.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final user = app.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(radius: 24, backgroundColor: const Color(0xFF128C7E), foregroundColor: Colors.white, child: Text(user?.avatar ?? '?')),
            title: Text(user?.name ?? 'Usuário'),
            subtitle: Text(user?.role == 'guardian' ? 'Responsável • ${user?.phone ?? ''}' : 'Perfil infantil (sem número)'),
          ),
          const Divider(),
          const Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 4), child: Text('Família / Controle parental', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          ListTile(leading: const Icon(Icons.child_care), title: const Text('Criar perfil infantil'), subtitle: const Text('Sem necessidade de outro número'), onTap: () => _createChild(context)),
          ...app.children.map((c) => ListTile(
                leading: CircleAvatar(child: Text(c.avatar)),
                title: Text(c.name),
                subtitle: const Text('Perfil infantil'),
                trailing: TextButton(child: const Text('Usar perfil'), onPressed: () async {
                  await context.read<AppState>().switchToChild(c);
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perfil alterado para ${c.name}')));
                }),
              )),
          const Divider(),
          const Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 4), child: Text('Funcionalidades', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          const ListTile(leading: Icon(Icons.lock), title: Text('Privacidade e segurança'), subtitle: Text('Contatos aprovados, controle parental, regras Firebase prontas para ativação')),
          const ListTile(leading: Icon(Icons.backup), title: Text('Backup e restauração'), subtitle: Text('Planejado na Fase 4 (integração com armazenamento em nuvem)')),
          const ListTile(leading: Icon(Icons.devices), title: Text('Dispositivos vinculados'), subtitle: Text('Pareamento por QR/código planejado com backend Firebase')),
          const ListTile(leading: Icon(Icons.call), title: Text('Chamadas de voz/vídeo'), subtitle: Text('UI pronta; WebRTC/TURN/sinalização na Fase 3')),
          const Divider(),
          ListTile(leading: const Icon(Icons.info_outline), title: const Text('Sobre o ZapMini'), subtitle: const Text('Rede própria • Teste familiar • v1.0.0+1')),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Sair', style: TextStyle(color: Colors.red)), onTap: () async {
            await context.read<AppState>().logout();
            if (context.mounted) Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _createChild(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Criar perfil infantil'),
      content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Nome da criança')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        FilledButton(onPressed: () async {
          if (ctrl.text.trim().isEmpty) return;
          await context.read<AppState>().createChild(ctrl.text.trim());
          if (ctx.mounted) Navigator.pop(ctx);
        }, child: const Text('Criar')),
      ],
    ));
  }
}
