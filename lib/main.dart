import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ToDoItem.dart';

import 'AppLocalizations.dart';
import 'database.dart';
import 'ToDoDAO.dart';

void main() {
  runApp(const MyApp());
}

//StatelessWidget means no changes
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  State<StatefulWidget> createState() {
    return  _MyAppState(); //subclass of State<StatefulWidget>
  }

} //close of MyApp

class _MyAppState extends State<StatefulWidget>
{

  var _locale = const Locale("en", "EN"); //Language when start the applicatoin    ca for canada, us for us, GB for england

  void changeLanguage(Locale newLocale){
    setState(() {
      _locale = newLocale;  //set the new language for your app, setState redraws the GUI
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    //declare what languages are supported:
    return MaterialApp(
      supportedLocales:const [
        Locale('en' , 'CA'),
        Locale('de' , 'DE'),
        Locale('fr', "FR"),
        Locale('ru', 'RU')
      ], //list all languages you support in your app

      localizationsDelegates:  const[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale:_locale, //start with "en" "ca"
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//  _ means private
class _MyHomePageState extends State<MyHomePage> {
  /// This controls the "add" text field
  late TextEditingController _controller; //late - Constructor in initState()

  /// THis accesses the database for insert and delete
  late ToDoDAO myDAO; //initialized in initState()

  /// This holds what item was selected
  ToDoItem? selectedItem  = null;

  //add items from the database first:
  List<ToDoItem> items = [];


  /// This is where variables are initialized
  @override
  void initState() {
    super.initState(); //call the parent initState()
    _controller = TextEditingController(); //our late constructor
    //var database = await
    //open the database:
    $FloorToDoDatabase.databaseBuilder('todo_database.db').build()
        .then((database) async {

      myDAO = database.toDoDAO;
      //get Items from database:
      var it = await myDAO.getAllItems();

      setState(()  {
        items = it;
      });

    } ) ;
  }

  /// This is where variables are returned to memory
  @override
  void dispose()
  {
    super.dispose();
    _controller.dispose();    // clean up memory
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        actions: [
          OutlinedButton(child:Text("English") , onPressed: (){  MyApp.setLocale(context, Locale('en',"EN") );} ),
          OutlinedButton(child:Text("German")  , onPressed: (){  MyApp.setLocale(context, Locale('de',"DE") );} ),
          OutlinedButton(child:Text("French")  , onPressed: (){  MyApp.setLocale(context, Locale('fr',"FR") );} ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: reactiveLayout(),
    );
  }

  Widget  reactiveLayout() {
    var size = MediaQuery
        .of(context)
        .size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) //landscape
        {
      return Row(children: [
        Expanded(flex: 1 , child:ToDoList()),
        Expanded(flex: 2, child:DetailsPage())
      ]);
    }
    else //portrait mode
        {
      if(selectedItem == null)
        return ToDoList();
      else{ //something is selected
        return DetailsPage();
      }
    }
  }

  Widget DetailsPage() {
    TextStyle st = TextStyle(fontSize: 40.0);

    return Column(children:[

      if(selectedItem == null)
        Text(   AppLocalizations.of(context)!.translate( "SelectSomething")!, style:st)
      else
        Text("You selected:" + selectedItem!.todoItem, style:st) //! means non-null assertion
      ,
      ElevatedButton(child:Text("Ok"), onPressed: () {
        //update GUI:
        setState(() {
          selectedItem = null; //clear the selection
        });


      })

    ]);

  }

  Widget ToDoList(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(children: [
            Flexible(child:
            TextField(controller: _controller,
              decoration: InputDecoration(
                hintText:AppLocalizations.of(context)!.translate("TypeHere")!,
                labelText: AppLocalizations.of(context)!.translate("PutYourNameHere")!,
                border: OutlineInputBorder(),
              ),
            )),

            ElevatedButton(onPressed: () {
              //what was typed is:
              var input = _controller.value.text;
              //generate UNIQUE ids
              var todoItem = ToDoItem(ToDoItem.ID++, input);
              myDAO.insertItem(todoItem);

              setState(() { //redraw the GUI

                items.add(todoItem); //add the item to the LIST

                _controller.text = ""; //reset the textField
              });
            }, //Lambda, or anonymous function
              child: Text( AppLocalizations.of(context)!.translate('Add')! ),)
          ],),
          Flexible(child:
          ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, rowNum) {
                return
                  GestureDetector(
                      onTap:() {
                        setState(() {//redraw the GUI:
                          selectedItem = items[rowNum];
                        });

                      },
                      child:
                      Text("Item $rowNum = ${items[rowNum].todoItem }",
                        style: TextStyle(fontSize: 30.0),));
              }))
        ],
      ),
    );
  }//end of reactiveLayout()
}
