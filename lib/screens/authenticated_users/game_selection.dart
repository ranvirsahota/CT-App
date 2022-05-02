import 'package:ct_app/screens/authenticated_users/games/guess_the_word.dart';
import 'package:ct_app/services/matchmaking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ct_app/screens/authenticated_users/loading.dart';
import 'package:ct_app/services/database.dart';

class GameSelection extends StatefulWidget {
  const GameSelection({Key? key}) : super(key: key);

  @override
  _GameSelectionState createState() => _GameSelectionState();
}

class _GameSelectionState extends State<GameSelection> {
  //final MatchMaking _match = MatchMaking();
  late DatabaseService database;
  //need to acquire uid for to create db instance
  _GameSelectionState(){
    final user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      database = DatabaseService(uid: user.uid);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Games Selection'),
    ),
    body: Column(
      children: [
        Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  title: Text('Guess the word'),
                  subtitle: Text('Find a team mate online and together, guess the word'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Play'),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) =>
                           Loading(database)));
                      },
                    ),
                  ],
                ),
              ],
            ),
        ),
      ],
    )
  );
}