import 'package:floor/floor.dart';
import 'ToDoItem.dart';

@dao
abstract class ToDoDAO {
  @Query('SELECT * FROM ToDoItem')
  Future<List<ToDoItem>> getAllItems();

  @Query('SELECT * FROM ToDoItem WHERE id = :id')
  Future<ToDoItem?> findItemById(int id);

  @insert
  Future<void> insertItem(ToDoItem item);

  @update
  Future<void> updateItem(ToDoItem item);

  @delete
  Future<void> deleteItem(ToDoItem item);
  
}