import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'DataRepository.dart';
import 'OtherPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes:  {
        '/Main'   :   (context) => MyHomePage(title:"Week 5 - Routes"),
        '/Second' :   (context) { return OtherPage(); } ,
        '/Third'  :   (context) { return OtherPage(); }
      },

      title: 'Android Samples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      //Notice  that we are not using the home parameter here
      //Instead, we are using the initialRoute parameter
      //home: const MyHomePage(title: 'Week 5 - Routes'),
      initialRoute: '/Main',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() { return _MyHomePageState(); }
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller; //late - Constructor in initState()
  var isChecked = false;

  @override //same as in java
  void initState() {
    super.initState(); //call the parent initState()
    _controller = TextEditingController(); //our late constructor
    DataRepository.loadData();//asynchronous, but certain to finish before going to second page
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); // clean up memory
  }

  Future<void> _launchUrl() async {
    var urlString = _controller.text;
    final Uri _url = Uri.parse(urlString);

    if (!await launchUrl(_url ) ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not launch $urlString"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, '/Second');
              }, //Lambda, or anonymous function
                  child: Text('Go to second page')),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(onPressed: () {
                Navigator.pushNamed(context, '/Third');
              }, //Lambda, or anonymous function
                  child: Text('Go to third page')),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Enter URL to launch",
                  border: OutlineInputBorder(),
                  label: Text('URL'),
                )
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                  onPressed: () => _launchUrl(),
                  child: Text('Go to URL')
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

