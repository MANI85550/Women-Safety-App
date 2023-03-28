import 'package:empowered_women/Splash/splash.dart';
import 'package:empowered_women/child/bottom_page.dart';
import 'package:empowered_women/db/shared_pref.dart';
import 'package:empowered_women/parent/parent_home_screen.dart';
import 'package:empowered_women/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPrefferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Empowered_Women',
      // scaffoldMessengerKey: navigatorkey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.firaSansTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.pink,
      ),
      home: FutureBuilder(
        future: MySharedPrefferences.getUserType(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == "") {
            return Splash();
          }
          if (snapshot.data == "child") {
            return BottomPage();
          }
          if (snapshot.data == "parent") {
            return ParentHomeScreen();
          }

          return progressIndicator(context);
        },
      ),
    );
  }
}

// class CheckAuth extends StatelessWidget {
//   // const CheckAuth({Key? key}) : super(key: key);

//   checkData() {
//     if (MySharedPrefference.getUserType() == 'parent') {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
