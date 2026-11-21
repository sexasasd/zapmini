import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class LocalStore {
  static const _kUser = 'current_user';
  static const _kChildren = 'children';
  static const _kContacts = 'contacts';
  static const _kChats = 'chats';
  static const _kMessages = 'messages';
  static const _kStatuses = 'statuses';

  Future<SharedPreferences> get _p async => SharedPreferences.getInstance();

  Future<AppUser?> loadUser() async {
    final p = await _p;
    final s = p.getString(_kUser);
    if (s == null) return null;
    return AppUser.fromJson(jsonDecode(s));
  }

  Future<void> saveUser(AppUser user) async {
    final p = await _p;
    await p.setString(_kUser, jsonEncode(user.toJson()));
  }

  Future<void> clearUser() async {
    final p = await _p;
    await p.remove(_kUser);
  }

  Future<List<AppUser>> loadChildren() async => _loadList(_kChildren, AppUser.fromJson);
  Future<void> saveChildren(List<AppUser> items) async => _saveList(_kChildren, items, (e) => e.toJson());

  Future<List<ChatContact>> loadContacts() async => _loadList(_kContacts, ChatContact.fromJson);
  Future<void> saveContacts(List<ChatContact> items) async => _saveList(_kContacts, items, (e) => e.toJson());

  Future<List<ChatThread>> loadChats() async => _loadList(_kChats, ChatThread.fromJson);
  Future<void> saveChats(List<ChatThread> items) async => _saveList(_kChats, items, (e) => e.toJson());

  Future<List<ChatMessage>> loadMessages() async => _loadList(_kMessages, ChatMessage.fromJson);
  Future<void> saveMessages(List<ChatMessage> items) async => _saveList(_kMessages, items, (e) => e.toJson());

  Future<List<StatusItem>> loadStatuses() async => _loadList(_kStatuses, StatusItem.fromJson);
  Future<void> saveStatuses(List<StatusItem> items) async => _saveList(_kStatuses, items, (e) => e.toJson());

  Future<List<T>> _loadList<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final p = await _p;
    final s = p.getString(key);
    if (s == null) return [];
    final list = jsonDecode(s) as List;
    return list.map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> _saveList<T>(String key, List<T> items, Map<String, dynamic> Function(T) toJson) async {
    final p = await _p;
    await p.setString(key, jsonEncode(items.map(toJson).toList()));
  }
}
