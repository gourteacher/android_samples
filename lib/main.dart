import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CST2335 Samples',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'week 4 - Shared Prefs'),
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
  var courseCode='';

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    courseCode = prefs.getString('Course') ?? '';
    var snackBar = SnackBar(
      content: Text('Course loaded $courseCode'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> savePrefs(BuildContext context) async {
    SharedPreferences.getInstance().then( (prefs) {
      prefs.setString('Course', 'CST2335');
      var snackBar = SnackBar(
        content: Text('Course saved'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {

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
                onPressed: () => savePrefs(context),
                child: Text ('Save',
                  style: TextStyle(fontSize: 30, color: Colors.blueAccent),
                ),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            ),
          ],
        ),
        //
      ),
    );
  }
}