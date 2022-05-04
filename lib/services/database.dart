import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_app/models/game_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  late final String uid;

  //collection reference

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference match = FirebaseFirestore.instance.collection('matchmaking');
  final CollectionReference images = FirebaseFirestore.instance.collection('images');
  final CollectionReference games = FirebaseFirestore.instance.collection('games');
  final CollectionReference collectionMatch = FirebaseFirestore.instance.collection('match');
  //look for way to get collection inside game
  String? id;

  DatabaseService({required this.uid});

  bool isGameAdded = false;

  static String? gameId;

  Future updateUserData({String? username, String? game_id}) async {
    if (game_id != null) {
      return await userCollection.doc(uid).update({"game_id": game_id});
    }
    return await userCollection.doc(uid).set({
      "username": username
    });
  }

  User? getUser() {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future addUserToQueue(String? game, String username) async {
    final newGame = await match.where("game", isEqualTo: game,)
    //.where("waiting", isEqualTo: false)
        .where("username", isNotEqualTo: username)
        .get();

    final waitingGames = newGame
        .docs.map((e)
    => GameSearch.fromJson( e.data() as Map<String, dynamic>)).toList(); // Game is waiting. Get the ID of the game

    if (waitingGames.isEmpty) {
      final newMatch = match.doc();
      await newMatch.set({"game": game, "username": username});
      collectionMatch.doc(username).set({"updateId": newMatch.id});
      updateUserData(game_id:  newMatch.id);
    }else{
      final storedId = await collectionMatch.doc(waitingGames[0]
          .username).get();
      if(storedId.exists) {
        updateUserData(game_id: storedId.get("updateId"));
        addGame( storedId.get("updateId"));
      }
      await match.doc(newGame.docs[0].id).update({"game": game, "username":"${waitingGames[0].username}#${username}"
      });
    }
  }
  //listening for events on matchmaking
  Stream<QuerySnapshot<dynamic>> lookingForV2(String? gameName,
      String? username) {
    final game = match.where("game", isEqualTo: gameName,).where("username", isNotEqualTo: username).snapshots();
    return game;
  }

  //searching for randomly selected image by 'id'
  Future getImage(int id) async {
    final imagesList = await images.where("id", isEqualTo: id).get();
    return imagesList.docs;
  }

  void addGame(String matchId) {
    final existingMatch = games.where("match_id", isEqualTo: matchId).get();
    existingMatch.then((event) async {
      if (event.docs.isEmpty) {
        final msgDoc =  games.doc();
        gameId = msgDoc.id;
        await msgDoc.set({"match_id": matchId});
      }
    }, onError: (error) {
      print("addGame_addGame => $error");
    });
  }


    void removeUserFromQueue(List<DocumentReference> docRefs,
        String username, String? gameName) async {
      // Other user
      final gameMatch = await match.where("game", isEqualTo: gameName).get();
      final gameToDelete = gameMatch
          .docs.map((e)
      => GameSearch.fromJson( e.data() as Map<String, dynamic>)).toList();
      if(gameToDelete.isNotEmpty) {
        if (gameToDelete[0].username != username &&
            (gameToDelete[0].username?.contains("#") ?? false)) {
          match.doc(gameMatch.docs[0].id).delete();
        }
      }
  }

  void removeGame(){
    if(gameId == null)return;
    //games.doc(gameId).delete();
  }

}