import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final channelNameController = TextEditingController();
  final categoryController = TextEditingController();
  final logoController = TextEditingController();

  final serverNameController = TextEditingController();
  final qualityController = TextEditingController();
  final streamUrlController = TextEditingController();

  bool loading = true;
  bool channelLoading = false;
  bool serverLoading = false;

  List<Map<String, dynamic>> channels = [];
  List<Map<String, dynamic>> servers = [];
  String? selectedChannelId;

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    try {
      final channelData = await SupabaseService.getChannels();
      final List<Map<String, dynamic>> serverData = [];

      for (final channel in channelData) {
        final id = channel['id']?.toString();
        if (id != null) {
          final s = await SupabaseService.getServers(id);
          serverData.addAll(s);
        }
      }

      if (!mounted) return;

      setState(() {
        channels = channelData;
        servers = serverData;
        selectedChannelId =
            channels.isNotEmpty ? channels.first['id'].toString() : null;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  Future<void> addChannel() async {
    setState(() => channelLoading = true);

    await SupabaseService.addChannel(
      name: channelNameController.text.trim(),
      category: categoryController.text.trim(),
      logoText: logoController.text.trim(),
    );

    channelNameController.clear();
    categoryController.clear();
    logoController.clear();

    await loadAll();

    if (!mounted) return;
    setState(() => channelLoading = false);
  }

  Future<void> addServer() async {
    if (selectedChannelId == null) return;

    setState(() => serverLoading = true);

    await SupabaseService.addServer(
      channelId: selectedChannelId!,
      name: serverNameController.text.trim(),
      quality: qualityController.text.trim(),
      streamUrl: streamUrlController.text.trim(),
    );

    serverNameController.clear();
    qualityController.clear();
    streamUrlController.clear();

    await loadAll();

    if (!mounted) return;
    setState(() => serverLoading = false);
  }

  Future<void> deleteChannel(String id) async {
    await SupabaseService.deleteChannel(id);
    await loadAll();
  }

  Future<void> deleteServer(String id) async {
    await SupabaseService.deleteServer(id);
    await loadAll();
  }

  String getChannelName(String id) {
    final found = channels.where((c) => c['id'].toString() == id).toList();
    return found.isNotEmpty ? found.first['name'].toString() : 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Add Channel', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            TextField(controller: channelNameController, decoration: const InputDecoration(labelText: 'Channel Name')),
            TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
            TextField(controller: logoController, decoration: const InputDecoration(labelText: 'Logo Text')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: channelLoading ? null : addChannel,
              child: Text(channelLoading ? 'Adding...' : 'Add Channel'),
            ),

            const Divider(height: 50),

            const Text('Add Server', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              initialValue: selectedChannelId,
              decoration: const InputDecoration(labelText: 'Select Channel'),
              items: channels.map((channel) {
                return DropdownMenuItem<String>(
                  value: channel['id'].toString(),
                  child: Text(channel['name'].toString()),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedChannelId = value),
            ),
            TextField(controller: serverNameController, decoration: const InputDecoration(labelText: 'Server Name')),
            TextField(controller: qualityController, decoration: const InputDecoration(labelText: 'Quality')),
            TextField(controller: streamUrlController, decoration: const InputDecoration(labelText: 'Stream URL')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: serverLoading ? null : addServer,
              child: Text(serverLoading ? 'Adding...' : 'Add Server'),
            ),

            const Divider(height: 50),

            const Text('Channel List', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            for (final channel in channels)
              Card(
                child: ListTile(
                  title: Text(channel['name'].toString()),
                  subtitle: Text(channel['category'].toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteChannel(channel['id'].toString()),
                  ),
                ),
              ),

            const Divider(height: 50),

            const Text('Server List', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            for (final server in servers)
              Card(
                child: ListTile(
                  title: Text(server['name'].toString()),
                  subtitle: Text('${getChannelName(server['channel_id'].toString())} • ${server['quality']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteServer(server['id'].toString()),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}