import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizApp',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text("Quiz App", style: TextStyle(fontSize: 30)),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Reason"),
              accountEmail: Text("rsondahal@gmail.com"),
              currentAccountPicture: Icon(Icons.person),
              currentAccountPictureSize: Size(30, 30),
            ),
            ListTile(
              leading: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            ),
          ],
        ),
      ),
    );
  }
}
