import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../chat_module/chat_screen.dart';
import '../../utils/constants.dart';


class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        // backgroundColor: Color.fromARGB(255, 250, 163, 192),
        title: Text("SELECT GUARDIAN"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('type', isEqualTo: 'parent')
            .where('childEmail',
                isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: progressIndicator(context));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final d = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: primaryColor,
                  child: ListTile(
                    onTap: () {
                      goTo(
                          context,
                          ChatScreen(
                              currentUserId:
                                  FirebaseAuth.instance.currentUser!.uid,
                              friendId: d.id,
                              friendName: d['name']));
                      // Navigator.push(context, MaterialPa)
                    },
                    title: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: primaryColor,
                        width: 2.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      child: Text(
                        d['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
