import 'package:sec_learning/core/supabase_init.dart' show SupabaseInit;

import '../domain/user_model.dart';

class AuthRepository {
  final _supabase = SupabaseInit.client;

  Future<UserModel?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final response =
        await _supabase.from('profiles').select().eq('id', user.id).single();

    return UserModel.fromJson({...response, 'email': user.email});
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );

    if (response.user == null) {
      throw Exception('Sign up failed');
    }

    await _supabase.from('profiles').insert({
      'id': response.user!.id,
      'name': name,
      'role': role,
    });

    return UserModel(
      id: response.user!.id,
      email: email,
      name: name,
      role: role,
    );
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Sign in failed');
    }

    final userData =
        await _supabase
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .single();

    return UserModel.fromJson({...userData, 'email': response.user!.email});
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
