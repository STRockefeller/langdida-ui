import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/utils/connections.dart';

class CreateAssociationDialog extends StatefulWidget {
  final CardIndex _firstTarget;
  const CreateAssociationDialog(this._firstTarget, {super.key});

  @override
  State<StatefulWidget> createState() => _CreateAssociationDialogState();
}

class _CreateAssociationDialogState extends State<CreateAssociationDialog> {
  AssociationTypes _selectedAssociationType = AssociationTypes.others;
  List<CardIndex> _allCards = [];
  List<String> _autoCompleteItems = [];
  final CardIndex _secondTarget = CardIndex(name: "", language: "ENGLISH");
  final List<String> _associationTypes =
      AssociationTypes.values.map((e) => e.stringValue).toList();

  @override
  void initState() {
    _fetchCardIndexes();
    super.initState();
  }

  void _fetchCardIndexes() {
    Connections.listCardIndexes().then((indices) {
      setState(() {
        _allCards = indices;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          title: const Text("New Associations"),
          content: Column(
            children: [
              Text(widget._firstTarget.language),
              Text(widget._firstTarget.name),
              DropdownButton<String>(
                  value: _selectedAssociationType.stringValue,
                  items: _associationTypes
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  onChanged: (String? selected) {
                    if (selected == null) {
                      return;
                    }
                    setState(() {
                      _selectedAssociationType =
                          selected.associationType ?? AssociationTypes.others;
                    });
                  }),
              DropdownButton<String>(
                  value: _secondTarget.language,
                  items: const [
                    DropdownMenuItem(value: "ENGLISH", child: Text("English")),
                    DropdownMenuItem(value: "FRENCH", child: Text("Française")),
                    DropdownMenuItem(value: "JAPANESE", child: Text("日本語"))
                  ],
                  onChanged: (String? selected) {
                    if (selected == null) {
                      return;
                    }
                    setState(() {
                      _secondTarget.language = selected;
                      _autoCompleteItems = _allCards
                          .where((element) => element.language == selected)
                          .map((e) => e.name)
                          .toList();
                    });
                  }),
              Autocomplete(
                optionsBuilder: (TextEditingValue value) {
                  if (value.text == "") {
                    return const Iterable<String>.empty();
                  }
                  return _autoCompleteItems
                      .where((element) => element.contains(value.text));
                },
                onSelected: (String value) {
                  setState(() {
                    _secondTarget.name = value;
                  });
                },
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (kDebugMode) {
                    print(_secondTarget.name);
                  }
                  Connections.createCardAssociations(
                      CreateAssociationConditions(
                          cardIndex: widget._firstTarget,
                          relatedCardIndex: _secondTarget,
                          association: _selectedAssociationType));
                },
                child: const Text("Confirm")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"))
          ],
        )
      ],
    );
  }
}
