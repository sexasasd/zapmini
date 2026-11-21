import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZapMini - Conta do Responsável')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.family_restroom, size: 72, color: Color(0xFF128C7E)),
            const SizedBox(height: 16),
            const Text('Mensageiro familiar em rede própria', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Cadastre-se como responsável para criar perfis infantis sem número de telefone.', textAlign: TextAlign.center),
            const SizedBox(height: 32),
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Seu nome', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Seu número (verificação do responsável)', border: OutlineInputBorder()), keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _loading ? null : () async {
                if (_name.text.trim().isEmpty || _phone.text.trim().isEmpty) return;
                setState(() => _loading = true);
                await context.read<AppState>().loginGuardian(name: _name.text.trim(), phone: _phone.text.trim());
                if (!mounted) return;
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
              },
              child: Text(_loading ? 'Entrando...' : 'Entrar / Criar conta'),
            ),
            const SizedBox(height: 12),
            const Text('Modo de teste: autenticação simulada localmente. Integração Firebase pronta para ativação na próxima etapa.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
