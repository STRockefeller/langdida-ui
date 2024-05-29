import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:langdida_ui/src/components/app_bar.dart';
import 'package:langdida_ui/src/components/flash_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:langdida_ui/src/features/upload/open_book_dialog.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final GetStorage _storage = GetStorage();
  final TextEditingController _urlController = TextEditingController();
  String _fileContent = "";

  void _sendUrlToApi() async {
    String url = _urlController.text;
    dynamic responseBody;
    String content;
    http
        .get(Uri.parse(
            _storage.read("server_address") + "/io/import/url?url=$url"))
        .then((resp) => {
              responseBody = json.decode(resp.body),
              content = responseBody['content'] as String,
              showFlashMessage(context, content),
              _fileContent = content,
              setState(() {})
            })
        .catchError((e) {
      showFlashMessage(context, e.toString());
      return <void>{};
    });
  }

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      if (kIsWeb) {
        // On web platform, use bytes property to access file content
        _fileContent = utf8.decode(file.bytes!);
      } else {
        // On other platforms, use path property to access file content
        _fileContent = await File(file.path!).readAsString();
      }
      setState(() {});
    } else {
      // todo: fix the warning
      // ignore: use_build_context_synchronously
      showFlashMessage(context, "Canceled");
    }
  }

  void _openBook(String contents) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OpenBookDialog(_fileContent, key: UniqueKey());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newLangDiDaAppBar("Upload", context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 208, 185, 241),
              Color.fromARGB(255, 230, 214, 251)
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Enter URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _sendUrlToApi,
                    icon: const Icon(Icons.link),
                    label: const Text('New Lesson from URL'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E35B1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Colors.black,
                      elevation: 8,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _selectFile,
                    icon: const Icon(Icons.file_upload),
                    label: const Text('Select Local File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF43A047),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Colors.black,
                      elevation: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _fileContent.isEmpty
                        ? 'ContentsPreview'
                        : 'File content: $_fileContent',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _openBook(_fileContent),
                icon: const Icon(Icons.book),
                label: const Text('New Lesson from the File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD81B60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.black,
                  elevation: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
