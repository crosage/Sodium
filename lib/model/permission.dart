class Permission {
  int id;
  String name;

  Permission({required this.id, required this.name});

  factory Permission.fromJson(Map<String, dynamic> json) {
    print("333333333");
    return Permission(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}


