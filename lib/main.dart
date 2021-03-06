import 'dart:math';
import 'dart:io';

import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

import 'package:expenses/components/chart.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/services.dart';
import './components/transaction_form.dart';
import './components/transaction_list.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.purple,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
              fontFamily: "OpenSans",
              fontSize: 18,
              fontWeight: FontWeight.bold,
          ),
        button: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: AppBarTheme(
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            color: Colors.white,
            fontFamily: "OpenSans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ),
      );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction>_transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransaction{
    return _transactions.where((tr){
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));

    }).toList();
  }

  _addTransaction (String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );
    
    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id){
    setState(() {
      _transactions.removeWhere((tr) => tr.id ==id );
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context, 
      builder: (_){
        return TransactionForm(_addTransaction);
      }
    );
  }

  Widget _getIconButton(IconData icon, Function() fn){
    return Platform.isIOS
      ? GestureDetector(onTap: fn, child: Icon(icon))
      : IconButton(onPressed: fn, icon: Icon(icon));
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final actions = <Widget>[
          if (isLandscape)
          _getIconButton(
            _showChart ? Icons.list : Icons.bar_chart_rounded,
            (){
              setState(() {
                _showChart = ! _showChart;
              });
            },
          ), 
          _getIconButton(
            Icons.add_box_outlined,
            () => _openTransactionFormModal(context),
          )
        ];

    final appBar = AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Despesas Pessoais",
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 10 * MediaQuery.of(context).textScaleFactor,
          ),
          ),
        actions: actions,
      );

    final avaliableHeight = MediaQuery.of(context).size.height-
      appBar.preferredSize.height-
      -MediaQuery.of(context).padding.top;
    final bodyPage = SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          //  if(isLandscape)
          //  Row(
          //    mainAxisAlignment: MainAxisAlignment.center,
          //    children: [
          //      Text("Exibir Gr??fico"),
          //      Switch(
          //        value: _showChart, 
          //        onChanged:(value){
          //          setState(() {
          //            _showChart = value;
          //          });
          //        }),
          //    ],
          //  ),
            if (_showChart || !isLandscape) 
              Container(
                height: avaliableHeight *(isLandscape ? 0.7 : 0.3),
                child: Chart(_recentTransaction),
              ),
            if (!_showChart || !isLandscape)
              Container(
                height: avaliableHeight *(isLandscape ? 1 : 0.3),
                child: TransactionList(_transactions, _removeTransaction),
              ),
          ],
        ),
      );

    return Platform.isIOS 

      ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Despesas Pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: bodyPage,
          )

      :Scaffold(
        appBar: appBar,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: bodyPage,
      );
  }
}
