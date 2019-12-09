import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:device_info/device_info.dart';


var serverIp = "192.168.1.2";
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
      home: MyHomePage(title: 'Carillon Home Page'),
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
    bool rotate = false;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.manufacturer == "samsung")
      rotate = true;
    postImage(image, rotate);
  }

  void postImage(File image, bool rotate) async {
    var url = "http://" + serverIp + ":" + serverPort + "/users";
    String base64Image = base64Encode(image.readAsBytesSync());
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({
      "name": "image",
      "image": MultipartFile.fromString(base64Image),
      "rotate": rotate
    });
    var response = await dio.post(url, data: formData);
    if (response.toString().length > 0) {
      setState(() {
        bytes = base64Decode(response.toString());
        display = true;
      });
    }
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
