
import 'dart:math';

import 'package:background_sms/background_sms.dart';
import 'package:empowered_women/widgets/home_widgets/CustomCarouel.dart';
import 'package:empowered_women/widgets/home_widgets/SafeHome/SafeHome.dart';
import 'package:empowered_women/widgets/home_widgets/custom_appBar.dart';
import 'package:empowered_women/widgets/home_widgets/emergency.dart';
import 'package:empowered_women/widgets/live_safe.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';

import '../../db/db_services.dart';
import '../../model/contactsm.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // const HomeScreen({super.key});
  int qIndex = 0;
  String? latitude;
  String? longitude;
  LocationPermission? permission;
  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
   _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: 1);
    if (result == SmsStatus.sent) {
      print("Sent");
      Fluttertoast.showToast(msg: "send");
    } else {
      Fluttertoast.showToast(msg: "failed");
    }
  }
  
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled");
    } 
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location services are disabled");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        "Location Permission are permanently denied."
      );
    }
    return await Geolocator.getCurrentPosition();
  }


  getRandomQuote() {
    Random random = Random();
    setState(() {
      qIndex=random.nextInt(3);
    });
  }

  getAndSendSms() async {
    String recipients = "";
    List<TContact> contactList =await DatabaseHelper().getContactList();
    await _getCurrentLocation().then((value) {
                 latitude = '${value.latitude}';
                 longitude = '${value.longitude}';
    });
    String messageBody ="https://maps.google.com/?daddr=${latitude},${longitude}";
      if (await _isPermissionGranted()) {
        contactList.forEach((element) {
          _sendSms("${element.number}",
              "i am in trouble $messageBody");
        });
      } else {
        Fluttertoast.showToast(msg: "something wrong");
      }
  }

  @override
  void initState() {
    getRandomQuote();
    super.initState();
    _getPermission();
    _getCurrentLocation();
    //shake Feature ////
  ShakeDetector.autoStart(
      onPhoneShake: () {
        getAndSendSms();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shake!'),
          ),
        );
        // Do stuff on phone shake
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
             CustomAppBar(
                quoteIndex: qIndex,
                onTap: () {
                  getRandomQuote();
                }),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CustomCarouel(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Emergecy",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Emergency(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Explore LiveSafe",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    LiveSafe(),
                    SafeHome(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}