class UserCredentials {
  final String username;
  final String password;
  UserCredentials({required this.username, required this.password});

  UserCredentials.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'grant_type': 'password',
        'username': username,
        'password': password,
      };

  Map<String, String> toMap() => {
        'grant_type': 'password',
        'username': username,
        'password': password,
      };
}
