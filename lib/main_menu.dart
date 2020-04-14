import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:protoatb/BMIPage/ResultBMI/result_page.dart';
import 'BMIPage/bmi_page.dart';
import 'SenamanPage/senaman_page.dart';
import 'SleepPage/sleep_page.dart';
import 'PedometerPage/pedometer_page.dart';
import 'KaloriPage/kalori_page.dart';
import 'HeartRatePage/heart_rate_page.dart';

void main() => runApp(MaterialApp(home: BottomNavBar()));

class BottomNavBar extends StatefulWidget {

  
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int pageIndex = 0;

//Create all the pages
  final BMIPage _bmiscreen = BMIPage();
  final PedometerPage _pedo = PedometerPage();
  final SenamanPage _senaman = SenamanPage();
  final KaloriPage _kalori = KaloriPage();
  final HeartPage _heartsen = HeartPage();
  final SleepPage _masatidur = SleepPage();
  final ResultPage _result = ResultPage();

  Widget _showPage = new BMIPage();

  Widget _pageChooser(int page){
      switch(page){
      case 0:
      return _bmiscreen;
      break;
      case 1:
      return _pedo;
      break;
      case 2:
      return _senaman;
      break;
      case 3:
      return _kalori;
      break;
      case 4:
      return _heartsen;
      break;
      case 5:
      return _masatidur;
      break;
      default:
      return new Container(child: 
      new Center( child: 
      new Text(
        'No Page Found',
        style: new TextStyle( fontSize: 30),
      ))

      );

    }
  }


  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height:73.0,
          items: <Widget>[
            Icon(Icons.pie_chart , size: 25),
            Icon(Icons.directions_run, size: 25),
            Icon(Icons.fitness_center, size: 25),
            Icon(Icons.fastfood ,size: 25),
            Icon(Icons.perm_identity, size: 25),
            Icon(Icons.schedule, size: 25),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white38,
          backgroundColor: Colors.black45,
          animationCurve: Curves.easeInOutCubic,
          animationDuration: Duration(milliseconds: 600),
          onTap: (int tappedIndex) {
            setState(() {
              _showPage = _pageChooser(tappedIndex);
            });
          },
        ),
        body: Container(
          color: Colors.blueAccent,
          child: Center(
            child: _showPage,   
      
              
            ),
          ),
        );
  }
}