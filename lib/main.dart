import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'UGNTU case 3.1';
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter_in_sharedprefs = 0;
  int _counter_in_file = 0;

  @override
  void initState() {
    super.initState();
    _loadSPCounter();
  }

  //Loading counter value on start
  void _loadSPCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter_in_sharedprefs = (prefs.getInt('counter') ?? 0);
    });
  }

  //Incrementing counter after click
  void _incrementSPCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter_in_sharedprefs = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter_in_sharedprefs);
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
              onPressed: () {},
              child: Text('increase Counter in File'),
            ),
          ],
        ),
      ),
    );
  }
}
