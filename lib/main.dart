import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movieapp/src/googleAuth.dart';
import 'package:movieapp/src/homepage.dart';
import 'package:movieapp/utils/colorplate.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Movie App',
      // theme: ThemeData(
      //   primarySwatch: C,
      // ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
            color: AppColor,
            alignment: Alignment.center,
            child: SizedBox(
              height: 36,
              width: 36,
              child: Text('Something went wrong!! check internet connection')
            ),
          );
            
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Greetings();
          }

          return Container(
            color: AppColor,
            alignment: Alignment.center,
            child: SizedBox(
              height: 36,
              width: 36,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColor),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Greetings extends StatefulWidget {
  @override
  _GreetingsState createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {


  checkIfUserLoggedIn() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool userLoggedIn = (_prefs.getString('id') != null ? true : false);

    if (userLoggedIn == true) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => AuthPage()));
    }
  }
  @override
    void initState() {
      super.initState();
      checkIfUserLoggedIn();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SizedBox(
              height: 36,
              width: 36,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColor),
              ),
            ),
        )
      ),
    );
  }
}
