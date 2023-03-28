import 'package:empowered_women/Settings/About.dart';
import 'package:empowered_women/Settings/ChangePin.dart';
import 'package:empowered_women/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool switchValue = false;
  Future<int> checkPIN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int pin = (prefs.getInt('pin') ?? -1111);
    print('User $pin .');
    return pin;
  }

  @override
  void initState() {
    super.initState();
    // checkService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFCFE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              "Settings",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
            ),
          ),
          FutureBuilder(
              future: checkPIN(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangePinScreen(pin: 1111),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Center(
                        child: Icon(Icons.security_outlined,color: primaryColor,size: 35,),
                      ),
                    ),
                    title: Text(snapshot.data == -1111
                        ? "Create SOS pin"
                        : "Change SOS pin"),
                    subtitle:
                        Text("SOS PIN is required to switch OFF the SOS alert"),
                    trailing: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                          snapshot.data == -1111 ? primaryColor : Colors.white,
                      child: Center(
                        child: Card(
                            color: snapshot.data == -1111
                                ? Colors.orange
                                : Colors.white,
                            shape: CircleBorder(),
                            child: SizedBox(
                              height: 5,
                              width: 5,
                            )),
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Notifications",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(child: Divider())
            ],
          ),
          SwitchListTile(
            onChanged: (val) {
              setState(() {
                switchValue = val;
                // controllSafeShake(val);
              });
            },
            value: switchValue,
            secondary: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Center(
                    child: Icon(Icons.vibration_outlined,color: primaryColor,size: 35,)),
            ),
            title: Text("Safe Shake"),
            subtitle: Text("Switch ON to listen for device shake"),
          ),
          Divider(
            indent: 40,
            endIndent: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              "Safe Shake is the key feature for the app. It can be turned on to silently listens for the device shake. When the user feels uncomfortable or finds herself in a situation where sending SOS is the most viable descision. Then She can shake her phone rapidly to send SOS alert to specified contacts without opening the app.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Application",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(child: Divider())
            ],
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AboutUs()));
            },
            title: Text("About Us"),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Center(
                  child: Icon(Icons.info,color: primaryColor,size: 35,)),
            ),
          ),
          ListTile(
            title: Text("Share"),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Center(
                  child: Icon(Icons.share,color: primaryColor,size: 35,)),
            ),
          ),
        ],
      ),
    );
  }

  // Future<bool> checkService() async {
  //   bool running = await FlutterBackgroundService().isServiceRunning();
  //   setState(() {
  //     switchValue = running;
  //   });

  //   return running;
  // }

  // void controllSafeShake(bool val) async {
  //   if (val) {
  //     FlutterBackgroundService.initialize(onStart);
  //   } else {
  //     FlutterBackgroundService().sendData(
  //       {"action": "stopService"},
  //     );
  //   }
  // }
}
