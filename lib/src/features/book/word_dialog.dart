import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/components/flash_message.dart';
import 'package:langdida_ui/src/features/book/card_expand_panel_list.dart';
import 'package:langdida_ui/src/utils/connections.dart';
import 'package:intl/intl.dart';

class WordDialog extends StatefulWidget {
  final String _target;
  const WordDialog(this._target, {super.key});

  @override
  State<WordDialog> createState() => _WordDialogState();
}

class _WordDialogState extends State<WordDialog> {
  Widget _content = const ExpansionPanelList();
  late CardModel _card;
  TextButton _upsertButton =
      TextButton(onPressed: () {}, child: const Text("Loading"));

  void _getCard() async {
    GetStorage storage = GetStorage();
    String lang = storage.read("language") ?? "en";
    try {
      _card = await Connections.getCard(widget._target, lang);
      _upsertButton = TextButton(
        child: const Text("Edit Card"),
        onPressed: () {
          Connections.editCard(_card).then((value) {
            showFlashMessage(context, "Complete");
            Navigator.of(context).pop();
          }).catchError((error) {
            showFlashMessage(context, error.toString());
          });
        },
      );
    } catch (e) {
      showFlashMessage(context, e.toString());
      _upsertButton = TextButton(
        child: const Text("Create Card"),
        onPressed: () {
          _card.familiarity = 0;
          _card.reviewDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          Connections.createCard(_card).then((value) {
            showFlashMessage(context, "Complete");
            Navigator.of(context).pop();
          }).catchError((error) {
            showFlashMessage(context, error.toString());
          });
        },
      );
    } finally {
      setState(
          () => _content = CardExpansionPanelList(_card, (CardModel newResp) {
                _card = newResp;
              }));
    }
  }

  @override
  void initState() {
    super.initState();
    GetStorage storage = GetStorage();
    String lang = storage.read("language") ?? "en";
    _card = CardModel(
      index: CardIndex(name: widget._target, language: lang),
      labels: ["new label"],
      explanations: ["new explanation"],
      exampleSentences: ["new sentence"],
      familiarity: 0,
      reviewDate: "",
    );
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
        _upsertButton,
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
