import 'user_model.dart';

class LoginModel {
  late final String status;
  late final String token;
  late final UserModel user;

  LoginModel.fromJson(Map<String, dynamic>jsonData){
    status = jsonData['status']?? '';
    user = UserModel.fromJson(jsonData['data']?? '');
    token = jsonData['token']?? '';
  }
}