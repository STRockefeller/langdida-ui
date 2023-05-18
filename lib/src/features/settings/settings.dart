import 'package:flutter/material.dart';
import 'package:langdida_ui/src/components/app_bar.dart';
import 'package:langdida_ui/src/components/api_url_input.dart';
import 'package:get_storage/get_storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({required Key key}) : super(key: key);
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final GetStorage _storage = GetStorage();
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  double _textSizeValue = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newLangDiDaAppBar("Settings", context),
      body: ListView(
        children: [
          ServerAddressInput(key: UniqueKey()),
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Enable Dark Mode"),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          ListTile(
            title: const Text("Text Size"),
            trailing: Text(_textSizeValue.toStringAsFixed(1)),
            subtitle: Slider(
              min: 12.0,
              max: 24.0,
              value: _textSizeValue,
              onChanged: (double value) {
                setState(() {
                  _textSizeValue = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
