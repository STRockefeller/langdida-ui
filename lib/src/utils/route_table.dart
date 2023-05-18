import 'package:flutter/widgets.dart';
import 'package:langdida_ui/src/features/settings/settings.dart';

import '../features/entry_page/entry_page.dart';

enum RouteName {
  entry,
  settings,
}

final Map<RouteName, WidgetBuilder> routes = {
  RouteName.settings: (context) => SettingsPage(key: UniqueKey()),
  RouteName.entry: (context) => EntryPage(key: UniqueKey()),
};
