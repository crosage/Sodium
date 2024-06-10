import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show DataCell, DataColumn, DataRow, DataTable, Material, RawChip;
import 'package:provider/provider.dart';
import '../../model/user.dart';
import '../component/table.dart';
import '../component/tag_chip.dart';
import '../main.dart';
import '../model/role.dart';
import '../service/httphelper.dart';

Tab createUsersTab(BuildContext context, Function onClosed) {
  final HttpHelper httpHelper = HttpHelper();
  final UserModel userModel = Provider.of<UserModel>(context, listen: false);
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late List<Role> roles = [];
  List<int> selectedChips = [];

  List<User> _parseUsers(List<dynamic> usersData) {
    List<User> parsedUsers = [];
    for (var userData in usersData) {
      parsedUsers.add(User.fromJson(userData));
    }
    return parsedUsers;
  }

  void handleClose() {
    onClosed();
  }

  List<Role> _parseRoles(List<dynamic> rolesData) {
    List<Role> parsedUsers = [];
    for (var roleData in rolesData) {
      parsedUsers.add(Role.fromJson(roleData));
    }
    return parsedUsers;
  }

  Future<List<User>> fetchData() async {
    try {
      Response getResponse = await httpHelper.getRequest(BaseUrl + "/api/role",
          token: userModel.token);
      Map<String, dynamic> responseData = jsonDecode(getResponse.toString());
      roles = _parseRoles(responseData["roles"]);
      getResponse = await httpHelper.getRequest(BaseUrl + "/api/user",
          token: userModel.token);
      responseData = jsonDecode(getResponse.toString());
      print(roles);
      if (getResponse.statusCode == 200) {
        List<User> parsedUsers = _parseUsers(responseData["users"]);
        return parsedUsers;
      } else {
        // Handle response code not 200
        return [];
      }
    } catch (e) {
      // Handle error
      return [];
    }
  }

  return Tab(
    onClosed: handleClose,
    text: Text("用户数据"),
    body: FutureBuilder<List<User>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: ProgressRing(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found'));
        } else {
          List<User> users = snapshot.data!;
          List<List<dynamic>> u = [];
          for (var user in users) {
            List<dynamic> now = [];
            now.add(user.uid);
            now.add(user.username);
            now.add(user.roles.map((role) => role.name).join(", "));
            u.add(now);
          }
          return Container(
            width: 5000,
            height: 5000,
            child: Material(
              child: TableWidget(
                headers: ["用户id", "用户名称", "用户类型"],
                data: u,
                onRowTap: (index, header) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ContentDialog(
                        title: Text("更改用户信息"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "用户类型：",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TagChip(
                              label: "普通员工",
                              onSelectionChanged: (isSelected) {
                                if (isSelected) {
                                  selectedChips.add(1);
                                } else {
                                  selectedChips.remove(1);
                                }
                              },
                            ),
                            TagChip(
                              label: "审计人员",
                              onSelectionChanged: (isSelected) {
                                if (isSelected) {
                                  selectedChips.add(2);
                                } else {
                                  selectedChips.remove(2);
                                }
                              },
                            ),
                            TagChip(
                              label: "系统管理员",
                              onSelectionChanged: (isSelected) {
                                if (isSelected) {
                                  selectedChips.add(3);
                                } else {
                                  selectedChips.remove(3);
                                }
                              },
                            ),
                          ],
                        ),
                        actions: [
                          Button(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("取消"),
                          ),
                          FilledButton(
                            onPressed: () async {
                              final httpHelper = HttpHelper();
                              Map<String, dynamic> postData = {
                                "rids": selectedChips,
                              };
                              final response = await httpHelper.postRequest(
                                  BaseUrl +
                                      "/api/roles/" +
                                      users[index].uid.toString(),
                                  postData,
                                  token: userModel.token);
                              Navigator.of(context).pop();
                            },
                            child: Text("确认更改"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        }
      },
    ),
  );
}
