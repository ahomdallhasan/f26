import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getChannels() async {
    final data = await supabase
        .from('channels')
        .select()
        .order('created_at');

    return List<Map<String, dynamic>>.from(data);
  }

  static Future<List<Map<String, dynamic>>> getServers(
    String channelId,
  ) async {
    final data = await supabase
        .from('servers')
        .select()
        .eq('channel_id', channelId)
        .order('created_at');

    return List<Map<String, dynamic>>.from(data);
  }
}