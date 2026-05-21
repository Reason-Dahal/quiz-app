import 'package:flutter/material.dart';
import 'package:quiz_app/ui/screens/auth/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      // appBar: AppBar(
      //   backgroundColor: Colors.purple[300],
      //   title: Text("Quiz App", style: TextStyle(fontSize: 30)),
      //   centerTitle: true,
      // ),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       UserAccountsDrawerHeader(
      //         accountName: Text("Reason"),
      //         accountEmail: Text("rsondahal@gmail.com"),
      //         currentAccountPicture: Icon(Icons.person),
      //         currentAccountPictureSize: Size(30, 30),
      //       ),
      //       ListTile(
      //         leading: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
      //       ),
      //     ],
      //   ),
      // ),
      body: LoginPage(),
    );
  }
}
