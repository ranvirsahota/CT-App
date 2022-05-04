import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_app/models/game_search.dart';
import 'package:ct_app/screens/authenticated_users/games/guess_the_image.dart';
import 'package:flutter/material.dart';
import 'package:ct_app/services/database.dart';

class Loading extends StatelessWidget {
  DatabaseService? databaseService;

  Loading(this.databaseService, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? username = databaseService?.getUser()?.email;
    int? suffix = username?.indexOf("@");
    username = username?.substring(0, suffix ?? 0);
    if(username != null) {
      databaseService?.addUserToQueue("Guess the image", username);
    }

    return  Scaffold(
      //listening for updates from firebase
      body: StreamBuilder<QuerySnapshot<dynamic> >(builder: (_, snapshot) {
        List<DocumentReference>? docRefs = [];
        //maps data to GameSearch model
        final mappedData = snapshot.data?.docs.map((e) {
          docRefs.add(e.reference);
          return GameSearch.fromJson(e.data());
        }).toList();

        //Checks for any existing data within snapshot
        if (snapshot.hasData &&mappedData!.isNotEmpty) {
          //want to ensure the user is paired before opening Guess the image screen
          if (mappedData[0].username != username) {
            //It waits for the entire widget to build, to prevent a crash
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (setting) => GuessTheWord(docRefs, username, databaseService,
                  timer: 120, games: mappedData)));
            });
          }
        }

        return Center(
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Waiting for another user",),
              SizedBox(height: 12,),
              CircularProgressIndicator(),
            ],
          ),
        );
       //game: value hard-coded for demo purposes
      }, stream: databaseService?.lookingForV2("Guess the image", username),)
    );
  }
}

