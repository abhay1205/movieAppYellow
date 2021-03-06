import 'dart:io';
import 'package:emojis/emojis.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/database/moviedb.dart';
import 'package:movieapp/models/movieModel.dart';
import 'package:movieapp/utils/colorplate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:share/share.dart';

class AddForm extends StatefulWidget {
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  File _poster;
  final picker = ImagePicker();
  bool saved = false;
  TextEditingController _nameTEC;
  TextEditingController _dnameTEC;
  TextEditingController _rating;
  Movie savedMovie;
  bool keyboardOpen = false;

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _poster = File(pickedFile.path);
        print(_poster.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _poster = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final cardKey = GlobalKey<FlipCardState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          keyboardOpen = visible;
        });
      },
    );
    _nameTEC = TextEditingController(text: "");
    _dnameTEC = TextEditingController(text: "");
    _rating = TextEditingController(text: "3");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appBar(),
                // Container(
                //             height: ht*0.2,
                //             width: wt * 0.4,
                //             child: RotationTransition(
                //               turns: AlwaysStoppedAnimation(30/ 360),
                //               child: Image.asset('asset/img/movieicon.png', fit: BoxFit.contain,))),
                FlipCard(
                  key: cardKey,
                  flipOnTouch: false,
                  direction: FlipDirection.HORIZONTAL,
                  front: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(5),
                    height: ht * 0.8,
                    width: wt * 0.8,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 5,
                      child: Center(
                        child: form(ht, wt),
                      ),
                    ),
                  ),
                  back: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(5),
                    height: ht * 0.7,
                    width: wt * 0.8,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 5,
                      child: Center(
                        child: Column(
                          children: [
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
                                  'Your movie is saved!! share it with your friends and family',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 17)),
                            ),
                            SizedBox(height: ht*0.05,),
                            GestureDetector(
                              onTap: () {
                                Share.shareFiles(['${savedMovie.filePath}'],
                                    text:
                                        'Movie Name: ${savedMovie.movieName}\nDirector Name: ${savedMovie.dirName}\nRating: ${savedMovie.rating} ${Emojis.star}\n\nshare by THE MOVIE APP\nclick the link to download https://github.com/abhay1205');
                              },
                              child: Container(
                                margin: EdgeInsets.all(2),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: AppColor, shape: BoxShape.circle),
                                child: Icon(
                                  Icons.share_rounded,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: floatingActionButton(),
      ),
    );
  }

  Widget appBar() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.fromLTRB(10, 8, 6, 8),
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
          Text('The Movie App',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  color: Colors.black)),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            child: Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(Icons.share_rounded),
            ),
          ),
        ],
      ),
    );
  }

  openBottomSheet(double ht, double wt) {
    _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 0.5)],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        height: ht * 0.15,
        width: wt,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.image_rounded, size: 30),
                  onPressed: () {
                    getImageGallery();
                    Navigator.of(context).pop();
                  },
                ),
                Container(
                  child: Text('Gallery'),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                // Container(child: Text('Close'),)
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt_rounded, size: 30),
                  onPressed: () {
                    getImageCamera();
                    Navigator.of(context).pop();
                  },
                ),
                Container(
                  child: Text('Camera'),
                )
              ],
            ),
          ],
        ),
      );
    }, backgroundColor: AppColor);
  }

  Widget form(double ht, double wt) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: ht * 0.01,
          ),
          GestureDetector(
            onTap: () {
              openBottomSheet(ht, wt);
            },
            child: Container(
                alignment: Alignment.center,
                height: ht * 0.3,
                width: wt * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: _poster != null ? Colors.white : Colors.grey[300],
                ),
                child: _poster != null
                    ? Image.file(
                        _poster,
                        fit: BoxFit.fitHeight,
                      )
                    : Text('+ Tap to add poster of movie')),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 20, 0),
            child: Text(
                'Add & Share your favourite movies with your friends and family',
                textAlign: TextAlign.center,
                style: GoogleFonts.pacifico(
                    fontWeight: FontWeight.w300, fontSize: 15)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: _nameTEC,
                validator: (value) {
                  return value.length < 3 ? "Enter valid name" : null;
                },
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    labelText: 'Movie Name',
                    labelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor, width: 3)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor, width: 3)))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                controller: _dnameTEC,
                validator: (value) {
                  return value.length < 3 ? "Enter valid name" : null;
                },
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    labelText: 'Director Name',
                    labelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600]),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor, width: 3)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor, width: 3)))),
          ),
          SizedBox(
            height: ht * 0.01,
          ),
          rating()
        ],
      ),
    );
  }

  Widget rating() {
    return RatingBar.builder(
      initialRating: double.parse(_rating.text),
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        _rating.text = rating.toString();
      },
    );
  }

  Widget floatingActionButton() {
    return keyboardOpen
        ? SizedBox()
        : saved
            ? SizedBox()
            : FloatingActionButton.extended(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   content: Text('Saving movie....'),
                    //   backgroundColor: Colors.black,
                    // ));
                    final Directory dir =
                        await getApplicationDocumentsDirectory();
                    final String imagePath = dir.path;
                    final File newImage =
                        await _poster.copy('$imagePath/${DateTime.now()}.png');
                    final movie = Movie(
                        movieName: _nameTEC.text,
                        dirName: _dnameTEC.text,
                        filePath: newImage.path,
                        rating: double.parse(_rating.text),
                        created: DateTime.now());

                    await MovieDB.instance.create(movie).then((value) {
                      if (value != null) {
                        cardKey.currentState.toggleCard();
                        savedMovie = value;
                        saved = true;
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Something went wrong'),
                          backgroundColor: Colors.black,
                        ));
                      }
                    });
                  }
                },
                backgroundColor: Colors.white,
                label: Text('Save movie',
                    style: GoogleFonts.lato(color: Colors.black)),
                icon: Icon(Icons.add, color: Colors.black),
              );
  }
}
