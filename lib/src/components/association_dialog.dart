import 'package:flutter/material.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/utils/connections.dart';

class WordAssociationDialog extends StatefulWidget {
  final String _word;
  final String _lang;
  const WordAssociationDialog(this._word, this._lang, {super.key});

  @override
  State<WordAssociationDialog> createState() => _WordAssociationDialogState();
}

class _WordAssociationDialogState extends State<WordAssociationDialog> {
  Widget _content = const ExpansionPanelList();
  late CardAssociations _associations;
  final List<bool> _isExpandedList = List.filled(7, false);

  void _getCard() async {
    _associations =
        await Connections.getAssociations(widget._word, widget._lang);
    setState(() {
      _content = _associationsRepresentation(_associations);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCard();
  }

  Widget _associationsRepresentation(CardAssociations associations) {
    return ExpansionPanelList(
      key: UniqueKey(),
      expansionCallback: (int panelIndex, bool isExpanded) {
        setState(() {
          _isExpandedList[panelIndex] = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text("Index")),
          body: _cardIndexRepresentation(associations.index),
          isExpanded: _isExpandedList[0],
        ),
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text("Origin")),
          body: _cardIndexRepresentation(associations.origin),
          isExpanded: _isExpandedList[1],
        ),
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text("Derivatives")),
          body: Column(
            children: associations.derivatives
                .map((derivative) => _cardIndexRepresentation(derivative))
                .toList(),
          ),
          isExpanded: _isExpandedList[2],
        ),
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text("Synonyms")),
          body: Column(
            children: associations.synonyms
                .map((synonym) => _cardIndexRepresentation(synonym))
                .toList(),
          ),
          isExpanded: _isExpandedList[3],
        ),
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text("Antonyms")),
          body: Column(
            children: associations.antonyms
                .map((antonym) => _cardIndexRepresentation(antonym))
                .toList(),
          ),
          isExpanded: _isExpandedList[4],
        ),
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text("In Other Languages")),
          body: Column(
            children: associations.inOtherLanguages
                .map((item) => _cardIndexRepresentation(item))
                .toList(),
          ),
          isExpanded: _isExpandedList[5],
        ),
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text("Others")),
          body: Column(
            children: associations.others
                .map((item) => _cardIndexRepresentation(item))
                .toList(),
          ),
          isExpanded: _isExpandedList[6],
        ),
      ],
    );
  }

  Widget _cardIndexRepresentation(CardIndex index) {
    return Row(
      children: [
        Text(index.language, selectionColor: Colors.blueAccent),
        Text(index.name, selectionColor: Colors.redAccent),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          title: Text(widget._word),
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
        ),
      ],
    );
  }
}
