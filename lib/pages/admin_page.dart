import 'dart:math';
import 'package:fluent_ui/fluent_ui.dart';
import '../../model/user.dart';
import 'get_users_tab.dart';

class AdminPage extends StatefulWidget {
  final Function(int) navigateToNewPage;
  AdminPage({Key? key, required this.navigateToNewPage}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentIndex = 0;
  List<Tab> tabs = [];
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    // 每次初始化时清空tabs
    tabs = [];
    late Tab tab;
    tab=createUsersTab(context,(){        setState(() {
      tabs!.remove(tab);
      if (currentIndex > 0) currentIndex--;
    });});
    tabs.add(tab);
  }

  Tab generateTab(int index) {
    late Tab tab;
    tab = Tab(
      text: Text('Document $index'),
      semanticLabel: 'Document #$index',
      icon: const FlutterLogo(),
      body: Container(
        color: Colors.accentColors[Random().nextInt(Colors.accentColors.length)],
      ),
      onClosed: () {
        setState(() {
          tabs!.remove(tab);
          if (currentIndex > 0) currentIndex--;
        });
      },
    );
    return tab;
  }
  @override
  Widget build(BuildContext context) {
    return TabView(
      tabs: tabs!,
      currentIndex: currentIndex,
      onChanged: (index) => setState(() => currentIndex = index),
      tabWidthBehavior: TabWidthBehavior.equal,
      closeButtonVisibility: CloseButtonVisibilityMode.always,
      showScrollButtons: true,
      onNewPressed: () {
        setState(() {
          final index = tabs!.length + 1;
          final tab = generateTab(index);
          tabs!.add(tab);
        });
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = tabs!.removeAt(oldIndex);
          tabs!.insert(newIndex, item);

          if (currentIndex == newIndex) {
            currentIndex = oldIndex;
          } else if (currentIndex == oldIndex) {
            currentIndex = newIndex;
          }
        });
      },
    );
  }
}
