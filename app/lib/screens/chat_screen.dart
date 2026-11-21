import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final chat = app.chatById(widget.chatId);
    final msgs = app.messagesFor(widget.chatId);
    final me = app.currentUser?.id ?? 'me';
    if (chat == null) return const Scaffold(body: Center(child: Text('Conversa não encontrada')));
    return Scaffold(
      appBar: AppBar(title: Row(children: [CircleAvatar(radius: 16, child: Text(chat.avatar)), const SizedBox(width: 8), Expanded(child: Text(chat.title, overflow: TextOverflow.ellipsis))]),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chamada de voz (UI pronta - sinalização/WebRTC na Fase 3)')))),
          IconButton(icon: const Icon(Icons.videocam), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chamada de vídeo (UI pronta - sinalização/WebRTC na Fase 3)')))),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: msgs.length,
              itemBuilder: (context, i) {
                final m = msgs[i];
                final mine = m.senderId == me || m.senderId == 'me';
                final isSystem = m.type == 'system';
                if (isSystem) return Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(m.text, style: const TextStyle(fontSize: 12, color: Colors.grey))));
                return Align(
                  alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(color: mine ? const Color(0xFFDCF8C6) : Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1)]),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      if (m.type == 'image' && m.mediaPath != null)
                        Padding(padding: const EdgeInsets.only(bottom: 6), child: Image.file(File(m.mediaPath!), height: 180, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Text('[imagem]'))),
                      if (m.type == 'audio') const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.mic), SizedBox(width: 6), Text('Mensagem de áudio')]),
                      if (m.text.isNotEmpty && m.type != 'audio') Text(m.text),
                      const SizedBox(height: 2),
                      Text(DateFormat('HH:mm').format(m.sentAt), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ]),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(children: [
                IconButton(icon: const Icon(Icons.attach_file), onPressed: () async {
                  final x = await _picker.pickImage(source: ImageSource.gallery);
                  if (x != null && context.mounted) {
                    await context.read<AppState>().sendMessage(widget.chatId, 'Foto', type: 'image', mediaPath: x.path);
                  }
                }),
                IconButton(icon: const Icon(Icons.camera_alt), onPressed: () async {
                  final x = await _picker.pickImage(source: ImageSource.camera);
                  if (x != null && context.mounted) {
                    await context.read<AppState>().sendMessage(widget.chatId, 'Foto', type: 'image', mediaPath: x.path);
                  }
                }),
                Expanded(child: TextField(controller: _ctrl, decoration: const InputDecoration(hintText: 'Mensagem', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24))), isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                const SizedBox(width: 4),
                IconButton(icon: const Icon(Icons.mic), onPressed: () async {
                  await context.read<AppState>().sendMessage(widget.chatId, 'Áudio', type: 'audio');
                }),
                CircleAvatar(backgroundColor: const Color(0xFF128C7E), child: IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: () async {
                  final text = _ctrl.text.trim();
                  if (text.isEmpty) return;
                  _ctrl.clear();
                  await context.read<AppState>().sendMessage(widget.chatId, text);
                })),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
