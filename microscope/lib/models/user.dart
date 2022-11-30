class User {
  final String uid;
  final String email;
  final String username;

  User({required this.uid, required this.email, required this.username});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
    };
  }

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
    );
  }
}
