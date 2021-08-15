import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:emojis/emojis.dart'; 
import 'package:emojis/emoji.dart';
import 'package:movieapp/src/homepage.dart';
import 'package:movieapp/utils/colorplate.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
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
                        height: ht*0.4,
                        width: wt * 0.7,
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(338/ 360),
                          child: Image.asset('asset/img/movieicon.png', fit: BoxFit.contain,))),
                      Text('The Movie App', style: GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize:25)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 15, 20, 0),
                        child: Text('Add & Share your favourite movies with your friends and family',
                        textAlign: TextAlign.center, style: GoogleFonts.pacifico(
                          
                          fontWeight: FontWeight.w300, fontSize:15)),
                      ),
                      SizedBox(
                        height: ht * 0.07,
                      ),
                      GoogleAuthButton(
                        onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomePage()));},
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
