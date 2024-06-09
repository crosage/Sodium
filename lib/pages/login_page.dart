import 'package:fluent_ui/fluent_ui.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import '../component/required_text_field.dart';

class LoginPage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  LoginPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  requiredTextField(
                    controller: _usernameController,
                    width: 300,
                    placeholder: "用户名",
                    text: "Username",
                  ),
                  SizedBox(height: 20),
                  requiredTextField(
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
                        onPressed: () => debugPrint('pressed button'),
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

  void _login(BuildContext context) {

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

    ElegantNotification.success(
      title: Text("success"),
      description: Text("登录成功"),
      animation: AnimationType.fromTop,
    ).show(context);
    widget.navigateToNewPage(1);
    print('用户名: $username');
    print('密码: $password');
  }

}
