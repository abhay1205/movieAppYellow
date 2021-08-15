import 'dart:io';

import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/database/moviedb.dart';
import 'package:movieapp/models/movieModel.dart';
import 'package:movieapp/src/addPage.dart';
import 'package:movieapp/src/editPage.dart';
import 'package:movieapp/utils/colorplate.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Movie> movies;

  @override
  void initState() {
    super.initState();
    getfreshList();
  }

  @override
  void dispose() {
    MovieDB.instance.close();
    super.dispose();
  }

  Future getfreshList() async {
    setState(() {
      isLoading = true;
    });
    this.movies = await MovieDB.instance.readAll();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          Card(
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
                  BoxDecoration(color: AppColor, shape: BoxShape.circle),
              child: Icon(Icons.info_outline_rounded),
            ),
          ),
        ],
      ),
    );
  }

  // TODO: add futurebuilder for 3 cases
  Widget movieList(List<Movie> movies) {
    return Container(
      height: MediaQuery.of(context).size.height*0.8,
      child: movies != null
          ? ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical:10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                          image: DecorationImage(
                              image: FileImage(
                                File(movies[index].filePath),
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
                          //   color: movies[index].filePath != null ? Colors.white : Colors.grey[300],
                          // ),
                          // child: movies[index].filePath != null
                          //     ? Image.asset(
                          //         movies[index].filePath,
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
                                    Text(movies[index].rating.toString(),
                                        style: GoogleFonts.lato(fontSize: 25)),
                                    Icon(
                                      Icons.star_rate,
                                      color: Colors.amber,
                                      size: 40,
                                    )
                                  ],
                                )),
                            title: Text(
                              movies[index].movieName,
                              style: GoogleFonts.lato(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              movies[index].dirName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(fontSize: 16),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                Share.shareFiles(['${movies[index].filePath}'],
                                    text:
                                        'Movie Name: ${movies[index].movieName}\nDirector Name: ${movies[index].dirName}\nRating: ${movies[index].rating} ${Emojis.star}\n\nshare by THE MOVIE APP\nclick the link to download https://github.com/abhay1205');
                              },
                              child: Container(
                                margin: EdgeInsets.all(2),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: AppColor, shape: BoxShape.circle),
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
                          decoration: BoxDecoration(
                              color: AppColor, shape: BoxShape.circle),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) => EditForm(
                                          movie: movies[index],
                                        ))).then((value) => getfreshList());
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
                          decoration: BoxDecoration(
                              color: AppColor, shape: BoxShape.circle),
                          child: GestureDetector(
                              onTap: () async {
                                await MovieDB.instance
                                    .delete(movies[index].id)
                                    .then((value) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColor, content: Text('Deleting Movie'),));
                                      getfreshList();
                                    });
                               
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
              },
            )
          : Center(
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
            ),
    );
  }

  Widget floatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => AddForm())).then((value) =>  getfreshList());
       
      },
      backgroundColor: AppColor,
      label: Text('Add movie', style: GoogleFonts.lato(color: Colors.black)),
      icon: Icon(Icons.add, color: Colors.black),
    );
  }
}
