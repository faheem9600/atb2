import 'package:flutter/material.dart';
import 'package:protoatb/BMIPage/utilsBMI/widget_utils.dart' show screenAwareSize;


class InputSummaryCard extends StatelessWidget {
  

  final int height;
  final int weight;

  const InputSummaryCard({Key key, this.weight, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(screenAwareSize(16.0, context)),
      child: SizedBox(
        height: screenAwareSize(35.0, context),
        child: Row(
          children: <Widget>[
            Expanded(child: _text("${weight}kg")),
            _divider(),
            Expanded(child: _text("${height}cm")),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 5.0,
      color: Color(0xFFF4aF1B) ,
    );
  }

  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xFF00154F),
        fontSize: 15.0,
      ),
      textAlign: TextAlign.center,
    );
  }
}