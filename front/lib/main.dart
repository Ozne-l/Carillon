import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


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

  void openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    postImage(image, false);
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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
            Color(0xFF1b1e44),
            Color(0xFF2d3447),
          ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )
          ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 2,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(widget.title, style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: "Calibre-Semibold",
                  letterSpacing: 1.0)),
        ),
        body: Center(
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            margin: const EdgeInsets.only(
              bottom: 50,
              left: 10,
              right: 10
            ),
            child: display == true ?
                Container(
                  height: 515,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(const Radius.circular(5)),
                    image: DecorationImage(
                      image : MemoryImage(bytes),
                      fit: BoxFit.cover
                    )
                  ),
                ) :
                Text('Take or import a picture', style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Calibre-Semibold", letterSpacing: 1.0))
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     display == true ?
            //     Container(
            //       height: 515,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.only(
            //             topLeft: const Radius.circular(5),
            //             topRight: const Radius.circular(5)
            //         ),
            //         image: DecorationImage(
            //           image : MemoryImage(bytes),
            //           fit: BoxFit.cover
            //         )
            //       ),
            //     ) :
            //     Text('Take or import a picture', style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Calibre-Semibold", letterSpacing: 1.0))
            //     // res == true ? Image.memory(bytes) : Text('Take a picture')
            //   ],
            // ),
          ),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_arrow,
          animatedIconTheme: IconThemeData(size: 22),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          visible: true,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: Icon(Icons.photo_album, color: Color(0xFF1b1e44)),
              backgroundColor: Colors.white,
              onTap: openGallery,
              label: 'Gallery',
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 16.0),
              labelBackgroundColor: Color(0xFF1b1e44)),
            SpeedDialChild(
              child: Icon(Icons.add_a_photo, color: Color(0xFF1b1e44)),
              backgroundColor: Colors.white,
              onTap: openCamera,
              label: 'Camera',
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
              labelBackgroundColor: Color(0xFF1b1e44))
          ],
        )
      )
    );
  }
}
