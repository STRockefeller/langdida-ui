import 'package:flutter/material.dart';
import 'package:langdida_ui/src/components/association_dialog.dart';
import 'package:langdida_ui/src/components/word_dialog.dart';

class WordTabDialog extends StatefulWidget {
  final String _word;
  final String _lang;
  const WordTabDialog(this._word, this._lang, {super.key});

  @override
  State<StatefulWidget> createState() => _WordTabDialogState();
}

class _WordTabDialogState extends State<WordTabDialog> {
  Tabs _currentTab = Tabs.basicInfo;

  Widget _tabView() {
    switch (_currentTab) {
      case Tabs.associations:
        return WordAssociationDialog(widget._word, widget._lang);
      case Tabs.basicInfo:
        return WordDialog(widget._word, widget._lang);
      default:
        return const Text("unknown tab");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // tab buttons
        Container(
            width: 275,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 108, 108, 223)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        _currentTab = Tabs.basicInfo;
                      });
                    },
                    child: const Icon(Icons.abc)),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _currentTab = Tabs.associations;
                      });
                    },
                    child: const Icon(Icons.link)),
              ],
            )),
        // tab view
        _tabView()
      ],
    );
  }
}

enum Tabs { basicInfo, associations }
