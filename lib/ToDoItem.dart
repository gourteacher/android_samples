import 'package:floor/floor.dart';


@entity //this is an entity
class ToDoItem {
  static int ID = 1; //this is a static variable
  @PrimaryKey(autoGenerate: true)//this is a primary key
  final int? id;
  final String todoItem;

  ToDoItem(this.id, this.todoItem) {
    //If the id is greater than the static ID, then set the static ID to id + 1
    // Use this if Primary Key is not auto-generated
    // if ( id > ID) {
    //  ID = id + 1;
    //}
  }


  toString() {
    return "$id:$todoItem";
  }
}
