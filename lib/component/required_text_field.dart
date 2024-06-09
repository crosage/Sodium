import 'package:fluent_ui/fluent_ui.dart';

class requiredTextField extends StatelessWidget {
  final String placeholder;
  final String text;
  final double width;
  final TextEditingController controller;

  requiredTextField({
    Key? key,
    required this.placeholder,
    required this.text,
    required this.width,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: text,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextBox(
            controller: controller,
            placeholder: placeholder,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 253, 253, 253),
            ),
          ),
        ],
      ),
    );
  }
}
