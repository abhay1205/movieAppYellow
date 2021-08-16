import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:emojis/emojis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movieapp/src/homepage.dart';
import 'package:movieapp/utils/colorplate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool pageInitialized = false;
  final googleSignIn = GoogleSignIn();
  final firebaseauth = FirebaseAuth.instance;
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  

  handleSignIn() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final res = await googleSignIn.signIn();

    final auth = await res.authentication;
    final credentials = GoogleAuthProvider.credential(
        accessToken: auth.accessToken, idToken: auth.idToken);
    final firebaseUser =
        (await firebaseauth.signInWithCredential(credentials)).user;
    if (firebaseUser != null) {
      _prefs.setString('id', firebaseUser.uid);
      _prefs.setString('name', firebaseUser.displayName);
      _prefs.setString('email', firebaseUser.email);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.yellow, content: Text('Something went wrong!!', style: GoogleFonts.lato(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w600)),));
    }
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: ht * 0.01,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              height: ht * 0.8,
              width: wt * 0.8,
              child: Card(
                color: Colors.white,
                shadowColor: Colors.grey,
                elevation: 5,
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(200),
                )),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: ht * 0.07,
                      ),
                      Container(
                          height: ht * 0.4,
                          width: wt * 0.7,
                          child: RotationTransition(
                              turns: AlwaysStoppedAnimation(338 / 360),
                              child: Image.asset(
                                'asset/img/movieicon.png',
                                fit: BoxFit.contain,
                              ))),
                      Text('The Movie App',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600, fontSize: 25)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 15, 20, 0),
                        child: Text(
                            'Add & Share your favourite movies with your friends and family',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.pacifico(
                                fontWeight: FontWeight.w300, fontSize: 15)),
                      ),
                      SizedBox(
                        height: ht * 0.07,
                      ),
                      GoogleAuthButton(
                        onPressed: () {
                          handleSignIn();
                        },
                        darkMode: false,
                        style: AuthButtonStyle(
                          iconType: AuthIconType.outlined,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text('developed with ${Emojis.redHeart} by @abhay1205')
          ],
        ),
      ),
    );
  }
}
