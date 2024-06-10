import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:provider/provider.dart';
import 'package:sodium/pages/user_info_page.dart';
import '../model/user.dart';
import 'admin_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'normal_log_page.dart';
import 'pnp_entities_page.dart';
import 'security_log_page.dart';

class navigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return navigatorState();
  }
}

class navigatorState extends State<navigator> {
  int index = 0;
  bool visable = true;
  PaneDisplayMode paneDisplayMode = PaneDisplayMode.open;
  late UserModel userModel;

  void handleIndexChanged(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    userModel = Provider.of<UserModel>(context, listen: true);
    return NavigationView(
      onOpenSearch: () {
        print("OPENSEARCH");
      },
      onDisplayModeChanged: (pan) {
        print("******************* $pan");
      },
      appBar: const NavigationAppBar(
        title: Text('NavigationView'),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (newIndex) => setState(() => index = newIndex),
        header: Visibility(
          visible: visable,
          child: IconButton(
            icon: Icon(FluentIcons.global_nav_button),
            onPressed: () {
              if (paneDisplayMode == PaneDisplayMode.open) {
                setState(() {
                  paneDisplayMode = PaneDisplayMode.compact;
                  visable = false;
                });
              } else if (paneDisplayMode == PaneDisplayMode.compact) {
                setState(() {
                  paneDisplayMode = PaneDisplayMode.open;
                  visable = false;
                });
              }
            },
          ),
        ),
        displayMode: paneDisplayMode,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('首页'),
            body: const Row(),
          ),
          PaneItemSeparator(),
          PaneItemExpander(
            icon: const Icon(FluentIcons.contact),
            title: const Text('我的账号'),
            body: Container(
              child: IconButton(
                icon: Icon(Icons.accessible_forward),
                onPressed: () {},
              ),
            ),
            items: [
              if (userModel.token == "")
                PaneItem(
                  icon: const Icon(FluentIcons.follow_user),
                  title: const Text('登录'),
                  body: LoginPage(
                    navigateToNewPage: handleIndexChanged,
                  ),
                ),
              if (userModel.token == "")
                PaneItem(
                  icon: const Icon(FluentIcons.add_friend),
                  title: const Text('注册'),
                  body: RegisterPage(
                    navigateToNewPage: handleIndexChanged,
                  ),
                ),
              if (userModel.token != "")
              PaneItem(
                icon: const Icon(FluentIcons.account_management),
                title: const Text('角色选择'),
                body: UserInfoPage(
                  navigateToNewPage: handleIndexChanged,
                ),
              ),
              if (userModel.token != "")
                PaneItem(
                  icon: const Icon(Icons.logout),
                  title: const Text('登出'),
                  body: Row(
                    children: [Text("正在处理登出")],
                  ),
                  onTap: () {
                    userModel.clearUser();
                    handleIndexChanged(1);
                  },
                ),
            ],
          ),
          PaneItem(
            icon: const Icon(Icons.article_outlined),
            title: const Text('查看系统一般日志'),
            // infoBadge: const InfoBadge(source: Text('8')),
            body: NormalLogPage(),
            enabled: userModel.currentRole?.name == "普通员工",
          ),
          PaneItem(
            icon: const Icon(Icons.security),
            title: const Text('查看系统安全日志'),
            body: SecurityLogPage(),
            enabled: userModel.currentRole?.name == "系统管理员",
          ),
          PaneItem(
            icon: const Icon(Icons.usb),
            title: const Text('查看usb连接情况'),
            // infoBadge: const InfoBadge(source: Text('8')),
            body: PnPEntitiesPage(),
            enabled: userModel.currentRole?.name == "审计人员",
          ),
          PaneItem(
              icon: const Icon(FluentIcons.admin_a_logo32),
              title: Text('管理员页面'),
              body: AdminPage(
                navigateToNewPage: handleIndexChanged,
              ),
              enabled: userModel.currentRole?.name == "系统管理员"),
        ],
      ),
    );
  }
}
