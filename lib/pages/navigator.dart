
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:sodium/pages/normal_log_page.dart';
import 'package:sodium/pages/pnp_entities_page.dart';
import 'package:sodium/pages/security_log_page.dart';


class navigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return navigatorState();
  }
}

class navigatorState extends State<navigator> {
  int index = 0;
  bool visable = true;
  PaneDisplayMode paneDisplayMode = PaneDisplayMode.top;
  Map<String, dynamic> userInfo = {};

  void handleIndexChanged(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        title: Text('NavigationView'),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (newIndex) => setState(() => index = newIndex),
        displayMode: paneDisplayMode,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('查看当前连接设备'),
            body: PnPEntitiesPage(),
          ),
          PaneItemSeparator(),
          PaneItem(
              icon: const Icon(FluentIcons.boards),
              title: const Text('查看系统一般日志'),
              // infoBadge: const InfoBadge(source: Text('8')),
              body: NormalLogPage(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.disable_updates),
            title: const Text('查看系统安全日志'),
            body: SecurityLogPage(),
          ),
        ],
        footerItems: [
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            body: Row(),
          ),
        ],
      ),
    );
  }
}
