import 'package:hr_tool/riverpod/user_details/model/user_model.dart';
import 'package:hr_tool/riverpod/user_details/services/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_provider.g.dart';

@riverpod
Future<List<UserModel>> UserProvider(UserProviderRef ref) async{
  return await UserService.fetchData();
}
