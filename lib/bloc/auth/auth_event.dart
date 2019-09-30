import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {}

class AuthSuccess extends AuthEvent {}

class LogOut extends AuthEvent {
  final String userName;
  final String token;
  final String email;
  final int userId;

  LogOut(this.userName, this.token, this.email, this.userId);

  LogOut.fromJson(Map<String, dynamic> json)
      : userName = json['name'],
        token = json['token'],
        email = json['email'],
        userId = json['pk'];

  Map<String, dynamic> toJson() => {
    'name': userName,
    'token': token,
    'email': email,
    'pk': userId,
  };
}
