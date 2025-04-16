import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInit {
  static late final SupabaseClient _client;
  static late final GoTrueClient _auth;

  /// تهيئة Supabase عند بدء التشغيل
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: 'https://jfnbeakgoroxeoxnajhb.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmbmJlYWtnb3JveGVveG5hamhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ3NjE1NjUsImV4cCI6MjA2MDMzNzU2NX0.dSa71I52USgj5ENKQnXgCZQYtVW8_WALB3let81hQEo',

        // authCallbackUrlHostname: 'login-callback', // للـ Deep Linking
        debug: true, // فقط في وضع التطوير
        storageOptions: const StorageClientOptions(
          retryAttempts: 3, // محاولات إعادة الاتصال
        ),
      );

      _client = Supabase.instance.client;
      _auth = _client.auth;

      // إعداد مستمع لتغيرات حالة المصادقة
      _listenAuthChanges();

      debugPrint('✅ Supabase initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing Supabase: $e');
      rethrow;
    }
  }

  /// مستمع لتغيرات حالة تسجيل الدخول
  static void _listenAuthChanges() {
    _auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      debugPrint('Auth state changed: $event');
      if (session != null) {
        debugPrint('User email: ${session.user.email}');
      }
    });
  }

  /// الحصول على Supabase Client
  static SupabaseClient get client {
    return _client;
  }

  /// الحصول على Auth Client
  static GoTrueClient get auth {
    return _auth;
  }

  /// إعادة تهيئة العميل عند الحاجة
  static Future<void> reset() async {
    await _client.auth.signOut();
    await Supabase.instance.dispose();
    await initialize();
  }

  /// التحقق من اتصال Supabase
  static Future<bool> checkConnection() async {
    try {
      await _client.from('curricula').select().limit(1);
      return true;
    } catch (e) {
      debugPrint('Connection check failed: $e');
      return false;
    }
  }
}
