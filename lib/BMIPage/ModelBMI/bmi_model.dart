
class BMI {

  int _idbmi;
  String  _result;
  String _date;

  BMI(this._result, this._date);

  BMI.withId(this._idbmi, this._result, this._date);

  int get id => _idbmi;

  String get resultbmi => _result;

  String get date => _date;

  set result(String newResult){
    this._result = newResult;
    }

  set date(String newDate){

    this._date = newDate;
    

  }

  //Convert a BMI object into a Map object
  Map<String, dynamic> toMap(){

    var map = Map<String, dynamic>();
    if(id !=null){
        map['id'] = _idbmi;
    }

    map['result'] = _result;
    map['date'] = _date;

    return map;
  }

  // Extract a BMI object from Map object
  BMI.fromMapObject(Map<String, dynamic> map){

    this._idbmi = map['idbmi'];
    this._result = map['result'];
    this._date = map['date'];
  }
}