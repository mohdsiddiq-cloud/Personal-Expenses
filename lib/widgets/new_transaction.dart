import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  Function addNewData;
  NewTransaction(this.addNewData);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleControler = TextEditingController();

  final amountControler = TextEditingController();

  void addTemp() {
    final newTitle = titleControler.text;
    final newAmount = double.parse(amountControler.text);
    if (newTitle.isEmpty || newAmount <= 0) return;
    widget.addNewData(newTitle, newAmount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: titleControler,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            controller: amountControler,
            keyboardType: TextInputType.number,
            onSubmitted: ((_) => addTemp()),
          ),
          TextButton(
            onPressed: () {
              addTemp();
            },
            child: Text(
              'Add Transaction',
              style: const TextStyle(color: Colors.purple),
            ),
          ),
        ]),
      ),
    );
  }
}
