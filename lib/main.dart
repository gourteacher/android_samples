import 'dart:math';

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
      title: 'Android Samples',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Week 6 - ListView'),
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
  var wordsArray = <String>[ ];

  @override //same as in java
  void initState() {
    super.initState(); //call the parent initState()
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
        body: ListPage(),
        floatingActionButton:
        FloatingActionButton(onPressed: addItem,
            tooltip: 'Add Item',
            child: const Icon(Icons.add)
        )
    );
  }

  void addItem() {
    setState(() {
      wordsArray.add("Item " + " ${wordsArray.length+1}");
    });
  }

  Widget ListPage(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child:
          ListView.builder(
              itemCount:wordsArray.length,
              itemBuilder: (context, rowNum) { return
                Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:[
                      Text("${1+rowNum}: ${wordsArray[rowNum]} "),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            wordsArray[rowNum] = wordsArray[rowNum].toUpperCase();
                          });
                        },
                        child: const Icon(Icons.arrow_upward),
                      ),
                      GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            wordsArray[rowNum] = wordsArray[rowNum].toLowerCase();
                          });
                        },
                        child: const Icon(Icons.arrow_downward),
                      ),
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            wordsArray.removeAt(rowNum);
                          });
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ]
                );
              }
          ),
          ),
        ],
      ),
    );
  }
}
