import 'package:flutter/material.dart';
import 'package:langdida_ui/src/components/app_bar.dart';
import 'package:langdida_ui/src/features/graph_view/animation.dart';

class GraphViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GraphViewPageState();
}

class _GraphViewPageState extends State<GraphViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newLangDiDaAppBar("relationships", context),
      body: AnimatedCanvas(),
    );
  }
}
