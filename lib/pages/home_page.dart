import 'package:flutter/material.dart';

import '../models/channel.dart';
import '../models/server.dart';
import '../widgets/channel_sidebar.dart';
import '../widgets/match_card.dart';
import '../widgets/player_section.dart';
import '../widgets/server_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';

  late Channel selectedChannel;
  late Server selectedServer;

  final List<Channel> channels = [
    Channel(
      id: '1',
      name: 'World Cup Main',
      category: 'Official Coverage',
      logoText: 'WC',
      isLive: true,
      viewers: 18240,
      servers: [
        Server(
          id: 's1',
          name: 'Server 1',
          quality: 'HD',
          url: 'YOUR_STREAM_URL_HERE',
        ),
        Server(
          id: 's2',
          name: 'Server 2',
          quality: 'Full HD',
          url: 'YOUR_STREAM_URL_HERE',
        ),
        Server(
          id: 's3',
          name: 'Server 3',
          quality: 'Backup',
          url: 'YOUR_STREAM_URL_HERE',
        ),
      ],
    ),
    Channel(
      id: '2',
      name: 'Sports Live 1',
      category: 'English Commentary',
      logoText: 'SL',
      isLive: true,
      viewers: 9250,
      servers: [
        Server(
          id: 's1',
          name: 'Server 1',
          quality: 'HD',
          url: 'YOUR_STREAM_URL_HERE',
        ),
        Server(
          id: 's2',
          name: 'Server 2',
          quality: 'Backup',
          url: 'YOUR_STREAM_URL_HERE',
        ),
      ],
    ),
    Channel(
      id: '3',
      name: 'Bangla Sports',
      category: 'Bangla Commentary',
      logoText: 'BD',
      isLive: true,
      viewers: 11300,
      servers: [
        Server(
          id: 's1',
          name: 'Server 1',
          quality: 'HD',
          url: 'YOUR_STREAM_URL_HERE',
        ),
        Server(
          id: 's2',
          name: 'Server 2',
          quality: 'Mobile',
          url: 'YOUR_STREAM_URL_HERE',
        ),
      ],
    ),
    Channel(
      id: '4',
      name: 'Match Center',
      category: 'Highlights & Analysis',
      logoText: 'MC',
      isLive: false,
      viewers: 3200,
      servers: [
        Server(
          id: 's1',
          name: 'Server 1',
          quality: 'HD',
          url: 'YOUR_STREAM_URL_HERE',
        ),
      ],
    ),
  ];

  final List<Map<String, dynamic>> matches = [
    {
      'teamA': 'Argentina',
      'teamB': 'Brazil',
      'time': 'Live Now',
      'stage': 'Group Stage',
      'isLive': true,
    },
    {
      'teamA': 'France',
      'teamB': 'Germany',
      'time': '22:00',
      'stage': 'Group Stage',
      'isLive': false,
    },
    {
      'teamA': 'England',
      'teamB': 'Spain',
      'time': '01:00',
      'stage': 'Group Stage',
      'isLive': false,
    },
  ];

  @override
  void initState() {
    super.initState();

    selectedChannel = channels.first;
    selectedServer = selectedChannel.servers.first;
  }

  List<Channel> get filteredChannels {
    if (searchText.trim().isEmpty) {
      return channels;
    }

    return channels.where((channel) {
      final query = searchText.toLowerCase();

      return channel.name.toLowerCase().contains(query) ||
          channel.category.toLowerCase().contains(query);
    }).toList();
  }

  void selectChannel(Channel channel) {
    setState(() {
      selectedChannel = channel;
      selectedServer = channel.servers.first;
    });
  }

  void selectServer(Server server) {
    setState(() {
      selectedServer = server;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070D),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 850;

            if (isMobile) {
              return _mobileLayout();
            }

            return _desktopLayout();
          },
        ),
      ),
    );
  }

  Widget _desktopLayout() {
    return Row(
      children: [
        ChannelSidebar(
          channels: filteredChannels,
          selectedChannel: selectedChannel,
          onChannelSelected: selectChannel,
          searchText: searchText,
          onSearchChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
          isMobile: false,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: _mainContent(),
          ),
        ),
      ],
    );
  }

  Widget _mobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ChannelSidebar(
            channels: filteredChannels,
            selectedChannel: selectedChannel,
            onChannelSelected: selectChannel,
            searchText: searchText,
            onSearchChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            isMobile: true,
          ),
          const SizedBox(height: 20),
          _mainContent(),
        ],
      ),
    );
  }

  Widget _mainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _topHeader(),

        const SizedBox(height: 22),

        PlayerSection(
          channel: selectedChannel,
          server: selectedServer,
        ),

        const SizedBox(height: 18),

        Text(
          'Available Servers',
          style: _sectionTitleStyle(),
        ),

        const SizedBox(height: 12),

        ServerButtons(
          servers: selectedChannel.servers,
          selectedServer: selectedServer,
          onServerSelected: selectServer,
        ),

        const SizedBox(height: 30),

        Text(
          'Today Matches',
          style: _sectionTitleStyle(),
        ),

        const SizedBox(height: 14),

        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: matches.map((match) {
            return MatchCard(
              teamA: match['teamA'],
              teamB: match['teamB'],
              time: match['time'],
              stage: match['stage'],
              isLive: match['isLive'],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _topHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00D084),
                  Color(0xFF38BDF8),
                ],
              ),
            ),
            child: const Icon(
              Icons.sports_soccer_rounded,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FIFA World Cup 2026',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Live matches, channels, servers and schedules',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
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
        ],
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w800,
    );
  }
}