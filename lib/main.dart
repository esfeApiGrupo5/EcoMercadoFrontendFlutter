import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> _futureMessage;
  final String _apiUrl = 'https://blogapi-o9r4.onrender.com/';

  @override
  void initState() {
    super.initState();
    _futureMessage = fetchMessage();
  }

  Future<String> fetchMessage() async {
    final response = await http.get(Uri.parse(_apiUrl));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Consumption'),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _futureMessage,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Text(
                snapshot.data!,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              );
            } else {
              return const Text('No data found');
            }
          },
        ),
      ),
    );
  }
}