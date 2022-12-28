import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/view/phone_number_screen.dart';
import 'package:flutter_todo/view/product_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import 'detail_screen.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key, required this.verficationID, required this.number})
      : super(key: key);
  final String verficationID;
  String number;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = '';

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.1,
              ),
              Text(
                'Verification\nCode',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: height * 0.1,
              ),
              Text(
                'Please enter Code sent to',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  color: const Color(0xff707070),
                  letterSpacing: 0.18,
                ),
                softWrap: false,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '+91 ${widget.number}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: const Color(0xff000000),
                      letterSpacing: 0.18,
                      fontWeight: FontWeight.w700,
                    ),
                    softWrap: false,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NumberScreen(),
                          ));
                    },
                    child: Text(
                      'Change phone Number',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: const Color(0xff2d6a4f),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Center(
                child: OTPTextField(
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  length: 6,
                  spaceBetween: 10,
                  width: 340,
                  fieldWidth: 45,
                  style: TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 13, horizontal: 0),
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  otpFieldStyle: OtpFieldStyle(
                      focusBorderColor: Colors.green,
                      disabledBorderColor: Colors.grey),
                  onCompleted: (pin) {
                    print("Completed: " + pin);

                    setState(() {
                      otp = pin;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    await mobileVerification(widget.number);
                  },
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: const Color(0xff2d6a4f),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.3,
              ),
              MaterialButton(
                height: 50,
                color: Colors.blueAccent,
                onPressed: phoneAuthCodeVerification,
                child: Center(
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> mobileVerification(String mobileNo) async {
    log('METHOD CALLED2');
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+91 ${mobileNo}',
        verificationCompleted: (PhoneAuthCredential credential) {
          log('VERIFICATION ${credential.smsCode}');
        },
        verificationFailed: (FirebaseAuthException e) {
          print("verificationFailed");
        },
        codeSent: (String verificationId, int? resendToken) {
          log("codeSent verificationId:${verificationId} resendToken:${resendToken} ");

          Get.to(OtpScreen(
            verficationID: verificationId,
            number: mobileNo,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log("codeAutoRetrievalTimeout");
        },
      );
      log('ERROR 1111');
    } catch (e) {
      log('ERROR $e');
    }
  }

  void phoneAuthCodeVerification() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verficationID, smsCode: otp);

    try {
      UserCredential user = await auth.signInWithCredential(credential);

      if (user.user != null) {
        log('USER SUCCESSFUl');
        print(user.user!.uid);
        GetStorage().write('uid', user.user!.uid);

        var userProfile = await FirebaseFirestore.instance
            .collection("userProfile")
            .doc(user.user!.uid)
            .get();

        if (userProfile.exists) {
          //profile already exists
          //goto home

          Get.offAll((ProductScreen()));
        } else {
          Get.offAll(DetailScreen(
            uid: user.user!.uid,
          ));
          //goto create profile and after goto home form create profile

        }
      } else {
        log('ERROR');
      }
    } on FirebaseAuthException {
      Get.snackbar("Verification Field", "Timeout Resend OTP ");
    }
  }
}
