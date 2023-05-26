import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:langdida_ui/src/components/app_bar.dart';

class BookPage extends StatelessWidget {
  BookPage({Key? key}) : super(key: key);
  final String bookContent = GetStorage().read("book") ?? "";
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newLangDiDaAppBar("Book", context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SelectableText(
                bookContent,
                style: const TextStyle(fontSize: 16.0),
                onSelectionChanged: (selection, cause) {
                  _controller.text = selection.textInside(bookContent);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(_controller.text),
                content:
                    // todo : show the vocabulary card
                    const Text("Some content related to the selected text."),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.open_in_new),
      ),
    );
  }
}