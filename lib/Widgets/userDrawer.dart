import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movieapp/src/googleAuth.dart';
import 'package:movieapp/utils/colorplate.dart';

class UserDrawer extends StatelessWidget {
  String userName, email;
  UserDrawer({this.userName, this.email});
  final googleSignIn = GoogleSignIn();
  final firebaseauth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(left: 20, top:20),
        color: AppColor,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text('The Movie App',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600, fontSize: 25)),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            Text("Hi, "+ userName, style: GoogleFonts.lato(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
            Text(email, style: GoogleFonts.lato(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,10,0),
              child: Divider(
                color: Colors.black54,
                thickness: 2,
              ),
            ),
            ListTile(
              onTap: (){
                googleSignIn.signOut().then((value) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => AuthPage())));
              },
              title: Text('Log Out', style: GoogleFonts.lato(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w600)),
              leading: Icon(Icons.arrow_back_ios)
            ),
             Padding(
              padding: const EdgeInsets.fromLTRB(0,0,10,0),
              child: Divider(
                color: Colors.black38,
                thickness: 1,
              ),
            ),
            Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: RotationTransition(
                              turns: AlwaysStoppedAnimation(338 / 360),
                              child: Image.asset(
                                'asset/img/movieicon.png',
                                fit: BoxFit.contain,
                              ))),
          ],
        ),
      ),
    );
  }
}