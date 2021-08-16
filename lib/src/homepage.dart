import 'dart:io';

import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/Widgets/userDrawer.dart';
import 'package:movieapp/database/moviedb.dart';
import 'package:movieapp/models/movieModel.dart';
import 'package:movieapp/src/addPage.dart';
import 'package:movieapp/src/editPage.dart';
import 'package:movieapp/utils/colorplate.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Movie> movies;
  String userName, userEmail;

  @override
  void initState() {
    super.initState();
    getfreshList();
    getUserInfo();
  }

  getUserInfo() async {
    final _prefs = await SharedPreferences.getInstance();
    userName = _prefs.getString('name');
    userEmail = _prefs.getString('email');
    setState(() {});
  }

  Future<List<Movie>> getfreshList() async {
    setState(() {
      isLoading = true;
    });
    this.movies = await MovieDB.instance.readAll();
    setState(() {
      isLoading = false;
    });
    return this.movies;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: UserDrawer(
          userName: this.userName,
          email: this.userEmail,
        ),
        backgroundColor: Colors.grey[100],
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [appBar(), movieList(this.movies)],
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
              _scaffoldKey.currentState.openDrawer();
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(8),
                decoration:
                    BoxDecoration(color: AppColor, shape: BoxShape.circle),
                child: Icon(Icons.menu),
              ),
            ),
          ),
          Text('The Movie App',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  color: Colors.black)),
          GestureDetector(
            onTap: () {
              showAboutDialog(
                context: context,
                applicationVersion: 'app version: 1.0.1',
                applicationName: 'The Movie App',
                applicationIcon: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: RotationTransition(
                        turns: AlwaysStoppedAnimation(338 / 360),
                        child: Image.asset(
                          'asset/img/movieicon.png',
                          fit: BoxFit.contain,
                        ))),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: Container(
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(8),
                decoration:
                    BoxDecoration(color: AppColor, shape: BoxShape.circle),
                child: Icon(Icons.info_outline_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget movieList(List<Movie> movies) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: FutureBuilder(
          future: getfreshList(),
          builder: (context, snapshot) {
            
            if (snapshot.hasError) {
              return Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: SizedBox(
                    height: 36,
                    width: 36,
                    child: Text(
                        'Something went wrong!! check internet connection')),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(
                  child: Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: RotationTransition(
                              turns: AlwaysStoppedAnimation(338 / 360),
                              child: Image.asset(
                                'asset/img/movieicon.png',
                                fit: BoxFit.contain,
                              ))),
                      Text('No items added')
                    ],
                  ),
                );
              }
              if (snapshot.data.length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListItem(snapshot.data[index], index);
                  },
                );
              }
            }
            return Center(
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: RotationTransition(
                          turns: AlwaysStoppedAnimation(338 / 360),
                          child: Image.asset(
                            'asset/img/movieicon.png',
                            fit: BoxFit.contain,
                          ))),
                  Text('Loading List')
                ],
              ),
            );
          },
        )

        //   movies != null
        //       ? movies.length==0?
        //       :
        //       ListView.builder(
        //           itemCount: movies.length,
        //           itemBuilder: (context, index) {
        //             print(movies.length);
        //             return ListItem(movies[index], index);
        //           },
        //         )
        //       :
        );
  }

  Widget ListItem(Movie movieData, int index) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              image: DecorationImage(
                  image: FileImage(
                    File(movieData.filePath),
                  ),
                  fit: BoxFit.fitHeight)),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Container(
              // alignment: Alignment.center,
              // height: MediaQuery.of(context).size.height * 0.35,
              // width: MediaQuery.of(context).size.width * 0.7,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(15),
              //   color: movieData.filePath != null ? Colors.white : Colors.grey[300],
              // ),
              // child: movieData.filePath != null
              //     ? Image.asset(
              //         movieData.filePath,
              //         fit: BoxFit.fitHeight,
              //       )
              //     : Text('Error loading movie poster')),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                tileColor: Colors.white.withOpacity(0.9),
                leading: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Row(
                      children: [
                        Text(movieData.rating.toString(),
                            style: GoogleFonts.lato(fontSize: 25)),
                        Icon(
                          Icons.star_rate,
                          color: Colors.amber,
                          size: 40,
                        )
                      ],
                    )),
                title: Text(
                  movieData.movieName,
                  style: GoogleFonts.lato(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  movieData.dirName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(fontSize: 16),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    Share.shareFiles(['${movieData.filePath}'],
                        text:
                            'Movie Name: ${movieData.movieName}\nDirector Name: ${movieData.dirName}\nRating: ${movieData.rating} ${Emojis.star}\n\nshare by THE MOVIE APP\nclick the link to download https://github.com/abhay1205');
                  },
                  child: Container(
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(8),
                    decoration:
                        BoxDecoration(color: AppColor, shape: BoxShape.circle),
                    child: Icon(
                      Icons.share_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 12,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            child: Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: AppColor, shape: BoxShape.circle),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (BuildContext context) => EditForm(
                                  movie: movieData,
                                )))
                        .then((value) => getfreshList());
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 20,
                  )),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 12,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            child: Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: AppColor, shape: BoxShape.circle),
              child: GestureDetector(
                  onTap: () {
                    deleteMovie(movieData, index);
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                    size: 20,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  void deleteMovie(Movie movieData, int index) async {
    await MovieDB.instance.delete(movieData.id).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColor,
        content:
            Text('Deleted Movie', style: GoogleFonts.lato(color: Colors.black)),
      ));
      // getfreshList();
    });
  }

  Widget floatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context)
            .push(
                MaterialPageRoute(builder: (BuildContext context) => AddForm()))
            .then((value) => getfreshList());
      },
      backgroundColor: AppColor,
      label: Text('Add movie', style: GoogleFonts.lato(color: Colors.black)),
      icon: Icon(Icons.add, color: Colors.black),
    );
  }
}
