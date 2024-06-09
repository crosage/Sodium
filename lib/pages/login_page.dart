import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../component/required_text_field.dart';
import '../main.dart';
import '../model/user.dart';
import '../service/httphelper.dart';

class LoginPage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  LoginPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  HttpHelper httpHelper=HttpHelper();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


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
                  Text("登录",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),),
                  SizedBox(height: 20),
                  RequiredTextField(
                    controller: _usernameController,
                    width: 300,
                    placeholder: "用户名",
                    text: "Username",
                  ),
                  SizedBox(height: 20),
                  RequiredTextField(
                    placeholder: "密码",
                    text: "password",
                    width: 300,
                    controller: _passwordController,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        child: const Text('登录'),
                        onPressed: () => _login(context),
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

  void _login(BuildContext context) async{

    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ElegantNotification.error(
        title: Text("error"),
        description: Text("用户名或密码不能为空"),
        animation: AnimationType.fromTop,
      ).show(context);
      return;
    }
    try{
      Map<String,dynamic> postData={
        "username":username,
        "password":password
      };
      Response getResponse= await httpHelper.postRequest(BaseUrl+"/api/user/login",postData);
      Map<String, dynamic> responseData = jsonDecode(getResponse.toString());
      if (responseData["code"]==200) {
        var data = responseData["data"];
        User now=User.fromJson(data);
        now.token=data["token"];
        Provider.of<UserModel>(context, listen: false).updateUser(now);
        ElegantNotification.success(
          title: Text("success"),
          description: Text("登录成功"),
          animation: AnimationType.fromTop,
        ).show(context);
        widget.navigateToNewPage(6);
      } else {
        ElegantNotification.error(
          title: Text("error"),
          description: Text(responseData["message"]),
          animation: AnimationType.fromTop,
        ).show(context);
      }


    }catch(e){
      ElegantNotification.error(
        title: Text("error"),
        description: Text(e.toString()),
        animation: AnimationType.fromTop,
      ).show(context);
    }
  }
}
