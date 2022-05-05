import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct_app/models/game_search.dart';
import 'package:ct_app/models/image_to_guess.dart';
import 'package:ct_app/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  late final String uid;

  //collection references
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference match = FirebaseFirestore.instance.collection('matchmaking');
  final CollectionReference images = FirebaseFirestore.instance.collection('images');
  final CollectionReference games = FirebaseFirestore.instance.collection('games');
  final CollectionReference collectionMatch = FirebaseFirestore.instance.collection('match');

  String? id;
  DatabaseService({required this.uid});
  bool isGameAdded = false;
  static String? gameId;

  User? getUser() {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future updateUserData({String? username, String? game_id, String? role}) async {
    if (game_id != null) {
      return await userCollection.doc(uid).update({"game_id": game_id});
    }

    print("**********************************ROLE UPDATE**************************************************************");
    if (role != null) {
      print("role update");
      return await userCollection.doc(uid).update({"role": role});
    }

    return await userCollection.doc(uid).set({
      "username": username
    });
  }

  Future addUserToQueue(String? game, String username) async {
    final newGame = await match.where("game", isEqualTo: game,).where("username", isNotEqualTo: username).get();
    //.where("waiting", isEqualTo: false)

    // Game is waiting. Get the ID of the game
    final waitingGames = newGame.docs.map((e) => GameSearch.fromJson( e.data() as Map<String, dynamic>)).toList();

    if (waitingGames.isEmpty) {
      final newMatch = match.doc();
      await newMatch.set({"game": game, "username": username});
      collectionMatch.doc(username).set({"updateId": newMatch.id});
      updateUserData(game_id:  newMatch.id);
      updateUserData(role: "describer");
    }
    else {
      final storedId = await collectionMatch.doc(waitingGames[0].username).get();
      if(storedId.exists) {
        updateUserData(game_id: storedId.get("updateId"));
        updateUserData(role: "guesser");
        await addGame( storedId.get("updateId"));
      }
      await match.doc(newGame.docs[0].id).update({"game": game, "username":"${waitingGames[0].username}#${username}"
      });
    }
  }
  //listening for events on matchmaking
  Stream<QuerySnapshot<dynamic>> lookingForV2(String? gameName, String? username) {
    final game = match.where("game", isEqualTo: gameName,).where("username", isNotEqualTo: username).snapshots();
    return game;
  }

  //searching for randomly selected image by 'id'
  Future<ImageToGuess> randomlySelectImage() async {
    final imagesList = await images.get();
    int length = imagesList.size;
    final imageList2 = imagesList.docs.map((e) => ImageToGuess.fromJson(e.data() as Map<String, dynamic>)).toList();
    Random rnd = Random();
    return imageList2[rnd.nextInt(length)];
  }

  Future<ImageToGuess?> updateImageModelTo() async {
    //dynamic imageForModel;
    return await getUserDoc((curUserMatchId) {});
  }


  Future<void> addGame(String matchId) async {
    final existingMatch = games.where("match_id", isEqualTo: matchId).get();
    existingMatch.then((event) async {
      if (event.docs.isEmpty) {
        //matchID is now gamesDoc id
        final msgDoc =  games.doc(matchId);
        gameId = msgDoc.id;
        var  imageToGuess = await randomlySelectImage();
        await msgDoc.set({"match_id": matchId,"image_url":imageToGuess.url, "image_noun":imageToGuess.noun});//should be removed in refactorization
      }
    }, onError: (error) {
      print("addGame_addGame => $error");
    });
  }

  void setRole() {
    //update game field values
  }

  void removeUserFromQueue(List<DocumentReference> docRefs, String username, String? gameName) async {
    // Other user
    final gameMatch = await match.where("game", isEqualTo: gameName).get();
    final gameToDelete = gameMatch.docs.map((e) => GameSearch.fromJson( e.data() as Map<String, dynamic>)).toList();
    if(gameToDelete.isNotEmpty) {
      if (gameToDelete[0].username != username &&
          (gameToDelete[0].username?.contains("#") ?? false)) {
        match.doc(gameMatch.docs[0].id).delete();
      }
    }
  }
  //void setHasBeenGuessed() async{
    //getUserDoc(currentMatchId) {
      //games.doc(currentMatchId).update({hasBeenGuessed : "true"});
   // }
  //}

  Future<Map<String,dynamic>> getGameDoc() async {
    dynamic game = {};
    getUserDoc((curUserMatchId) async{
      var result =await games.doc(curUserMatchId).get();
      game = result.data();
    });
    return game;
  }


  //add to message collection
  void sendMessage(Message message){
    getUserDoc((curUserMatchId) {
      //this currently prints out into a new document
      games.doc(curUserMatchId).collection("messages").add(message.toJson());
    });
  }

  //gets all messages in collection under where document id is equal to cruUserMatchId
  Stream<List<Message>> fetchMessages(){
    StreamController<List<Message>> controller = StreamController.broadcast();
      getUserDoc((curUserMatchId)  {
      final gameSnapshot = games.where("match_id", isEqualTo: curUserMatchId).snapshots();
      gameSnapshot.listen((event)async {
        controller.sink.add([]);
        if(event.docs.isEmpty)return;
        final gameMessages =  event.docs[0];
        final docMessages = gameMessages.reference.collection("messages").orderBy("created_at", descending: false).snapshots();
        docMessages.listen((event) {

          final messages =  event.docs.map((e) => Message.fromJson(e.data())).toList();
          controller.add(messages);
          

          // event.docs.map((e)=>{
          //   print(e.data())
          // });
          // final messages = event.docs.map((e){print("message:${e.data()}");});
        });
      }, onError: (exception){
        controller.addError(exception);
      });
    });
      return controller.stream;
  }

  //gets current match id
  Future<ImageToGuess?> getUserDoc(Function(dynamic) onGetGameId) async{
    final uId = getUser()?.uid;
    CollectionReference userCol = FirebaseFirestore.instance.collection("users");
    if(uId != null) {
      final userId = await userCol.doc(uId).get();
      final result = ( userId.data() as Map<String, dynamic>)['game_id'];
      onGetGameId.call(result);

      var game = await games.doc(result).get();
      var gameInfo = game.data() as dynamic;
      //imageForModel = ImageToGuess(noun: gameInfo['image_noun'] ?? '', url: gameInfo['image_url'] ?? '');
      // image.map((e) => ImageToGuess.fromJson(e.data()));
      //imageForModel = gameInfo;

     //  print("currentMatchId Database():${gameInfo['match_id']}");
     //  print("document of currenMatchID Database() ${games.doc(curUserMatchId)}");
     //  print("Raw Data from game document matching currentMatchID -- Database(): ${game.data()}");
     //  print("Image being pulled>>>>>>>>>>>>Database(): $gameInfo");

      return ImageToGuess(noun: gameInfo['image_noun'] ?? '', url: gameInfo['image_url'] ?? '');
    }else{
      return null;
    }
  }

  void removeGame(String role){
    print (">>>>>>>>>>>>>>>>>>>>>>>REMOVE GAME<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    getUserDoc((currentMatchId) async {
      if(role == "describer"){
        await games.doc(currentMatchId).collection('messages').get().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs){
            ds.reference.delete();
          }
        });
      }

      await games.doc(currentMatchId).delete();
      //await collectionMatch.doc().delete();
      //last thing to delete is game id is user collection
    });
  }
}
