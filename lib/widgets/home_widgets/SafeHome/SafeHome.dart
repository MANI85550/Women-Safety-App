import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:empowered_women/components/PrimaryButton.dart';
import 'package:empowered_women/db/db_services.dart';
import 'package:empowered_women/model/contactsm.dart';

class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  Position? _curentPosition;
  String? _curentAddress;
  String? latitude;
  String? longitude;
  LocationPermission? permission;
  // _getPermission() async => await [Permission.sms].request();
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

  @override
  void initState() {
    super.initState();
    // _getPermission();
    _getCurrentLocation();
  }

  showModelSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SEND YOUR CUURENT LOCATION IMMEDIATELY TO YOU EMERGENCY CONTACTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                if (_curentPosition != null) Text(_curentAddress!),
                PrimaryButton(
                    title: "GET LOCATION",
                    onPressed: () {
                      _getCurrentLocation();
                    }),
                SizedBox(height: 10),
                PrimaryButton(
                    title: "SEND ALERT",
                    onPressed: () async {
                      String recipients = "";
                      List<TContact> contactList =
                          await DatabaseHelper().getContactList();
                          await _getCurrentLocation().then((value) {
                              latitude = '${value.latitude}';
                              longitude = '${value.longitude}';
                            });
                      String messageBody =
                          "https://maps.google.com/?daddr=${latitude},${longitude}";
                      if (await _isPermissionGranted()) {
                        contactList.forEach((element) {
                          _sendSms("${element.number}",
                              "i am in trouble $messageBody");
                        });
                      } else {
                        Fluttertoast.showToast(msg: "something wrong");
                      }
                    }),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModelSafeHome(context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  ListTile(
                    title: Text("Send Location"),
                    subtitle: Text("Share Location"),
                  ),
                ],
              )),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/route.jpg')),
            ],
          ),
        ),
      ),
    );
  }
}
