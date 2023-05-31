import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/components/flash_message.dart';
import 'package:langdida_ui/src/features/book/card_expand_panel_list.dart';
import 'package:langdida_ui/src/utils/connections.dart';

class WordDialog extends StatefulWidget {
  final String _target;
  const WordDialog(this._target, {super.key});

  @override
  State<WordDialog> createState() => _WordDialogState();
}

class _WordDialogState extends State<WordDialog> {
  Widget _content = const ExpansionPanelList();

  void _getCard() async {
    GetStorage storage = GetStorage();
    String lang = storage.read("language") ?? "en";
    try {
      GetCardResponse response =
          await Connections.getCard(widget._target, lang);
      setState(() => _content = CardExpansionPanelList(response));
    } catch (e) {
      showFlashMessage(context, e.toString());
      setState(() => _content = CardExpansionPanelList(GetCardResponse(
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
      content: SingleChildScrollView(
        child: Column(
          children: [
            _content,
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
