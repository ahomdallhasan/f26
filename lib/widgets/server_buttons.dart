import 'package:flutter/material.dart';
import '../models/server.dart';

class ServerButtons extends StatelessWidget {
  final List<Server> servers;
  final Server selectedServer;
  final Function(Server) onServerSelected;

  const ServerButtons({
    super.key,
    required this.servers,
    required this.selectedServer,
    required this.onServerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: servers.map((server) {
        final bool isSelected = selectedServer.id == server.id;

        return InkWell(
          onTap: () => onServerSelected(server),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF00D084) : Colors.white10,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? const Color(0xFF00D084) : Colors.white12,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.dns_rounded,
                  color: isSelected ? Colors.black : Colors.white70,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  '${server.name} • ${server.quality}',
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}