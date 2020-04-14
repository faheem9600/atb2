import 'package:flutter/material.dart';
import 'package:protoatb/BMIPage/Widget/card_title.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'weight_slider.dart';
import 'package:protoatb/BMIPage/utilsBMI/widget_utils.dart' show screenAwareSize;


class WeightCard extends StatefulWidget {
  final int initialWeight;
  final ValueChanged<int> onChanged;

  const WeightCard({Key key, this.initialWeight,this.onChanged}) : super(key: key);

  @override
  _WeightCardState createState() {
    return _WeightCardState();
  }
}

class _WeightCardState extends State<WeightCard> {
  int weight;

  @override
  void initState() {
    weight = widget.initialWeight ?? 70;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: screenAwareSize(5.0, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CardTitle(
                "Berat",
                subTitle: " (kg)",
              ),
              Padding(
                padding: EdgeInsets.only(top: screenAwareSize(5.0, context)),
                child: _drawWeightSlider(context),
              ),
            ]
          ),
        ),
      ),
    );
  }

  Widget _drawWeightSlider(BuildContext context) {
    return WeightBackground(
      child: LayoutBuilder(builder: (context, constraints) {
        return constraints.isTight
            ? Container()
            : WeightSlider(
                minValue: 30,
                maxValue: 110,
                value: weight,
                onChanged: _onChanged,
                width: constraints.maxWidth,
              );
      }),
    );
  }

  _onChanged(int val){
    weight = val;
    widget.onChanged(val);
  }
}

class WeightBackground extends StatelessWidget {
  final Widget child;

  const WeightBackground({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: screenAwareSize(70.0, context),
          decoration: BoxDecoration(
            color: Color(0xFF00154F),
            borderRadius:
                new BorderRadius.circular(screenAwareSize(55.0, context)),
          ),
          child: child,
        ),
        SvgPicture.asset(
          "images/weight_arrow.svg",
          height: screenAwareSize(10.0, context),
          width: screenAwareSize(20.0, context),
        )
      ],
    );
  }
}