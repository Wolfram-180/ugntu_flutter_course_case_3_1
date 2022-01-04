import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'UGNTU case 3.1';
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle, storage: CounterStorage()),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.storage})
      : super(key: key);

  final String title;
  final CounterStorage storage;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter_in_sharedprefs = 0;
  int _counter_in_file = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter_in_file = value;
        _loadSPCounter();
      });
    });
  }

  void _loadSPCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter_in_sharedprefs = (prefs.getInt('counter') ?? 0);
    });
  }

  void _incrementSPCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter_in_sharedprefs = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter_in_sharedprefs);
    });
  }

  Future<File> _incrementFileCounter() {
    setState(() {
      _counter_in_file++;
    });
    return widget.storage.writeCounter(_counter_in_file);
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
          children: [
            const Text(
              'Counter in Shared Preferances:',
            ),
            Text(
              '$_counter_in_sharedprefs',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: _incrementSPCounter,
              child: Text('increase Counter in Shared Preferances'),
            ),
            const Text(
              'Counter in File:',
            ),
            Text(
              '$_counter_in_file',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: _incrementFileCounter,
              child: Text('increase Counter in File'),
            ),
          ],
        ),
      ),
    );
  }
}
