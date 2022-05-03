import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_app/models/game_search.dart';
import 'package:ct_app/screens/authenticated_users/games/guess_the_word.dart';
import 'package:flutter/material.dart';
import 'package:ct_app/services/database.dart';

class Loading extends StatelessWidget {
  DatabaseService? databaseService;

  Loading(this.databaseService, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //reading collections of matchmaking
      body: FutureBuilder<List<QueryDocumentSnapshot<dynamic>> >(builder: (_, snapshot) {
        final mappedData = snapshot.data?.map((e) => GameSearch.fromJson(e.data()) ).toList();
        if (snapshot.hasData) {
          return GuessTheWord(timer: 120, games: mappedData!,);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
       //value hard-coded for demo purposes
      }, future: databaseService?.lookingFor("Guess the image"),)
    );
  }
}

