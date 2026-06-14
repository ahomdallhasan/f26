import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../models/channel.dart';
import '../models/server.dart';

class PlayerSection extends StatefulWidget {
  final Channel channel;
  final Server server;

  const PlayerSection({
    super.key,
    required this.channel,
    required this.server,
  });

  @override
  State<PlayerSection> createState() => _PlayerSectionState();
}

class _PlayerSectionState extends State<PlayerSection> {
  late final Player player;
  late final VideoController videoController;

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    player = Player();
    videoController = VideoController(player);

    _loadStream();
  }

  @override
  void didUpdateWidget(PlayerSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.server.url != widget.server.url ||
        oldWidget.channel.id != widget.channel.id) {
      _loadStream();
    }
  }

  Future<void> _loadStream() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final String url = widget.server.url;

    if (url == 'YOUR_STREAM_URL_HERE') {
      await player.stop();

      setState(() {
        isLoading = false;
      });

      return;
    }

    try {
      await player.open(
        Media(url),
        play: true,
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Stream load failed';
      });
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasRealStream = widget.server.url != 'YOUR_STREAM_URL_HERE';

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              Positioned.fill(
                child: Video(controller: videoController),
              ),

              if (!hasRealStream)
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFF020617),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 80,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Media Kit Player Ready',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${widget.server.name} • ${widget.server.quality}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Stream URL placeholder active',
                            style: TextStyle(color: Colors.white38),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              if (isLoading)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00D084),
                      ),
                    ),
                  ),
                ),

              if (errorMessage != null)
                Positioned.fill(
                  child: Container(
                    color: Colors.black87,
                    child: Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

              Positioned(
                top: 16,
                left: 16,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.channel.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                right: 16,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '${widget.channel.viewers} watching',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}