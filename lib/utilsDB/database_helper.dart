import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:protoatb/BMIPage/ModelBMI/bmi_model.dart';
import 'package:protoatb/BMIPage/ResultBMI/result_page.dart';

class DatabaseHelper {

	static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database;

  String bmiTable = 'bmi_table';
  String colId = 'idbmi';
  String colResult = 'resultbmi';
  String colDate = 'date';

	DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

	factory DatabaseHelper() {

		if (_databaseHelper == null) {
			_databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
		}
		return _databaseHelper;
	}

	Future<Database> get database async {

		if (_database == null) {
			_database = await initializeDatabase();
		}
		return _database;
	}

	Future<Database> initializeDatabase() async {
  // Get the directory path for both Android and iOS to store database
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path + 'bmi.db';

  // Open/Create database at given a path
  var bmiDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
  return bmiDatabase;
}


	void _createDb( Database db, int newVersion) async {

  await db.execute('CREATE TABLE $bmiTable( $colId INTEGER PRIMARY KEY AUTOINCREMENT, $colResult TEXT, $colDate TEXT)');
}

// Fetch Operation: Get all note objects from database
Future<List<Map<String, dynamic >>>getBmiMapList() async {

  Database db = await this.database;

  //var result = await db.rawQuery('SELECT * FROM $bmiTable order by $colId ASC');
  var result = await db.query(bmiTable, orderBy: '$colId ASC'); 
  return result;
}

//Insert Operation
Future<int> insertBMIdata(BMI bmi) async{
  Database db = await this.database;
  var result =await db.insert(bmiTable, bmi.toMap());
  return result;
}

// Update Operation
Future<int> updateBmi(BMI bmi) async {
  var db = await this.database;
  var result = await db.update(bmiTable, bmi.toMap(), where: '$colId = ?', whereArgs: [bmi.id]);
  return result;
}

// Delete Operation
Future<int> deleteBmi(int id) async {
  var db = await this.database;
  int result =await db.rawDelete('DELETE FROM $bmiTable WHERE $colId = $id');
  return result;
}
 //Get number of bmi object in database
 Future<int> getCountBmi() async{
   Database db = await this.database;
   List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $bmiTable');
   int result = Sqflite.firstIntValue(x);
   return result;
 }

 //Get Map List
 Future<List<BMI>> getBMIList() async {

		var BmiMapList = await getBmiMapList(); // Get 'Map List' from database
		int count = BmiMapList.length;         // Count the number of map entries in db table

		List<BMI> BmiList = List<BMI>();
		// For loop to create a 'Note List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			BmiList.add(BMI.fromMapObject(BmiMapList[i]));
		}

		return BmiList;
	}


}