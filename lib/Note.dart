class Note{
  int _id;        //_ is used bcoz its private variable only accesible to class and class members
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description]);           //constructor of the class
  Note.withId(this._id, this._title, this._date, this._priority, [this._description]);      //we want to call it with id so that we can edit further and whenever this method is called id should also be called     
//   without {} the argument would be mandatory
// with [] the argument would be an optional positional argument
//by creating getter and setter you hold complt control of what is going in and out of class

 //getters
int get id => _id;   
String get title => _title;
String get description => _description;
String get date => _date;
int get priority => _priority;

//setters
set title(String newTitle){
  if(newTitle.length <= 500){
    this._title = newTitle;
  }
}
set description(String newDescription){
  if(newDescription.length <= 500){
    this._description = newDescription;
  }
}
set date(String newDate){
  this._date = newDate;
}
set priority(int newPriority){
  if(newPriority >= 1 && newPriority <=2){
    this._priority = newPriority; 
  }
}

//used to save and retrive from database
//convert note object to map object
Map<String, dynamic> toMap(){     //dynamic means it can be anything like date string title or anything
    var map = Map<String, dynamic>();
    if(id != null){
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;
}

Note.fromMapObject(Map<String, dynamic> map){
  this._id = map['id'];
  this._title = map['title'];
  this._description = map['description'];
  this._priority = map['priority'];
  this._date = map['date'];
}
  
}