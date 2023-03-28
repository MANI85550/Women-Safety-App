import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empowered_women/Components/PrimaryButton.dart';
import 'package:empowered_women/Components/SecondaryButton.dart';
import 'package:empowered_women/Components/custom_textfield.dart';
import 'package:empowered_women/child/bottom_page.dart';
import 'package:empowered_women/child/register_child.dart';
import 'package:empowered_women/db/shared_pref.dart';
import 'package:empowered_women/parent/parent_home_screen.dart';
import 'package:empowered_women/parent/parent_register_screen.dart';
import 'package:empowered_women/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // const LoginScreen({super.key});
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  _onSubmit() async {
    _formKey.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: _formData['email'].toString(),
          password: _formData['password'].toString());
        if (userCredential.user !=null) {
          setState(() {
              isLoading = true;
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get()
              .then((value) {
                if (value['type'] == 'parent') {
                  print(value['type']);
                  MySharedPrefferences.saveUserType('parent');
                  goTo(context, ParentHomeScreen());
                }
                else{
                  MySharedPrefferences.saveUserType('child');

                  goTo(context, BottomPage());
                }
              });
        }
} on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = true;
      });
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    dialogBox(context, 'Wrong password provided for that user.');
    print('Wrong password provided for that user.');
  }
}
    print(_formData['email']);
    print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
            isLoading
              ? progressIndicator(context)
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "USER LOGIN",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: primaryColor
                              ),
                          ),
                          Image.asset(
                            'assets/women.png',
                            height: 150,
                            width: 150,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTextField(
                              hintText: 'Enter Email',
                              textInputAction: TextInputAction.next,
                              keyboardtype: TextInputType.emailAddress,
                              prefix: Icon(Icons.email),
                              onsave: (email) {
                                _formData['email'] = email ?? "";
                              },
                              validate: (email) {
                                if (email!.isEmpty || email.length<3 || !email.contains("@")){
                                  return "Enter correct Email";
                                }
                                else{
                                  return null;
                                }
                              },
                            ),
                            CustomTextField(
                              hintText: 'Enter password',
                              isPassword: isPasswordShown,
                              prefix: Icon(Icons.lock),
                              onsave: (password) {
                                _formData['password'] = password ?? "";
                              },
                              validate: (password) {
                                if (password!.isEmpty || password.length<7){
                                  return "Enter correct Password";
                                }
                                else{
                                  return null;
                                }
                              },
                              suffix: IconButton(onPressed: () {
                                setState(() {
                                  isPasswordShown=!isPasswordShown;
                                });
                              }, icon: isPasswordShown 
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility)),
                            ),
                            PrimaryButton(
                              title: 'LOGIN', 
                              onPressed: () {
                                if(_formKey.currentState!.validate()) {
                                _onSubmit();
                                }
                            }),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 18),
                          ),
                          SecondaryButton(title:'click here', onPressed: () {}),
                        ],
                      ),
                    ),
                    SecondaryButton(
                      title: 'Register as Child', 
                      onPressed: () {
                        goTo(context, RegisterChildScreen());
                    }),
                    SecondaryButton(
                      title: 'Register as Parent', 
                      onPressed: () {
                        goTo(context, RegisterParentScreen());
                    }),
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