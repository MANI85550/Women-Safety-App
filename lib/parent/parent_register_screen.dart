import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empowered_women/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Components/PrimaryButton.dart';
import '../Components/SecondaryButton.dart';
import '../Components/custom_textfield.dart';
import '../child/child_login_screen.dart';
import '../model/user_model.dart';

class RegisterParentScreen extends StatefulWidget {
  @override
  State<RegisterParentScreen> createState() => _RegisterParentScreenState();
}

class _RegisterParentScreenState extends State<RegisterParentScreen> {
  bool isPasswordShown = true;
  bool isRetypePasswordShown = true;

  final _formKey = GlobalKey<FormState>();

  final _formData = Map<String, Object>();

  bool isLoading = false;

  _onSubmit() async{
    _formKey.currentState!.save();
    if (_formData['password']!=_formData['rpassword']) {
      dialogBox(context, 'Password Does\'nt Match!');
    } 
    else{
      progressIndicator(context);
      try {
        setState(() {
        isLoading = true;
      });
     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _formData['gemail'].toString(), 
            password: _formData['password'].toString()
        );
        if (userCredential.user!=null) {
          final v=userCredential.user!.uid;
          DocumentReference<Map<String, dynamic>> db = FirebaseFirestore.instance.collection('users').doc(v);
              final user =UserModel(
                name: _formData['name'].toString(),
                phone: _formData['phone'].toString(),
                childEmail: _formData['cemail'].toString(),
                guardianEmail: _formData['gemail'].toString(),
                id: v ,
                type: 'parent',
              );
              final jsonData = user.toJson();
            await db.set(jsonData).whenComplete(() {
              goTo(context, LoginScreen());
              setState(() {
              isLoading = false;
              });
            });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
              isLoading = false;
              });
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
            dialogBox(context, 'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
            dialogBox(context, 'The account already exists for that email.');
          }
          } catch (e) {
            setState(() {
              isLoading = false;
              });
            print(e);
            dialogBox(context, e.toString());
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
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "REGISTER AS PARENT",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor
                                    ),
                                ),
                                Image.asset(
                                  'assets/parent.png',
                                  height: 150,
                                  width: 150,
                                ),
                              ],
                            ),
                          ),
                          Container(
                        height: MediaQuery.of(context).size.height * 0.66,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomTextField(
                                hintText: 'Enter Name',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.name,
                                prefix: Icon(Icons.person),
                                onsave: (name) {
                                  _formData['name'] = name ?? "";
                                },
                                validate: (email) {
                                  if (email!.isEmpty || email.length<3){
                                    return "Enter correct Name";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                              ),
                              CustomTextField(
                                hintText: 'Enter Phone Number',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.phone,
                                prefix: Icon(Icons.phone),
                                onsave: (phone) {
                                  _formData['phone'] = phone ?? "";
                                },
                                validate: (phone) {
                                  if (phone!.isEmpty || phone.length<10){
                                    return "Enter correct Phone Number";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                              ),
                              CustomTextField(
                                hintText: 'Enter Email',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.emailAddress,
                                prefix: Icon(Icons.email),
                                onsave: (gemail) {
                                  _formData['gemail'] = gemail ?? "";
                                },
                                validate: (gemail) {
                                  if (gemail!.isEmpty || gemail.length<3 || !gemail.contains("@")){
                                    return "Enter correct Email";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                              ),
                              CustomTextField(
                                hintText: 'Enter Child Email',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.emailAddress,
                                prefix: Icon(Icons.email),
                                onsave: (cemail) {
                                  _formData['cemail'] = cemail ?? "";
                                },
                                validate: (cemail) {
                                  if (cemail!.isEmpty || cemail.length<3 || !cemail.contains("@")){
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
                              CustomTextField(
                                hintText: 'Retype password',
                                isPassword: isRetypePasswordShown,
                                prefix: Icon(Icons.lock),
                                onsave: (rpassword) {
                                  _formData['rpassword'] = rpassword ?? "";
                                },
                                validate: (rpassword) {
                                  if (rpassword!.isEmpty || rpassword.length<7){
                                    return "Enter correct Password";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                suffix: IconButton(onPressed: () {
                                  setState(() {
                                    isRetypePasswordShown=!isRetypePasswordShown;
                                  });
                                }, icon: isRetypePasswordShown 
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility)),
                              ),
                              PrimaryButton(
                                title: 'REGISTER',
                                onPressed: () {
                                  if(_formKey.currentState!.validate()) {
                                  _onSubmit();
                                  }
                              }),
                            ],
                          ),
                        ),
                      ),
                      SecondaryButton(
                        title: 'Login as User', 
                        onPressed: () {
                          goTo(context, LoginScreen());
                      }),
                    
                          
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}