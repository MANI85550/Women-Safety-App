import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:empowered_women/child/bottom_screens/review_page.dart';
import 'package:flutter/material.dart';

import 'bottom_screens/add_contacts.dart';
import 'bottom_screens/chat_page.dart';
import 'bottom_screens/child_home_page.dart';
import 'bottom_screens/profile_page.dart';

class BottomPage extends StatefulWidget {
  BottomPage({Key? key}) : super(key: key);

  @override
  State<BottomPage> createState() => _BottomPageState();
}
class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    AddContactsPage(),
    ChatPage(),
    Profile(),
    ReviewPage(),
  ];
  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.pink,
        height: 50.0,
        index: currentIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.contact_emergency_outlined, size: 30, color: Colors.white),
          Icon(Icons.chat_outlined, size: 30, color: Colors.white),
          Icon(Icons.person_2_outlined, size: 30, color: Colors.white),
          Icon(Icons.reviews_outlined, size: 30, color: Colors.white),
        ],
        onTap: onTapped,
      ),
    );
  }
}
