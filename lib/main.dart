import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import './models/transaction.dart';
import 'package:flutter/foundation.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Transaction> Usertransactions = [
    Transaction('t1', 'shoes', 2000, DateTime.now()),
    Transaction('t2', 'shirt', 800, DateTime.now()),
  ];
  void addNewTransaction(String title, double amount) {
    final newtx =
        Transaction(DateTime.now().toString(), title, amount, DateTime.now());
    setState(() {
      Usertransactions.add(newtx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  bool check = false;
  List<Transaction> get _recentTransaction {
    return Usertransactions.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    AppBar appBr = AppBar(
      title: Text('Flutter App'),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.add)),
      ],
    );
    return Scaffold(
      appBar: appBr,
      body: !Usertransactions.isEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  if (isLandscape)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('show chart'),
                        Switch.adaptive(
                            value: check,
                            onChanged: (val) {
                              setState(() {
                                check = val;
                              });
                            })
                      ],
                    ),
                  if (isLandscape)
                    check
                        ? Container(
                            width: double.infinity,
                            child: Container(
                                height: (MediaQuery.of(context).size.height -
                                        appBr.preferredSize.height -
                                        (MediaQuery.of(context).padding.top)) *
                                    0.7,
                                child: MyChart(_recentTransaction)),
                          )
                        : Container(
                            height: (MediaQuery.of(context).size.height -
                                    appBr.preferredSize.height -
                                    (MediaQuery.of(context).padding.top)) *
                                0.7,
                            child: TransactionList(Usertransactions)),
                  if (!isLandscape)
                    Container(
                      width: double.infinity,
                      child: Container(
                          height: (MediaQuery.of(context).size.height -
                                  appBr.preferredSize.height -
                                  (MediaQuery.of(context).padding.top)) *
                              0.3,
                          child: MyChart(_recentTransaction)),
                    ),
                  if (!isLandscape)
                    Container(
                        height: (MediaQuery.of(context).size.height -
                                appBr.preferredSize.height -
                                (MediaQuery.of(context).padding.top)) *
                            0.7,
                        child: TransactionList(Usertransactions)),
                ],
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(child: Text('No Transaction Added Yet!')),
                SizedBox(
                  height: 50,
                ),
                Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/emptyimage.png',
                      fit: BoxFit.cover,
                    )),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                _startAddNewTransaction(context);
              },
              child: Icon(Icons.add),
            ),
    );
  }
}
