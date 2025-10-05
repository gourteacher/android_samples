import 'package:flutter/material.dart';
import 'DataRepository.dart';

class OtherPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => OtherPageState();
}

class OtherPageState extends State<StatefulWidget>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Other Page")),
    body: Center(child:
        Column( mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(child:  Text("Welcome back " + DataRepository.login ),
            onPressed: () { Navigator.pop(context);   }),//return to previous
          ],
        )
      )
    );
  }

  @override
  void initState() {
    super.initState();
  }
}