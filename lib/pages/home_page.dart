import 'package:flutter/material.dart';

import '../models/channel.dart';
import '../models/server.dart';
import '../services/supabase_service.dart';
import '../widgets/channel_sidebar.dart';
import '../widgets/match_card.dart';
import '../widgets/player_section.dart';
import '../widgets/server_buttons.dart';
import 'admin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';
  bool isLoading = true;
  String? errorMessage;

  List<Channel> channels = [];
  Channel? selectedChannel;

  Server selectedServer = Server(
    id: 'default',
    name: 'No Server',
    quality: 'N/A',
    url: 'YOUR_STREAM_URL_HERE',
  );

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
    loadChannels();
  }

  Future<void> loadChannels() async {
    try {
      final channelData = await SupabaseService.getChannels();
      final List<Channel> loadedChannels = [];

      for (final channelMap in channelData) {
        final serverData = await SupabaseService.getServers(channelMap['id']);

        final servers = serverData.map((serverMap) {
          return Server(
            id: serverMap['id'],
            name: serverMap['name'],
            quality: serverMap['quality'],
            url: serverMap['stream_url'],
          );
        }).toList();

        loadedChannels.add(
          Channel(
            id: channelMap['id'],
            name: channelMap['name'],
            category: channelMap['category'],
            logoText: channelMap['logo_text'],
            isLive: channelMap['is_live'] ?? true,
            viewers: channelMap['viewers'] ?? 0,
            servers: servers,
          ),
        );
      }

      setState(() {
        channels = loadedChannels;
        selectedChannel = channels.isNotEmpty ? channels.first : null;

        selectedServer =
            selectedChannel != null && selectedChannel!.servers.isNotEmpty
                ? selectedChannel!.servers.first
                : Server(
                    id: 'default',
                    name: 'No Server',
                    quality: 'N/A',
                    url: 'YOUR_STREAM_URL_HERE',
                  );

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load channels';
        isLoading = false;
      });
    }
  }

  List<Channel> get filteredChannels {
    if (searchText.trim().isEmpty) return channels;

    return channels.where((channel) {
      final query = searchText.toLowerCase();
      return channel.name.toLowerCase().contains(query) ||
          channel.category.toLowerCase().contains(query);
    }).toList();
  }

  void selectChannel(Channel channel) {
    setState(() {
      selectedChannel = channel;

      selectedServer = channel.servers.isNotEmpty
          ? channel.servers.first
          : Server(
              id: 'default',
              name: 'No Server',
              quality: 'N/A',
              url: 'YOUR_STREAM_URL_HERE',
            );
    });
  }

  void selectServer(Server server) {
    setState(() {
      selectedServer = server;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF05070D),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00D084)),
        ),
      );
    }

    if (errorMessage != null || selectedChannel == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF05070D),
        body: Center(
          child: Text(
            errorMessage ?? 'No channels found',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF05070D),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 850;
            return isMobile ? _mobileLayout() : _desktopLayout();
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
          selectedChannel: selectedChannel!,
          onChannelSelected: selectChannel,
          searchText: searchText,
          onSearchChanged: (value) => setState(() => searchText = value),
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
            selectedChannel: selectedChannel!,
            onChannelSelected: selectChannel,
            searchText: searchText,
            onSearchChanged: (value) => setState(() => searchText = value),
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
          channel: selectedChannel!,
          server: selectedServer,
        ),
        const SizedBox(height: 18),
        Text('Available Servers', style: _sectionTitleStyle()),
        const SizedBox(height: 12),
        ServerButtons(
          servers: selectedChannel!.servers.isNotEmpty
              ? selectedChannel!.servers
              : [selectedServer],
          selectedServer: selectedServer,
          onServerSelected: selectServer,
        ),
        const SizedBox(height: 30),
        Text('Today Matches', style: _sectionTitleStyle()),
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
          const Icon(
            Icons.sports_soccer_rounded,
            color: Color(0xFF00D084),
            size: 42,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'FIFA World Cup 2026',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
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