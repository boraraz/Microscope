class User {
  final String uid;
  final String email;
  final String username;
  final String password;

  User(
      {required this.uid,
      required this.email,
      required this.username,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      password: data['password'] ?? '',
    );
  }
}
