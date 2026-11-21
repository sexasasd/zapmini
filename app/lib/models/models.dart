import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class AppUser {
  final String id;
  final String name;
  final String phone;
  final String role; // guardian | child
  final String? guardianId;
  final String avatar;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.guardianId,
    required this.avatar,
  });

  factory AppUser.guardian({required String name, required String phone}) => AppUser(
        id: _uuid.v4(),
        name: name,
        phone: phone,
        role: 'guardian',
        avatar: name.isNotEmpty ? name[0].toUpperCase() : 'R',
      );

  factory AppUser.child({required String name, required String guardianId}) => AppUser(
        id: _uuid.v4(),
        name: name,
        phone: '',
        role: 'child',
        guardianId: guardianId,
        avatar: name.isNotEmpty ? name[0].toUpperCase() : 'C',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'role': role,
        'guardianId': guardianId,
        'avatar': avatar,
      };

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'],
        name: j['name'] ?? '',
        phone: j['phone'] ?? '',
        role: j['role'] ?? 'child',
        guardianId: j['guardianId'],
        avatar: j['avatar'] ?? '?',
      );
}

class ChatContact {
  final String id;
  final String name;
  final String subtitle;
  final String avatar;
  final bool approved;

  const ChatContact({required this.id, required this.name, required this.subtitle, required this.avatar, this.approved = true});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'subtitle': subtitle, 'avatar': avatar, 'approved': approved};
  factory ChatContact.fromJson(Map<String, dynamic> j) => ChatContact(
        id: j['id'],
        name: j['name'] ?? '',
        subtitle: j['subtitle'] ?? '',
        avatar: j['avatar'] ?? '?',
        approved: j['approved'] ?? true,
      );
}

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final String type; // text, image, audio, system
  final String? mediaPath;
  final DateTime sentAt;
  final String status; // sent, delivered, read

  ChatMessage({
    String? id,
    required this.chatId,
    required this.senderId,
    required this.text,
    this.type = 'text',
    this.mediaPath,
    DateTime? sentAt,
    this.status = 'sent',
  })  : id = id ?? _uuid.v4(),
        sentAt = sentAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': chatId,
        'senderId': senderId,
        'text': text,
        'type': type,
        'mediaPath': mediaPath,
        'sentAt': sentAt.toIso8601String(),
        'status': status,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
        id: j['id'],
        chatId: j['chatId'],
        senderId: j['senderId'],
        text: j['text'] ?? '',
        type: j['type'] ?? 'text',
        mediaPath: j['mediaPath'],
        sentAt: DateTime.tryParse(j['sentAt'] ?? '') ?? DateTime.now(),
        status: j['status'] ?? 'sent',
      );
}

class ChatThread {
  final String id;
  final String title;
  final String avatar;
  final bool isGroup;
  final List<String> memberIds;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unread;

  const ChatThread({
    required this.id,
    required this.title,
    required this.avatar,
    this.isGroup = false,
    this.memberIds = const [],
    this.lastMessage,
    this.lastMessageAt,
    this.unread = 0,
  });

  ChatThread copyWith({String? lastMessage, DateTime? lastMessageAt, int? unread}) => ChatThread(
        id: id,
        title: title,
        avatar: avatar,
        isGroup: isGroup,
        memberIds: memberIds,
        lastMessage: lastMessage ?? this.lastMessage,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        unread: unread ?? this.unread,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'avatar': avatar,
        'isGroup': isGroup,
        'memberIds': memberIds,
        'lastMessage': lastMessage,
        'lastMessageAt': lastMessageAt?.toIso8601String(),
        'unread': unread,
      };

  factory ChatThread.fromJson(Map<String, dynamic> j) => ChatThread(
        id: j['id'],
        title: j['title'] ?? '',
        avatar: j['avatar'] ?? '?',
        isGroup: j['isGroup'] ?? false,
        memberIds: List<String>.from(j['memberIds'] ?? []),
        lastMessage: j['lastMessage'],
        lastMessageAt: j['lastMessageAt'] != null ? DateTime.tryParse(j['lastMessageAt']) : null,
        unread: j['unread'] ?? 0,
      );
}

class StatusItem {
  final String id;
  final String author;
  final String text;
  final DateTime createdAt;

  StatusItem({String? id, required this.author, required this.text, DateTime? createdAt})
      : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {'id': id, 'author': author, 'text': text, 'createdAt': createdAt.toIso8601String()};
  factory StatusItem.fromJson(Map<String, dynamic> j) => StatusItem(
        id: j['id'],
        author: j['author'] ?? '',
        text: j['text'] ?? '',
        createdAt: DateTime.tryParse(j['createdAt'] ?? '') ?? DateTime.now(),
      );
}
