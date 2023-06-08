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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newLangDiDaAppBar("Cards", context),
      body: Center(
        child: Expanded(
          child: SfDataGrid(
            source: CardDataSource(cards),
            columnWidthMode: ColumnWidthMode.fill,
            columns: [
              _newGridColumn("Name"),
              _newGridColumn("Language"),
              _newGridColumn("Familiarity"),
              _newGridColumn("Review Date"),
            ],
            allowSorting: true,
          ),
        ),
      ),
    );
  }
}
