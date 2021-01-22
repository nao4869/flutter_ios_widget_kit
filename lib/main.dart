import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:ios_widget_sample/flutter_widget_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    WidgetKit.reloadAllTimelines();
    WidgetKit.reloadTimelines('test');

    final data = FlutterWidgetData('Hello From Flutter');
    final resultString = await WidgetKit.getItem(
      'testString',
      'group.ios.widget.kit',
    );
    final resultBool = await WidgetKit.getItem(
      'testBool',
      'group.ios.widget.kit',
    );
    final resultNumber = await WidgetKit.getItem(
      'testNumber',
      'group.ios.widget.kit',
    );
    final resultJsonString = await WidgetKit.getItem(
      'testJson',
      'group.ios.widget.kit',
    );

    var resultData;
    if (resultJsonString != null) {
      resultData = FlutterWidgetData.fromJson(jsonDecode(resultJsonString));
    }

    WidgetKit.setItem(
      'testString',
      'Hello World',
      'group.ios.widget.kit',
    );
    WidgetKit.setItem(
      'testBool',
      false,
      'group.ios.widget.kit',
    );
    WidgetKit.setItem(
      'testNumber',
      10,
      'group.ios.widget.kit',
    );
    WidgetKit.setItem(
      'testJson',
      jsonEncode(data),
      'group.ios.widget.kit',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('iOS Widget Showcase'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Enter a text',
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: TextField(controller: textController),
              ),
              RaisedButton(
                onPressed: () {
                  WidgetKit.setItem(
                    'widgetData',
                    jsonEncode(
                      FlutterWidgetData(textController.text),
                    ),
                    'group.ios.widget.kit',
                  );
                  WidgetKit.reloadAllTimelines();
                },
                child: Text('Update Widget'),
              ),
              RaisedButton(
                onPressed: () {
                  WidgetKit.removeItem(
                    'widgetData',
                    'group.ios.widget.kit',
                  );
                  WidgetKit.reloadAllTimelines();
                },
                child: Text('Remove Widget Data'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
