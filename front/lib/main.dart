import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


var serverIp = "10.41.167.119";
var serverPort = "5000";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool display;
  Uint8List bytes;

  @override
  void initState() {
    super.initState();
    display = false;
    bytes = null;
  }


  void openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      display = true;
      bytes = image.readAsBytesSync();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            display == true ?
            Container(
              height: 515,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image : MemoryImage(bytes),
                  fit: BoxFit.cover
                )
              ),
            ) :
            Text('Take a picture')
            // res == true ? Image.memory(bytes) : Text('Take a picture')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCamera,
        tooltip: 'Take picture',
        child: Icon(Icons.camera),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
