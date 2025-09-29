import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week 4 - Samples',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Week 4 - Alert Dialog'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void processOK(BuildContext context){
    Navigator.of(context).pop();
    var snackBar = SnackBar(content: Text('OK Clicked'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void processCancel(BuildContext context){
    Navigator.of(context).pop();
    var snackBar = SnackBar(content: Text('Cancel Clicked'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  AlertDialog displayDialog(BuildContext context) {

    return AlertDialog(
      title: const Text('AlertDialog'),
      content: const Text('Press OK or Cancel to continue ...'),
      actions: <Widget>[
        TextButton(
          onPressed: ()  {
            processCancel(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            processOK(context);
          },
          child: Container(
            color: Colors.blueAccent,
            padding: const EdgeInsets.all(14),
            child: const Text("OK"),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () =>
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => displayDialog(context)
                    ),
                child: Text ('Click Me',
                  style: TextStyle(fontSize: 30, color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
