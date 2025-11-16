class User {
  final int? id;
  final String username;
  final String password;
  final DateTime createdAt;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.createdAt,
  });

  // Convertir un User en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Créer un User à partir d'une Map SQLite
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Créer une copie de l'utilisateur avec des modifications
  User copyWith({
    int? id,
    String? username,
    String? password,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
