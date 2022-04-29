import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  late final String uid;
  //collection reference

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  DatabaseService({required this.uid});

  Future updateUserData(String username) async {
    return await userCollection.doc(uid).set({
      "username":username,
    });
  }

  Future addUserToQueue() async {
  }

  Future removeUserFromQueue() async {
  }
}