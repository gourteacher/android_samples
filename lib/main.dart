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
      title: 'Android Samples',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            secondary: Colors.green,
            primary: Colors.red),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Using a Database'),
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
  late ToDoDAO taskDAO;

  @override //same as in java
  void initState() {
    super.initState(); //call the parent initState()
    _inputController = TextEditingController();

    $FloorToDoDatabase
        .databaseBuilder('todo_database.db')
        .build()
        .then((database) async { //Note the use of async here
      taskDAO = database.toDoDAO;
      //get Items from database:
      var it = await taskDAO.getAllItems();
      setState(() {
        todoList = it;
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
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title)),
        body: listPage(),
        floatingActionButton: FloatingActionButton(
            onPressed: addTask,
            tooltip: 'Add a Task',
            child: const Icon(Icons.add)));
  }

  void addTask() {
    if (_inputController.text.isNotEmpty) {
      setState(() {
        // Use this if Primary Key is not auto-generated
        //ToDoItem(ToDoItem.ID++, _inputController.text);
        var newItem = ToDoItem(null, _inputController.text);
        todoList.add(newItem);
        taskDAO.insertItem(newItem);
        _inputController.clear();
      });
    } else {
      var snackBar = SnackBar(content: Text('Input field is required'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget listPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    hintText: 'Enter a ToDo Item',
                    border: OutlineInputBorder(),

                  ),
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, rowNum) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    //Text("${todoList[rowNum]} "),
                    Text(
                      "${todoList[rowNum].todoItem}",
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ]);
              }),
          ),
        ],
      ),
    );
  }
}
