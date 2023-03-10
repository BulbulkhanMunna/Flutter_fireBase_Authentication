import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro_demo/read%20data/get_user_name.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  //documents IDs
  List<String> docIDs = [];

  //get docIds
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users').where('age',isGreaterThan:28 )
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          user.email!,
          style: TextStyle(fontSize: 16),
        ),
        actions: [GestureDetector(
          onTap: (){
            FirebaseAuth.instance.signOut();
          },
          child: Icon(Icons.logout))],
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Signed in as : ' + user.email!,
              style: TextStyle(fontSize: 20),
            ),
        
            Expanded(
                child: FutureBuilder(
                    future: getDocId(),
                    builder: ((context, snapshot) {
                      return ListView.builder(
                          itemCount: docIDs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                title: GetUserName(documentId: docIDs[index]),
                                tileColor: Colors.grey[300],
                              ),
                            );
                          });
                    }))),
          ],
        ),
      )),
    );
  }
}
