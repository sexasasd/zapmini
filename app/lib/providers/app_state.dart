import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/local_store.dart';

class AppState extends ChangeNotifier {
  final LocalStore _store = LocalStore();
  bool initialized = false;
  AppUser? currentUser;
  List<AppUser> children = [];
  List<ChatContact> contacts = [];
  List<ChatThread> chats = [];
  List<ChatMessage> messages = [];
  List<StatusItem> statuses = [];

  Future<void> init() async {
    currentUser = await _store.loadUser();
    children = await _store.loadChildren();
    contacts = await _store.loadContacts();
    chats = await _store.loadChats();
    messages = await _store.loadMessages();
    statuses = await _store.loadStatuses();
    if (contacts.isEmpty && chats.isEmpty && statuses.isEmpty) {
      _seed();
      await _persistAll();
    }
    initialized = true;
    notifyListeners();
  }

  void _seed() {
    contacts = [
      const ChatContact(id: 'c1', name: 'Mamãe', subtitle: 'Responsável', avatar: 'M'),
      const ChatContact(id: 'c2', name: 'Papai', subtitle: 'Responsável', avatar: 'P'),
      const ChatContact(id: 'c3', name: 'Vovó', subtitle: 'Família', avatar: 'V'),
      const ChatContact(id: 'c4', name: 'Tio Rafa', subtitle: 'Família (pendente)', avatar: 'R', approved: false),
    ];
    chats = [
      ChatThread(id: 't1', title: 'Mamãe', avatar: 'M', memberIds: const ['me', 'c1'], lastMessage: 'Oi! Tudo bem?', lastMessageAt: DateTime.now().subtract(const Duration(minutes: 5)), unread: 1),
      ChatThread(id: 't2', title: 'Família ZapMini', avatar: 'F', isGroup: true, memberIds: const ['me', 'c1', 'c2', 'c3'], lastMessage: 'Bem-vindos ao ZapMini!', lastMessageAt: DateTime.now().subtract(const Duration(hours: 1))),
    ];
    messages = [
      ChatMessage(id: 'm1', chatId: 't1', senderId: 'c1', text: 'Oi! Tudo bem?', sentAt: DateTime.now().subtract(const Duration(minutes: 5)), status: 'delivered'),
      ChatMessage(id: 'm2', chatId: 't2', senderId: 'c1', text: 'Bem-vindos ao ZapMini!', sentAt: DateTime.now().subtract(const Duration(hours: 1)), status: 'read'),
      ChatMessage(id: 'm3', chatId: 't2', senderId: 'c2', text: 'Esse é nosso grupo de teste da família.', sentAt: DateTime.now().subtract(const Duration(minutes: 59)), status: 'read'),
    ];
    statuses = [
      StatusItem(author: 'Mamãe', text: 'Testando o ZapMini com a família 💚', createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    ];
  }

  Future<void> _persistAll() async {
    await _store.saveChildren(children);
    await _store.saveContacts(contacts);
    await _store.saveChats(chats);
    await _store.saveMessages(messages);
    await _store.saveStatuses(statuses);
  }

  Future<void> loginGuardian({required String name, required String phone}) async {
    currentUser = AppUser.guardian(name: name, phone: phone);
    await _store.saveUser(currentUser!);
    notifyListeners();
  }

  Future<void> createChild(String name) async {
    if (currentUser == null) return;
    final child = AppUser.child(name: name, guardianId: currentUser!.id);
    children = [...children, child];
    await _store.saveChildren(children);
    notifyListeners();
  }

  Future<void> switchToChild(AppUser child) async {
    currentUser = child;
    await _store.saveUser(child);
    notifyListeners();
  }

  Future<void> switchToGuardian(AppUser guardian) async {
    currentUser = guardian;
    await _store.saveUser(guardian);
    notifyListeners();
  }

  Future<void> addContact(String name, String subtitle) async {
    final c = ChatContact(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, subtitle: subtitle, avatar: name.isNotEmpty ? name[0].toUpperCase() : '?', approved: false);
    contacts = [...contacts, c];
    await _store.saveContacts(contacts);
    notifyListeners();
  }

  Future<void> approveContact(String id) async {
    contacts = contacts.map((c) => c.id == id ? ChatContact(id: c.id, name: c.name, subtitle: c.subtitle.replaceAll(' (pendente)', ''), avatar: c.avatar, approved: true) : c).toList();
    await _store.saveContacts(contacts);
    notifyListeners();
  }

  ChatThread? chatById(String id) {
    for (final c in chats) {
      if (c.id == id) return c;
    }
    return null;
  }

  List<ChatMessage> messagesFor(String chatId) {
    final list = messages.where((m) => m.chatId == chatId).toList();
    list.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return list;
  }

  Future<ChatThread> createDirectChat(ChatContact contact) async {
    final existing = chats.where((c) => !c.isGroup && c.memberIds.contains(contact.id));
    if (existing.isNotEmpty) return existing.first;
    final thread = ChatThread(id: 't${DateTime.now().millisecondsSinceEpoch}', title: contact.name, avatar: contact.avatar, memberIds: ['me', contact.id]);
    chats = [thread, ...chats];
    await _store.saveChats(chats);
    notifyListeners();
    return thread;
  }

  Future<void> createGroup(String name, List<ChatContact> members) async {
    final thread = ChatThread(
      id: 'g${DateTime.now().millisecondsSinceEpoch}',
      title: name,
      avatar: name.isNotEmpty ? name[0].toUpperCase() : 'G',
      isGroup: true,
      memberIds: ['me', ...members.map((m) => m.id)],
      lastMessage: 'Grupo criado',
      lastMessageAt: DateTime.now(),
    );
    chats = [thread, ...chats];
    messages = [...messages, ChatMessage(chatId: thread.id, senderId: 'system', text: 'Grupo "$name" criado', type: 'system')];
    await _store.saveChats(chats);
    await _store.saveMessages(messages);
    notifyListeners();
  }

  Future<void> sendMessage(String chatId, String text, {String type = 'text', String? mediaPath}) async {
    final msg = ChatMessage(chatId: chatId, senderId: currentUser?.id ?? 'me', text: text, type: type, mediaPath: mediaPath);
    messages = [...messages, msg];
    chats = chats.map((c) => c.id == chatId ? c.copyWith(lastMessage: type == 'text' ? text : '[$type]', lastMessageAt: msg.sentAt, unread: 0) : c).toList();
    chats.sort((a, b) => (b.lastMessageAt ?? DateTime(0)).compareTo(a.lastMessageAt ?? DateTime(0)));
    await _store.saveMessages(messages);
    await _store.saveChats(chats);
    notifyListeners();

    // Demo auto-reply in 1:1 chats
    final chat = chatById(chatId);
    if (chat != null && !chat.isGroup) {
      Future.delayed(const Duration(seconds: 2), () async {
        final reply = ChatMessage(chatId: chatId, senderId: chat.memberIds.firstWhere((m) => m != 'me', orElse: () => 'c1'), text: 'Recebido no ZapMini! ✅', status: 'delivered');
        messages = [...messages, reply];
        chats = chats.map((c) => c.id == chatId ? c.copyWith(lastMessage: reply.text, lastMessageAt: reply.sentAt) : c).toList();
        chats.sort((a, b) => (b.lastMessageAt ?? DateTime(0)).compareTo(a.lastMessageAt ?? DateTime(0)));
        await _store.saveMessages(messages);
        await _store.saveChats(chats);
        notifyListeners();
      });
    }
  }

  Future<void> addStatus(String text) async {
    final item = StatusItem(author: currentUser?.name ?? 'Você', text: text);
    statuses = [item, ...statuses];
    await _store.saveStatuses(statuses);
    notifyListeners();
  }

  Future<void> logout() async {
    currentUser = null;
    await _store.clearUser();
    notifyListeners();
  }
}
