import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:langdida_ui/src/components/app_bar.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({required Key key}) : super(key: key);
  @override
  EntryPageState createState() => EntryPageState();
}

class EntryPageState extends State<EntryPage> {
  final GetStorage _storage = GetStorage();
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadServerAddress();
  }

  void _loadServerAddress() {
    String? serverAddress = _storage.read('server_address');
    if (serverAddress?.isNotEmpty == true) {
      // connect to the server
      _connectToServer(serverAddress!);
    }
  }

  void _connectToServer(String serverAddress) {
    // connect to the server
    setState(() {
      _isLoading = true;
    });

    // do the connection logic here

    setState(() {
      _isLoading = false;
    });

    _saveServerAddress(serverAddress);
  }

  void _saveServerAddress(String serverAddress) {
    _storage.write('server_address', serverAddress);
  }

  void _submit() {
    String serverAddress = _controller.text.trim();

    if (serverAddress.isNotEmpty) {
      // save the server address
      _saveServerAddress(serverAddress);

      // connect to the server
      _connectToServer(serverAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newLangDiDaAppBar("connect to server"),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Server IP Address',
                        hintText: 'Enter the server IP address',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Connect'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
