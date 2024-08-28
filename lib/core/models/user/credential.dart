import 'dart:convert';

class Credentials {

  final String username, password;

  const Credentials({
    required this.username,
    required this.password,
  });

  toJson() => {
    'username': username,
    'password': password,
  };

  @override
  String toString() => jsonEncode(toJson());

  String toFormUrlEncoded() => 'username=${Uri.encodeFull(username)}&password=${Uri.encodeFull(password)}';
  
  factory Credentials.fromJson(Map<String, dynamic> json) => Credentials(
    username: json['username'] as String,
    password: json['password'] as String,
  );
}