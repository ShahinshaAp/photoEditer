// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/provider/crud_data.dart';
import 'package:flutter_crud/widgets/card_view.dart';
import 'package:flutter_crud/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

class TweetScreen extends StatefulWidget {
  const TweetScreen({super.key});

  @override
  State<TweetScreen> createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  TextEditingController tweetController = TextEditingController();
  String currentDate = '';
  @override
  void dispose() {
    super.dispose();
    tweetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cruddata = context.read<CrudData>();
    final auth = context.read<Auth>();
    DateTime now = DateTime.now();
    String formattedDate = '${now.year}-${now.month}-${now.day}';
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  auth.singOutUser();
                },
                child: const Text("SignOut"))
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
              child: CardView(
                elevation: true,
                child: Column(
                  children: [
                    CustomFormField(
                      controller: tweetController,
                      hintText: "write your Idea",
                      maxLines: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: const Text('Tweet'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                        ),
                        onPressed: () {
                          setState(() {
                            currentDate = formattedDate;
                            cruddata.addTweet(
                                tweetController.text, currentDate);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: StreamBuilder(
                stream: cruddata.tweets.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(documentSnapshot['text']),
                            subtitle: Text(documentSnapshot['date'].toString()),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        updateTweet(documentSnapshot);
                                      }),
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        cruddata.deleteTweet(
                                            documentSnapshot.id, context);
                                      }),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateTweet(
    DocumentSnapshot documentSnapshot,
  ) async {
    DateTime now = DateTime.now();
    String formattedDate = '${now.year}-${now.month}-${now.day}';
    if (documentSnapshot != null) {
      tweetController.text = documentSnapshot['text'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFormField(
                  controller: tweetController,
                  hintText: "write your Idea",
                  maxLines: 4,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String updateTweet = tweetController.text;
                    setState(() {
                      currentDate = formattedDate;
                      context.read<CrudData>().updateTweet(
                          updateTweet.toString(),
                          currentDate,
                          documentSnapshot);
                    });
                    tweetController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }
}
