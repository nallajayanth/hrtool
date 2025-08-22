import 'package:hr_tool/riverpod/user_details/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  static Future<List<UserModel>> fetchData() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;
    print(userId);
    final response = await supabase.from("users").select().eq("id", userId);
    return (response as List).map((item) => UserModel.fromJson(item)).toList();
  }
}
