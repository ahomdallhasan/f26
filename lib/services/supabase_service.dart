import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getChannels() async {
    final data = await supabase.from('channels').select().order('created_at');
    return List<Map<String, dynamic>>.from(data);
  }

  static Future<List<Map<String, dynamic>>> getServers(String channelId) async {
    final data = await supabase
        .from('servers')
        .select()
        .eq('channel_id', channelId)
        .order('created_at');

    return List<Map<String, dynamic>>.from(data);
  }

  static Future<void> addChannel({
    required String name,
    required String category,
    required String logoText,
  }) async {
    await supabase.from('channels').insert({
      'name': name,
      'category': category,
      'logo_text': logoText,
      'is_live': true,
      'viewers': 0,
    });
  }

  static Future<void> addServer({
    required String channelId,
    required String name,
    required String quality,
    required String streamUrl,
  }) async {
    await supabase.from('servers').insert({
      'channel_id': channelId,
      'name': name,
      'quality': quality,
      'stream_url': streamUrl,
    });
  }

  static Future<void> deleteChannel(String channelId) async {
    await supabase.from('channels').delete().eq('id', channelId);
  }

  static Future<void> deleteServer(String serverId) async {
    await supabase.from('servers').delete().eq('id', serverId);
  }
}