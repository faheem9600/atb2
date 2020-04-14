import 'package:flutter/material.dart';
import 'package:protoatb/BMIPage/utilsBMI/widget_utils.dart' show screenAwareSize;
import 'package:protoatb/BMIPage/utilsBMI/widget_utils.dart' show appBarHeight;
import 'package:protoatb/BMIPage/height/height_card.dart';
import 'package:protoatb/BMIPage/weight/weight_card.dart';
import 'package:protoatb/BMIPage/InputSummary/input_summary.dart';
import 'package:protoatb/BMIPage/bottomBar/pacmanSlider.dart';
import 'package:protoatb/BMIPage/bottomBar/TransitionDot.dart';
import 'package:protoatb/BMIPage/Route/fade_route.dart';
import 'package:protoatb/BMIPage/ResultBMI/result_page.dart';
import 'SavedBMIData/ListBMIData.dart';


class BMIPage extends StatefulWidget{
  @override
  State createState() {
    return new BMIPageState();
  }

}
class BMIPageState extends State<BMIPage> with TickerProviderStateMixin{

  int height = 170;
  int weight = 70;

  AnimationController submitAnimationController;
 
  
  @override
  void initState() {
    super.initState();
    submitAnimationController = AnimationController(vsync: this,duration: Duration(seconds: 2));
    submitAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToResultPage().then((_) => submitAnimationController.reset());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
         backgroundColor: Color(0XFF0244a1),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InputSummaryCard(
                
                weight: weight,
                height: height,
              ),
              Expanded(child: _buildCards(context)),
              _buildBottom(context), _buttonBMIList(context)
            ],
          ),
        ),
        TransitionDot(animation:submitAnimationController),
      ],
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenAwareSize(16.0, context),
        right: screenAwareSize(16.0, context),
        bottom: screenAwareSize(22.0, context),
        top: screenAwareSize(14.0, context),
      ),
      child: Container(
        height: screenAwareSize(52.0, context),
        child: PacmanSlider(
          onSubmit: onPacmanSubmit,
          submitAnimationController: submitAnimationController,
        ),
      ),
    );
  }

  Widget _buttonBMIList(BuildContext context) {

    return Padding(padding: EdgeInsets.only(top: 1.0, bottom: 15.0),
					    child: Row(
						    children: <Widget>[
						    	Expanded(
								    child: RaisedButton(
									    color: Colors.indigoAccent,
									    textColor: Colors.white,
									    child: Text(
										    'Data BMI',
										    textScaleFactor: 2.5,
									    ),
									    onPressed: () {
									    	setState(() {
									    	  debugPrint("button clicked");
                          _goToBMIData();
									    	  
									    	});
									    },
								    ),
							    )]));

  }



  Widget _buildCards(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: WeightCard(
                initialWeight: weight,
                onChanged: (val) => setState(() => weight = val),
              )),
            ],
          ),
        ),
        Expanded(
          child: HeightCard(
            height: height,
            onChanged: (val) => setState(() => height = val),
          ),
        )
      ],
    );
  }

  void onPacmanSubmit() {
    submitAnimationController.forward();
  }



  _goToResultPage() async {
    return Navigator.of(context).push(FadeRoute(
      builder: (context) => ResultPage(
        weight: weight,
        height: height,
        
      ),
    ));
  }

 _goToBMIData() async {
    return Navigator.of(context).push(FadeRoute(
      builder: (context) => ListDataBMI(
       
        
      ),
    ));
  }

 


  @override
  void dispose() {
    submitAnimationController.dispose();;
    super.dispose();
  }

  
 
}