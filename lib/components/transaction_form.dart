
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adaptative_textfield.dart';

class TransactionForm extends StatefulWidget {

  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm(){
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0;
    final date = _selectedDate;

    if(title.isEmpty || value <=0 ){return;}
        
    widget.onSubmit(title, value, date);
  }

  _showdataPicker(){
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if(pickedDate == null){
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  right: 10,
                  left: 10 ,
                  bottom: 10 + MediaQuery.of(context).viewInsets.bottom, 
                ),
                child: Column(
                  children:<Widget>[
                    AdaptativeTextField(
                      label: "Título ",
                      onSubmited: (_) => _submitForm(),
                      controller: _titleController,
                    ),
                    //TextField(
                    //  controller: _titleController,
                    //  onSubmitted: (_) => _submitForm(),
                    //  decoration: InputDecoration(
                    //    labelText: "Título "
                    //  ),
                    //),
                    AdaptativeTextField(
                      controller: _valueController,
                      onSubmited: (_) => _submitForm(),
                      label: "Valor R\$",
                      keyboardType:TextInputType.numberWithOptions(decimal: true),
                      ),
                    //TextField(
                    //  controller: _valueController,
                    //  keyboardType: TextInputType.numberWithOptions(decimal: true),
                    //  onSubmitted: (_) => _submitForm(),
                    //  decoration: InputDecoration(
                    //    labelText: "Valor R\$"
                    //  ),
                    //),
                    Container(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Data: ${DateFormat("d/MM/y").format(_selectedDate)}"
                          ),
                          ElevatedButton(
                            child: Text("Selecionar Outra Data",
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(primary:Colors.white),
                            onPressed: _showdataPicker,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ElevatedButton(
                            child: Text("Nova Transação", 
                              style: TextStyle(
                                color: Theme.of(context).textTheme.button!.color,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(primary:Theme.of(context).primaryColor),
                            onPressed: _submitForm,  
                          ),
                        ),
                      ],
                    ),
                  ]
                ),
              ),
            ),
    );
  }
}