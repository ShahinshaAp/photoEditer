// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrudData extends ChangeNotifier {
  final CollectionReference tweets =
      FirebaseFirestore.instance.collection('tweets');

  void addTweet(String tweet, String date) {
    tweets.add({"text": tweet, "date": date});
    notifyListeners();
  }
   void updateTweet ( String updateTweet, String date,  DocumentSnapshot? documentSnapshot){
    tweets.doc(documentSnapshot!.id).update({"text": updateTweet, "date": date});
    notifyListeners();
   }
    Future<void> deleteTweet(String productId, BuildContext context) async {
    await tweets.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted')));
  }
}
