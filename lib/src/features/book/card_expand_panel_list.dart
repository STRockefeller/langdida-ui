import 'package:flutter/material.dart';
import 'package:langdida_ui/src/api_models/card.dart';

class CardExpansionPanelList extends StatefulWidget {
  final GetCardResponse _resp;
  const CardExpansionPanelList(this._resp, {super.key});

  @override
  State<CardExpansionPanelList> createState() => _CardExpansionPanelListState();
}

class _CardExpansionPanelListState extends State<CardExpansionPanelList> {
  List<TextEditingController> explanationsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> sentencesControllers = [TextEditingController()];
  List<TextEditingController> labelsControllers = [TextEditingController()];
  final List<bool> _isExpandedList = List.filled(4, false);

  @override
  void initState() {
    super.initState();
    explanationsControllers = widget._resp.explanations
        .map((e) => TextEditingController(text: e))
        .toList();
    sentencesControllers = widget._resp.exampleSentences
        .map((e) => TextEditingController(text: e))
        .toList();
    labelsControllers =
        widget._resp.labels.map((e) => TextEditingController(text: e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      key: UniqueKey(),
      expansionCallback: (int panelIndex, bool isExpanded) {
        debugPrint("index: $panelIndex,isExpanded: $isExpanded");
        setState(() {
          _isExpandedList[panelIndex] = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text("Index")),
          body: Column(
            children: [
              Text("word: ${widget._resp.index.name}"),
              Text("language: ${widget._resp.index.language}"),
            ],
          ),
          isExpanded: _isExpandedList[0],
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(title: Text("labels"));
          },
          body: Column(
            children: labelsControllers
                .map((controller) => TextField(controller: controller))
                .toList(),
          ),
          isExpanded: _isExpandedList[1],
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(title: Text("explanations"));
          },
          body: Column(
            children: explanationsControllers
                .map((controller) => TextField(controller: controller))
                .toList(),
          ),
          isExpanded: _isExpandedList[2],
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(title: Text("example sentences"));
          },
          body: Column(
            children: sentencesControllers
                .map((controller) => TextField(controller: controller))
                .toList(),
          ),
          isExpanded: _isExpandedList[3],
        )
      ],
    );
  }
}
