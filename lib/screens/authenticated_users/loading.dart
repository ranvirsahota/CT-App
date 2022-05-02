import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_app/screens/authenticated_users/games/guess_the_word.dart';
import 'package:flutter/material.dart';
import 'package:ct_app/services/matchmaking.dart';
import 'package:ct_app/services/database.dart';

class Loading extends StatelessWidget {
  DatabaseService? databaseService;

  Loading(this.databaseService, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //listenting to matchmaking table
      body: FutureBuilder<List<QueryDocumentSnapshot<dynamic>> >(builder: (_, snapshot) {



        print("DatabaseService => ${snapshot.data} _ ${snapshot.error}");
       if (snapshot.hasData) {
          return GuessTheWord(timer: 120);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }, future: databaseService?.lookingFor("Guess What it is"),)
    );
  }
}

