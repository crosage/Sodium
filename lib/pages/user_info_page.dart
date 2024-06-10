import 'package:flutter/material.dart' show Icons, Material, TextField;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../model/user.dart';
import '../main.dart';
import '../service/httphelper.dart';

class UserInfoPage extends StatefulWidget {
  final Function(int) navigateToNewPage;

  UserInfoPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late TextEditingController _controller;
  late final UserModel userModel;
  final HttpHelper httpHelper = HttpHelper();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    userModel = Provider.of<UserModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: userModel.roles.map((role) {
            bool isSelected = userModel.currentRole == role;
            return GestureDetector(
              onTap: () {
                setState(() {
                  userModel.currentRole = role;
                });
              },
              child: Container(
                width: 200,
                height: 200,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black, // 边框颜色
                    width: 1.0, // 边框宽度
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.person_outline,size: 150,),
                      Text(
                        role.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
