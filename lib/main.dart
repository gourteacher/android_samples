import 'package:flutter/material.dart';
import 'ToDoDAO.dart';
import 'ToDoItem.dart';
import 'database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Samples',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            secondary: Colors.green,
            primary: Colors.red),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Tablet and Phone Layout'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDoItem> todoList = <ToDoItem>[];
  late TextEditingController _inputController;
  late ToDoDAO dao;
  ToDoItem? selectedItem = null;
  var isChecked = false;

  @override //same as in java
  void initState() {
    super.initState(); //call the parent initState()
    _inputController = TextEditingController();

    $FloorToDoDatabase
        .databaseBuilder('todo_database.db')
        .build()
        .then((database) async {
      dao = database.toDoDAO;
      //get Items from database:
      var it = await dao.getAllItems();
      setState(() {
        todoList = it; //Future<> , asynchronous
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .inversePrimary,
            title: Text(widget.title)),
        body: reactiveLayout(),
        floatingActionButton: FloatingActionButton(
            onPressed: addItem,
            tooltip: 'Add Item',
            child: const Icon(Icons.add)));
  }

  void addItem() {
    if (_inputController.text.isNotEmpty) {
      setState(() {
        var newItem = ToDoItem(ToDoItem.ID++, _inputController.text);
        todoList.add(newItem);
        dao.insertItem(newItem);
        _inputController.clear();
      });
    } else {
      var snackBar = SnackBar(content: Text('Input field is required'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget reactiveLayout() {
    var size = MediaQuery
        .sizeOf(context);
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) //landscape// {
     {
      return Row(children: [
        Expanded(flex: 1, child: toDoList()),
        Expanded(flex: 2, child: detailsPage())
      ]);
  }

  else //portrait mode
  {
    if (selectedItem == null)
      return toDoList();
    else { //something is selected
      return detailsPage();
    }
  }
}

Widget detailsPage() {
  TextStyle mystyle = TextStyle(fontSize: 40.0);

  return Column(children: [

    if(selectedItem == null)
      Text("Please select something from the list", style: mystyle)
    else
      Text("You selected:" + selectedItem!.todoItem, style: mystyle)
    //
    ,
    ElevatedButton(child: Text("Ok"), onPressed: () {
      //update GUI:
      setState(() {
        selectedItem = null; //clear the selection
      });
    })

  ]);
}

Widget toDoList() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(children: [
          Flexible(child:
          TextField(controller: _inputController,
            decoration: InputDecoration(
              hintText: "Type a task here",
              labelText: "Add a task",
              border: OutlineInputBorder(),
            ),
          )),

          ElevatedButton(onPressed: () {
            //what was typed is:
            var input = _inputController.value.text;
            //generate UNIQUE ids
            var todoItem = ToDoItem(ToDoItem.ID++, input);
            dao.insertItem(todoItem);

            setState(() { //redraw the GUI

              todoList.add(todoItem); //add the item to the LIST

              _inputController.text = ""; //reset the textField
            });
          }, //Lambda, or anonymous function
            child: Text("Add ToDO"),)
        ],),
        Flexible(child:
        ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (ctx, rowNum) {
              return
                GestureDetector(
                    onTap: () {
                      setState(() { //redraw the GUI:
                        selectedItem = todoList[rowNum];
                      });
                    },
                    child:
                    Text("Item $rowNum = ${todoList[rowNum].todoItem }",
                      style: TextStyle(fontSize: 30.0),));
            }))
      ],
    ),
  );
} //end of reactiveLayout()

}
