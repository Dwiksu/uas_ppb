class User {
  int? id;
  String username;
  String password;

  User({this.id, required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'password': password,
    };
  }
}
