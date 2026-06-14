import 'server.dart';

class Channel {
  final String id;
  final String name;
  final String category;
  final String logoText;
  final bool isLive;
  final int viewers;
  final List<Server> servers;

  Channel({
    required this.id,
    required this.name,
    required this.category,
    required this.logoText,
    required this.isLive,
    required this.viewers,
    required this.servers,
  });
}