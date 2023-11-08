import 'package:flutter/material.dart';
import 'package:langdida_ui/src/components/app_bar.dart';
import 'package:langdida_ui/src/components/flash_message.dart';
import 'package:langdida_ui/src/features/graph_view/animation.dart';
import 'package:langdida_ui/src/utils/connections.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GraphViewPage extends StatelessWidget {
  const GraphViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newLangDiDaAppBar("relationships", context),
      body: FutureBuilder(
        future: Connections.listCardIndexes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return LoadingAnimationWidget.discreteCircle(
                color: Colors.blue, size: 20);
          }
          if (snapshot.hasError || snapshot.data == null) {
            showFlashMessage(context, "Error on loading card indices");
            return LoadingAnimationWidget.discreteCircle(
                color: Colors.blue, size: 20);
          }
          return AnimatedCanvas(cards: snapshot.data!);
        },
      ),
    );
  }
}
