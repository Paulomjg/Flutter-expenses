import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChartBar extends StatelessWidget {

  final String label;
  final double value;
  final double percentagens;

  ChartBar({
    this.label = "",
    this.value = 0, 
    this.percentagens = 0,
  });



  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: <Widget> [
            Container(
              height: constraints.maxHeight*0.10,
              child: FittedBox(
                child: Text("R\$ ${value.toStringAsFixed(2)}")
              ),
            ),
            SizedBox(height: constraints.maxHeight*0.05),
            Container(
              height: constraints.maxHeight*0.6,
              width: 10,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget> [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: percentagens,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5)
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: constraints.maxHeight*0.05),
            Container(
              child: FittedBox(
                child: Text(label),
              ),
              height: constraints.maxHeight*0.10,
            ),
          ],
        
        );
      }
    );
  }
}