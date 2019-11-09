import 'dart:async';
import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ambra',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        buttonTheme: ButtonThemeData(
          minWidth: 100,
          height: 100,
          hoverColor: Colors.red,
        ),
      ),
      home: MyHomePage(title: 'Ambra'),
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
  @override
  void initState() {
    super.initState();
  }

  Future<String> getFile() {
    final completer = new Completer<String>();
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';
    input.onChange.listen((e) async {
      final List files = input.files;
      final reader = new FileReader();
      reader.readAsDataUrl(files[0]);
      reader.onError.listen((error) => completer.completeError(error));
      await reader.onLoad.first;
      completer.complete(reader.result as String);
    });
    input.click();
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15),
              child: Image(
                image: AssetImage('assets/makerspace-logo.png'),
                height: 500.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(100.0),
                    side: BorderSide(color: Colors.red),
                  ),
                  textColor: Colors.white,
                  color: Colors.red,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Sfoglia",
                        style: TextStyle(fontFamily: 'Product Sans'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                RaisedButton(
                  onPressed: getFile,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(100.0),
                    side: BorderSide(color: Colors.red),
                  ),
                  textColor: Colors.white,
                  color: Colors.red,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.file_upload,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Carica",
                        style: TextStyle(fontFamily: 'Product Sans'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
