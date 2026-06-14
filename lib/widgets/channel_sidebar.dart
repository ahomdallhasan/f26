import 'package:flutter/material.dart';
import '../models/channel.dart';

class ChannelSidebar extends StatelessWidget {
  final List<Channel> channels;
  final Channel selectedChannel;
  final Function(Channel) onChannelSelected;
  final String searchText;
  final Function(String) onSearchChanged;
  final bool isMobile;

  const ChannelSidebar({
    super.key,
    required this.channels,
    required this.selectedChannel,
    required this.onChannelSelected,
    required this.searchText,
    required this.onSearchChanged,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchBox(),
          const SizedBox(height: 14),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: channels.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _mobileChannelCard(channels[index]);
              },
            ),
          ),
        ],
      );
    }

    return Container(
      width: 310,
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Color(0xFF080B12),
        border: Border(
          right: BorderSide(color: Colors.white12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WorldCup Live',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'FIFA 2026 Streaming Hub',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 22),
          _searchBox(),
          const SizedBox(height: 22),
          const Text(
            'Live Channels',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: channels.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _desktopChannelTile(channels[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return TextField(
      onChanged: onSearchChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search channel...',
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Colors.white54,
        ),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _desktopChannelTile(Channel channel) {
    final bool isSelected = selectedChannel.id == channel.id;

    return InkWell(
      onTap: () => onChannelSelected(channel),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00D084)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF00D084) : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            _logo(channel, isSelected),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    channel.name,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    channel.category,
                    style: TextStyle(
                      color: isSelected ? Colors.black54 : Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (channel.isLive)
              Icon(
                Icons.circle,
                color: isSelected ? Colors.red : Colors.redAccent,
                size: 10,
              ),
          ],
        ),
      ),
    );
  }

  Widget _mobileChannelCard(Channel channel) {
    final bool isSelected = selectedChannel.id == channel.id;

    return InkWell(
      onTap: () => onChannelSelected(channel),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00D084) : Colors.white10,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF00D084) : Colors.white12,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _logo(channel, isSelected),
            const SizedBox(height: 10),
            Text(
              channel.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logo(Channel channel, bool isSelected) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.black.withValues(alpha: 0.12)
            : Colors.white10,
        shape: BoxShape.circle,
      ),
      child: Text(
        channel.logoText,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}