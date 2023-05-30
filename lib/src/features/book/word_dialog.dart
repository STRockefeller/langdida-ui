import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/components/flash_message.dart';
import 'package:langdida_ui/src/utils/connections.dart';

class WordDialog extends StatefulWidget {
  final String _target;
  const WordDialog(this._target, {super.key});

  @override
  State<WordDialog> createState() => _WordDialogState();
}

class _WordDialogState extends State<WordDialog> {
  Widget _content = const Text("now loading");

  /* ----------------------- controllers initialization ----------------------- */
  List<TextEditingController> explanationsControllers = [TextEditingController()];

  ExpansionPanelList _newExpansionPanelList(GetCardResponse resp){
    return ExpansionPanelList(
      children: [
        ExpansionPanel(headerBuilder: (BuildContext context, bool isExpanded){
          return const ListTile(
            title: Text("explanations")
          );
        }, body: TextField(
          controller: explanationsControllers[0],
        ))
      ],
    );
  }

  void _getCard() async {
    GetStorage _storage = GetStorage();
    String lang = _storage.read("language") ?? "en";
    try {
      GetCardResponse response = await Connections.getCard(
          widget._target, lang);
      setState(() => _content = Text(response.index.name));
    } catch (e) {
      showFlashMessage(context,e.toString());
      setState(() => _content = _newExpansionPanelList(GetCardResponse(
        index: CardIndex(name: widget._target, language: lang),
        labels: ["new label"],
        explanations: ["new explanation"],
        exampleSentences: ["new sentence"],
        familiarity: 0,
        reviewDate: "",
      )));
    }
  }

  @override
  void initState() {
    super.initState();
    _getCard();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget._target),
      insetPadding: EdgeInsets.zero,
      content: _content,
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
