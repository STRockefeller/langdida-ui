import 'package:flutter/material.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/components/app_bar.dart';
import 'package:langdida_ui/src/components/flash_message.dart';
import 'package:langdida_ui/src/features/review/sync_fusion_data_source.dart';
import 'package:langdida_ui/src/utils/connections.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<CardModel> cards = [];

  @override
  void initState() {
    Connections.listCards().then((value) {
      cards = value;
      setState(() {});
    }).catchError((err) {
      showFlashMessage(context, err.toString());
    });
    super.initState();
  }

  GridColumn _newGridColumn(String id) {
    return GridColumn(
      columnName: id,
      label: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.centerRight,
        child: Text(id),
      ),
    );
  }

  FutureBuilder<String> _loadMoreBuilder(BuildContext ctx, LoadMoreRows rows) {
    Future<String> loadRows() async {
      await rows();
      return Future<String>.value('Completed');
    }

    return FutureBuilder<String>(
        initialData: 'loading',
        future: loadRows(),
        builder: (context, snapShot) {
          if (snapShot.data == 'loading') {
            return Container(
                height: 60.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: BorderDirectional(
                        top: BorderSide(
                            width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)))),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.deepPurple)));
          } else {
            return SizedBox.fromSize(size: Size.zero);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newLangDiDaAppBar("Cards", context),
      body: Center(
        child: Expanded(
          child: SfDataGrid(
            source: CardDataSource(cards),
            columnWidthMode: ColumnWidthMode.fitByColumnName,
            allowEditing: true,
            frozenColumnsCount: 1,
            loadMoreViewBuilder: _loadMoreBuilder,
            columns: [
              _newGridColumn("Name"),
              _newGridColumn("Language"),
              _newGridColumn("Familiarity"),
              _newGridColumn("Review Date"),
            ],
            allowSorting: true,
            selectionMode: SelectionMode.single,
          ),
        ),
      ),
    );
  }
}
