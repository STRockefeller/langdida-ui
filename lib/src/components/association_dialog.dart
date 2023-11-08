import 'package:flutter/material.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/components/create_association_dialog.dart';
import 'package:langdida_ui/src/components/word_tab_dialog.dart';
import 'package:langdida_ui/src/utils/connections.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WordAssociationDialog extends StatefulWidget {
  final String _word;
  final String _lang;
  const WordAssociationDialog(this._word, this._lang, {super.key});

  @override
  State<WordAssociationDialog> createState() => _WordAssociationDialogState();
}

class _WordAssociationDialogState extends State<WordAssociationDialog> {
  final List<bool> _isExpandedList = List.generate(7, (index) => false);

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
        Text(
          index.language,
          style: const TextStyle(color: Colors.blueAccent),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(index.name, style: const TextStyle(color: Colors.redAccent)),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) =>
                      WordTabDialog(index.name, index.language));
            },
            icon: const Icon(Icons.link))
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
            child: FutureBuilder(
                future: Connections.getAssociations(widget._word, widget._lang),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done ||
                      snapshot.data == null) {
                    return LoadingAnimationWidget.discreteCircle(
                        color: Colors.blue, size: 20);
                  }
                  return _associationsRepresentation(snapshot.data!);
                })),
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("New"),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return CreateAssociationDialog(CardIndex(
                          name: widget._word, language: widget._lang));
                    });
              },
            ),
          ],
        ),
      ],
    );
  }
}
