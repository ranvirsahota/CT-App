import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  late final String uid;
  //collection reference

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference match = FirebaseFirestore.instance.collection('matchmaking');
  final CollectionReference images = FirebaseFirestore.instance.collection('images');

  DatabaseService({required this.uid});

  Future updateUserData(String username) async {
    return await userCollection.doc(uid).set({
      "username":username,
    });
  }

  Future addUserToQueue(String username, Function onComplete) {
    return match.doc("username").set(username);
  }

  // This would query the collection for game parameter
  Future<List<QueryDocumentSnapshot<dynamic>> > lookingFor(String gameName) async {
    final game = await match.where("game", isEqualTo: gameName).get();

    return game.docs;
  }

  //searching for randomly selected image by 'id'
  Future getImage(int id) async {
    final imagesList = await images.where("id", isEqualTo: id).get();
    return imagesList.docs;
  }

  Future removeUserFromQueue() async {}
}