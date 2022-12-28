import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/view/create_account.dart';
import 'package:flutter_todo/view/phone_number_screen.dart';
import 'package:flutter_todo/view/product_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
        'profile'
      ],
    );
    super.initState();
  }

  Future<void> _handleSignIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        GetStorage().write('uid', user!.uid);

        await FirebaseFirestore.instance
            .collection("userProfile")
            .doc(user?.uid)
            .set({
          "user_profile": googleSignInAccount.photoUrl,
          "full_name": googleSignInAccount.displayName,
        });

        // goto home page
        Get.offAll(ProductScreen());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }
  }

  bool isLoding = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.network(
                      "https://i0.wp.com/www.dafontfree.io/wp-content/uploads/2020/12/instagram-new.png?resize=1100%2C750&ssl=1",
                      height: 120,
                      width: 360),
                ),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(colors: [
                      Color(0xffFEDA77),
                      Color(0xffDD2A7B),
                      Color(0xff8134AF),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                        .createShader(bounds);
                  },
                  child: Text(
                    "Login User",
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 3,
                        shadows: [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0, 2),
                            blurRadius: 10,
                          )
                        ],
                        fontSize: 30),
                  ),
                ),
                SizedBox(height: 30),
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
                SizedBox(height: 20),
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(
                          ForgotPassword(),
                        );
                      },
                      child: Text(
                        "Forget Password?",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffFEDA77),
                        Color(0xffDD2A7B),
                        Color(0xff8134AF),
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.pink,
                      onTap: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        currentFocus.unfocus();
                        setState(() {
                          isLoding = true;
                        });
                        var result = await loginAccount(
                            email.text, password.text, context);
                        setState(() {
                          isLoding = false;
                        });
                        if (result) {
                          Get.off(ProductScreen());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to login"),
                            ),
                          );
                        }
                      },
                      child: Ink(
                        height: 55,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Login",
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.pink,
                      onTap: () async {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        currentFocus.unfocus();
                        await _handleSignIn();
                      },
                      child: Ink(
                        height: 55,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 40),
                                Image.network(
                                    "https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "GoogleSignIn",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.off(NumberScreen());
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
                            "Phone Auth",
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Or",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "don't have an account?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(colors: [
                      Color(0xffFEDA77),
                      Color(0xffDD2A7B),
                      Color(0xff8134AF),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                        .createShader(bounds);
                  },
                  child: TextButton(
                    onPressed: () {
                      Get.off(CreateAccount());
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 3,
                          shadows: [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0, 2),
                              blurRadius: 10,
                            )
                          ],
                          fontSize: 20),
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

  Future<bool> loginAccount(
      String email, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      GetStorage().write("uid", credential.user?.uid ?? null);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Wrong password provided for that user.')));
      }
      return false;
    }
  }
}
