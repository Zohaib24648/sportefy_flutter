import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class AppModule {
  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @singleton
  GoTrueClient get supabaseAuth => Supabase.instance.client.auth;
}

