import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Icons;
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
  Map<String, dynamic> userInfo = {};

  void handleIndexChanged(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  print(userInfo);
                  print("userInfo=={}?: ${userInfo == {}}");
                },
              ),
            ),
            items: [
              if (userInfo.isEmpty)
                PaneItem(
                  icon: const Icon(FluentIcons.follow_user),
                  title: const Text('登录'),
                  body: LoginPage(
                    navigateToNewPage: handleIndexChanged,
                  ),
                ),
              if (userInfo.isEmpty)
                PaneItem(
                  icon: const Icon(FluentIcons.add_friend),
                  title: const Text('注册'),
                  body: RegisterPage(
                    navigateToNewPage: handleIndexChanged,
                  ),
                ),
              PaneItem(
                icon: const Icon(FluentIcons.account_management),
                title: const Text('个人信息设置'),
                body: LoginPage(
                  navigateToNewPage: handleIndexChanged,
                ),
              ),
            ],
          ),
          PaneItem(
            icon: const Icon(FluentIcons.admin_a_logo32),
            title: const Text('管理员界面'),
            body: const Row(),
            // enabled: false,
          ),
          PaneItem(
            icon: const Icon(Icons.usb),
            title: const Text('查看usb连接情况'),
            // infoBadge: const InfoBadge(source: Text('8')),
            body: PnPEntitiesPage(),
          ),
          PaneItem(
            icon: const Icon(Icons.article_outlined),
            title: const Text('查看系统一般日志'),
            // infoBadge: const InfoBadge(source: Text('8')),
            body: NormalLogPage(),
          ),
          PaneItem(
            icon: const Icon(Icons.security),
            title: const Text('查看系统安全日志'),
            body: SecurityLogPage(),
          ),
        ],
      ),
    );
  }
}
