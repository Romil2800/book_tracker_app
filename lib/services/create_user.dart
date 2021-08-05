import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createUser(String displayName, BuildContext context) async {
  final userCollection = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid;
  MUser user = MUser(displayName: displayName, uid: uid);

  userCollection.add(user.toMap());
}




// Future<void> createUser(String displayName, BuildContext context) async {
//   final userCollectionReference =
//       FirebaseFirestore.instance.collection('users');
//   FirebaseAuth auth = FirebaseAuth.instance;
//   String uid = auth.currentUser.uid;

//   Map<String, dynamic> user = {
//     'display_name': displayName,
//     'avatar_url': null,
//     'profession': 'nope',
//     'quote': 'Life is great',
//     'uid': uid,
//   };

//   return userCollectionReference.add(user);
// }
