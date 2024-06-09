import 'package:fluent_ui/fluent_ui.dart';
import 'package:sodium/model/role.dart';


class User {
  String? token;
  String username;
  int uid;
  List<Role> roles;

  User({
    required this.username,
    required this.uid,
    this.token,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var rolesFromJson = json['roles'] as List;
    List<Role> roleList = rolesFromJson.map((i) => Role.fromJson(i)).toList();
    return User(
      username: json['username'],
      uid: json['uid'],
      roles: roleList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
      'uid': uid,
      'roles': roles.map((r) => r.toJson()).toList(),
    };
  }
}

class UserModel with ChangeNotifier {
  String _token = "";
  String _name = "";
  int _uid = 0;
  List<Role> _roles = [];

  String get token => _token;
  String get name => _name;
  int get uid => _uid;
  List<Role> get roles => _roles;

  set token(String newToken) {
    _token = newToken;
    notifyListeners();
  }


  set name(String newName) {
    _name = newName;
    notifyListeners();
  }

  set uid(int newUid) {
    _uid = newUid;
    notifyListeners();
  }

  set roles(List<Role> newRoles) {
    _roles = newRoles;
    notifyListeners();
  }

  void updateUser(User user) {
    _token = user.token ?? "";
    _name = user.username;
    _uid = user.uid;
    _roles = user.roles;
    notifyListeners();
  }

  void clearUser() {
    _token = "";
    _name = "";
    _uid = 0;
    _roles = [];
    notifyListeners();
  }
}
