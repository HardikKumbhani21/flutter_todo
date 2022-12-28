import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'login_screen.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoding = false;

  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 3,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      image == null
                          ? SizedBox()
                          : Image.file(image!, fit: BoxFit.cover),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: IconButton(
                              onPressed: () async {
                                final ImagePicker _picker = ImagePicker();
                                final XFile? image = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                this.image = File(
                                  image!.path,
                                );
                                setState(() {});
                              },
                              icon: Icon(Icons.camera_alt_outlined))),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: fullName,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: password,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();
                    setState(() {
                      isLoding = true;
                    });
                    var result =
                        await createAccount(email.text, password.text, context);
                    setState(() {
                      isLoding = false;
                    });
                    if (result) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(
                              content: Text("account created"),
                            ),
                          )
                          .closed
                          .then((value) {
                        Get.to(LoginScreen);
                      });
                    }
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color(0xffFEDA77),
                              Color(0xffDD2A7B),
                              Color(0xff8134AF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(10)),
                    child: Material(
                      color: Colors.transparent,
                      child: Ink(
                        height: 55,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoding
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Future<bool> createAccount(
      String email, String password, BuildContext context) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("this uid: ${credential.user!.uid}");

      print("check");

      try {
        var uploadResponse = await FirebaseStorage.instance
            .ref()
            .child('profile')
            .child(
                'profile_${credential.user!.uid}_${DateTime.now()}.${image!.path.split(".")[image!.path.split(".").length - 1]}')
            .putFile(this.image!, SettableMetadata(contentType: "image/png"));
        String userProfilePictureUrl =
            await uploadResponse.ref.getDownloadURL();
        print("check done");
        print(userProfilePictureUrl);
        await FirebaseFirestore.instance
            .collection("userProfile")
            .doc(credential.user?.uid)
            .set({
          "user_profile": userProfilePictureUrl,
          "full_name": fullName.text
        });
      } catch (e) {
        print("Error: " + e.toString());
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The account already exists for that email.')));
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
