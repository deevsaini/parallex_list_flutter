import 'package:flutter/material.dart';
import 'package:flutter_parallex_effect/card_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: const Icon(Icons.menu),
        actions: const [Icon(Icons.search)],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Where Are You Going Next?",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          CardList()
        ],
      ),
    );
  }
}
