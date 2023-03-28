import 'package:empowered_women/utils/quotes.dart';
import 'package:flutter/material.dart';

import '../../Settings/SettingsScreen.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  // const CustomAppBar({super.key});
  Function? onTap;
  int? quoteIndex;
  CustomAppBar({this.onTap, this.quoteIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            "We Admire",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          subtitle: Container(
            child: Text(
              sweetSayings[quoteIndex!],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.settings_outlined,color: Colors.black,size: 40,),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
        ),
      ),
    );
  }
}