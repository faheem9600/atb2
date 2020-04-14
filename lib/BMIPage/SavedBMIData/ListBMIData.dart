import 'dart:async';
import 'package:flutter/material.dart';
import 'package:protoatb/BMIPage/bmi_page.dart';
import 'package:protoatb/main_menu.dart';
import 'package:protoatb/BMIPage/ModelBMI/bmi_model.dart';
import 'package:protoatb/utilsDB/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ListDataBMI extends StatefulWidget{

  
  @override 
  State<StatefulWidget> createState() {

    return ListDataBMIState();
  }
}

class ListDataBMIState extends State<ListDataBMI> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<BMI> BMIList;
  int count = 0;


  @override 
  Widget build(BuildContext context){

    if (BMIList == null){
      BMIList = List<BMI>();
      updateListView();
    }

    return Scaffold(appBar: AppBar(
      title: Text('Data BMI'),
    ),
    
    body: getBMIListView(),

    floatingActionButton: FloatingActionButton(
      onPressed: (){
        debugPrint('FAB clicked');
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return BottomNavBar();
        }));
    },

    tooltip: 'Kira BMI',

    child: Icon(Icons.home),
    ),

    

    );
  }

  ListView getBMIListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){

         return Card(
           color: Colors.white,
           elevation: 2.0,
           child: ListTile(
             leading: CircleAvatar( 
               backgroundColor: Colors.blueAccent,
               child: Icon(Icons.keyboard_arrow_right),
             ),
             title: Text(this.BMIList[position].resultbmi, style: titleStyle,),

             subtitle: Text(this.BMIList[position].date),

             trailing: GestureDetector( 
               child: Icon(Icons.delete, color: Colors.grey),

             onTap: () {
               _delete(context, BMIList[position]);
             },
           ))
         ); 

      },);
    
  }

  void _delete(BuildContext context , BMI bmi) async {
    int result = await databaseHelper.deleteBmi(bmi.id);
    if (result !=0){
      _showSnackBar(context, 'Data berjaya dihapuskan');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message){

    final snackBar = SnackBar (content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView(){
   final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future <List<BMI>> bmiListFuture = databaseHelper.getBMIList();
      bmiListFuture.then((BMIList){

        setState(() {
          this.BMIList = BMIList;
          this.count = BMIList.length;
        });

      });
    });
  }
}