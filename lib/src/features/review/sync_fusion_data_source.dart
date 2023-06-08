import 'package:flutter/material.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CardDataSource extends DataGridSource {
  List<DataGridRow> _cards = [];

  @override
  List<DataGridRow> get rows => _cards;

  CardDataSource(List<CardModel> cards) {
    _cards = cards
        .map((card) => DataGridRow(
              cells: [
                DataGridCell<String>(
                    columnName: "Name", value: card.index.name),
                DataGridCell<String>(
                    columnName: "Language", value: card.index.language),
                DataGridCell<int>(
                    columnName: "Familiarity", value: card.familiarity),
                DataGridCell<String>(
                    columnName: "Review Date", value: card.reviewDate),
              ],
            ))
        .toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row
          .getCells()
          .map<Widget>((e) => Container(
                padding: const EdgeInsets.all(16),
                child: Text(e.value.toString()),
              ))
          .toList(),
    );
  }
}
