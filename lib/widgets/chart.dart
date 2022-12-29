import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_basic_project2/widgets/chart_bar.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class MyChart extends StatelessWidget {
  final List<Transaction> latestTranaction;
  MyChart(this.latestTranaction);
  List<Map<String, Object>> get groupTransactionValue {
    return List.generate(7, (index) {
      var weekday = DateTime.now().subtract(Duration(days: index));
      var totalAmount = 0.0;
      for (int i = 0; i < latestTranaction.length; i++) {
        if (latestTranaction[i].date.day == weekday.day &&
            latestTranaction[i].date.month == weekday.month &&
            latestTranaction[i].date.year == weekday.year) {
          totalAmount += latestTranaction[i].price;
        }
      }
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalAmount
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupTransactionValue.fold(0.0, (previousValue, element) {
      return previousValue + (element['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupTransactionValue.map((data) {
            return Chartbar(
                data['day'].toString(),
                data['amount'] as double,
                totalSpending != 0
                    ? ((data['amount'] as double) / totalSpending)
                    : 0.0);
          }).toList(),
        ),
      ),
    );
  }
}
