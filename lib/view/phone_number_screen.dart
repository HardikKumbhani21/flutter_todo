import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'otp_screen.dart';

class NumberScreen extends StatefulWidget {
  NumberScreen({Key? key, this.preFill}) : super(key: key);
  String? preFill;

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  TextEditingController controller1 = TextEditingController();
  var _contrycode = 'IN';

  @override
  void initState() {
    controller1.text = widget.preFill ?? "";

    super.initState();
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
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
                "What is Your Phone\nNumber?",
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
            SizedBox(
              height: 100,
            ),
            Text("Please enter your phon number to\nverify your account",
                style: TextStyle(color: Colors.black54)),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  CountryCodePicker(
                    onChanged: (cc) {
                      _contrycode = cc.code!;
                    },
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: _contrycode,
                    favorite: ['+91', 'IN'],
                    // optional. Shows only country name and flag
                    showCountryOnly: false,

                    // optional. Shows only country name and flag when popup is closed.
                    showOnlyCountryWhenClosed: false,
                    // optional. aligns the flag and the Text left
                    alignLeft: false,
                  ),
                  VerticalDivider(
                    thickness: 1,
                    color: Color(0xff707070),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller1,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        hintText: '123 456 7890',
                        hintStyle:
                            TextStyle(color: Color(0xffB6B7B7), fontSize: 18),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                currentFocus.unfocus();
                log('METHOD CALLED');
                mobileVerification(controller1.text);
                // Get.to(OtpScreen());
              },
              child: Container(
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
                  child: Ink(
                    height: 55,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Send Verification Code",
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
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void mobileVerification(String mobileNo) async {
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
            number: controller1.text,
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
}
