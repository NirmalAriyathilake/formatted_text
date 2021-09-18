import 'package:flutter/material.dart';
import 'package:formatted_text/formatted_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formatted Text Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textEditingController = FormattedTextEditingController();

  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formatted Text Demo'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: FormattedText(
                _value,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: TextField(
                controller: textEditingController,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
