
// модель данных профиля
class Profile {
  String name;
  String email;
  String phone;
  List<Avatar> avatars;

  Profile({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatars,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatars: List<Avatar>.from(json['avatars']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatars': avatars,
    };
  }
}

// модель данных аватара профиля
class Avatar {
  String path;
  bool isLocal;

  Avatar({
    required this.path,
    required this.isLocal,
  });
}