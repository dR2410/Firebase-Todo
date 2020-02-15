import 'package:flutter/material.dart';
import '../Note.dart';
import '../database_helper.dart';
import 'package:intl/intl.dart';


class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState(){
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['HIGH','LOW'];
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;

  NoteDetailState(this.note, this.appBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    
  void updateTitle(){
    note.title = titleController.text;
  } 
   void descriptionTitle(){
    note.description = descriptionController.text;
  }  

  void moveToLastScreen(){
    Navigator.pop(context, true);
  }
  
   void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_)=> alertDialog);       // _ is used bcoz this is private one and based on that context it will fire up

  }
  
  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null){
      result = await helper.updateNote(note);
    }else{
      result = await helper.insertNote(note);
    }
    //based on the result we are either getting 0 or null
    if(result != 0){
      _showAlertDialog('Status','Note Saved Successfully');
    }else{
      _showAlertDialog('Status','Problem Saving Note');
    }
 }

 void _delete() async {
   moveToLastScreen();
   if(note.id == null){
     _showAlertDialog('Status', 'First add a note');
     return;
   }
    int result = await helper.deleteNote(note.id);
    if(result != 0){
      _showAlertDialog('Status','Note Deleted Successfully');
    }else{
      _showAlertDialog('Status','Error');
    }
 }

 //convert to int to save into database
 void updatePriorityAsInt(String value){
   switch(value){
     case 'HIGH':
      note.priority = 1;
      break;
     case 'LOW':
      note.priority = 2;
      break;  
   }
 }

//convert int to string to show user 
String getPriorityAsString(int value){
  String priority;
  switch (value) {
    case 1:
       priority = _priorities[0];
      break;
    case 2:
       priority = _priorities[1];
      break;  
  }
  return priority;
}

TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
        backgroundColor: Colors.cyan,
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: Colors.deepPurple,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                    //dropdown menu
                    child: new ListTile(
                      leading: const Icon(Icons.low_priority),
                      title: DropdownButton(
                          items: _priorities.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            );
                          }).toList(),
                          value: getPriorityAsString(note.priority),
                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              updatePriorityAsInt(valueSelectedByUser);
                            });
                          }),
                    ),
                  ),
                  // Second Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        updateTitle();
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        icon: Icon(Icons.title),
                      ),
                    ),
                  ),
                
                  // Third Element
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                    child: TextField(
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        descriptionTitle();
                      },
                      decoration: InputDecoration(
                        labelText: 'Details',
                        icon: Icon(Icons.details),
                      ),
                    ),
                  ),

                  // Fourth Element
                  Padding(
                    padding: EdgeInsets.all(35.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.blue,
                            color: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Save',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save button clicked");
                                _save();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: RaisedButton(
                            textColor: Colors.blue,
                            color: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _delete();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );

  }
}

