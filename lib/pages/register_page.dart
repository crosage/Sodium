import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';

import '../component/required_text_field.dart';
import '../main.dart';
import '../service/httphelper.dart';

class RegisterPage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  RegisterPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  HttpHelper httpHelper=HttpHelper();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _checkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      padding: EdgeInsets.only(bottom:0),
      content: Container(
        color: Color.fromARGB(255, 245, 245, 245),
        child: Center(
          child: Container(
            width: 350,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Container(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 60,
                  ),
                  Text("区块链系统-注册",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  RequiredTextField(
                    controller: _usernameController,
                    width: 300,
                    placeholder: "输入用户名",
                    text: "Username",
                  ),
                  SizedBox(height: 20),
                  RequiredTextField(
                    placeholder: "输入密码",
                    text: "password",
                    width: 300,
                    controller: _passwordController,
                  ),
                  SizedBox(height: 20),
                  RequiredTextField(
                    placeholder: "确认密码",
                    text: "check your password",
                    width: 300,
                    controller: _checkController,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        child: const Text('注册'),
                        onPressed: () => register(context),
                      ),
                      SizedBox(width: 30,)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void register(BuildContext context) async{
    // 获取用户输入的用户名、密码和确认密码
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _checkController.text;

    // 验证用户名、密码和确认密码是否为空
    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      // 如果有任何一个为空，显示错误提示
      ElegantNotification.error(
        title: Text("error"),
        description: Text("含有未填字段"),
        animation: AnimationType.fromTop,
      ).show(context);
      return;
    }

    // 验证密码和确认密码是否相同
    if (password != confirmPassword) {
      // 如果不相同，显示错误提示
      ElegantNotification.error(
        title: Text("error"),
        description: Text("两次密码不同"),
        animation: AnimationType.fromTop,
      ).show(context);
      return;
    }
    try{
      Map<String,dynamic> postData={
        "username":username,
        "password":password
      };
      Response getResponse= await httpHelper.postRequest(BaseUrl+"/api/user",postData);
      ElegantNotification.success(
        title: Text("success"),
        description: Text("注册成功"),
        animation: AnimationType.fromTop,
      ).show(context);
      widget.navigateToNewPage(1);
    }catch(e){
      ElegantNotification.error(
        title: Text("error"),
        description: Text(e.toString()),
        animation: AnimationType.fromTop,
      ).show(context);
    }
  }
}
