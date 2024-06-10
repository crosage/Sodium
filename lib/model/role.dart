

import 'package:sodium/model/permission.dart';

class Role {
  int id;
  String name;
  List<Permission> permissions;

  Role({required this.id, required this.name, required this.permissions});

  factory Role.fromJson(Map<String, dynamic> json) {
    print("2222222222");
    var permissionsFromJson = json['permissions'] as List;
    List<Permission> permissionList = permissionsFromJson.map((i) => Permission.fromJson(i)).toList();

    return Role(
      id: json['id'],
      name: json['name'],
      permissions: permissionList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'permissions': permissions.map((p) => p.toJson()).toList(),
    };
  }
}