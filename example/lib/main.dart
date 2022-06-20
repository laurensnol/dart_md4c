import 'package:flutter/material.dart';

import 'package:dart_md4c_example/md4c_example.dart';
import 'package:dart_md4c_example/md4c_html_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("dart_md4c Example"),
            bottom: const TabBar(
              tabs: [
                Tab(text: "md4c"),
                Tab(text: "md4c-html"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Md4cExample(),
              Md4cHtmlExample(),
            ],
          ),
        ),
      ),
    );
  }
}
