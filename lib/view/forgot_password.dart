import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailCtrlForForPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
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
                "Forgot\nPassword?",
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
              height: 30,
            ),
            Center(
              child: Text(
                'Enter the email address associated with your account',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: emailCtrlForForPass,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                border: OutlineInputBorder(),
                hintText: "Email",
              ),
            ),
            SizedBox(
              height: 40,
            ),
            // Center(
            //   child: SizedBox(
            //     height: 45,
            //     width: 150,
            //     child: MaterialButton(
            //       elevation: 5,
            //       color: Color(0xffC3C3B4),
            //       onPressed: () async {
            //         FocusScopeNode currentFocus = FocusScope.of(context);
            //         currentFocus.unfocus();
            //         await FirebaseAuth.instance.sendPasswordResetEmail(
            //             email: emailCtrlForForPass.text);
            //
            //         // Get.to(
            //         //   Verification(),
            //         // );
            //       },
            //       child: Text(
            //         'Send',
            //         style: TextStyle(
            //           fontSize: 16,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () async {
                FocusScopeNode currentFocus = FocusScope.of(context);
                currentFocus.unfocus();
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: emailCtrlForForPass.text);

                // Get.to(
                //   Verification(),
                // );
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
                        "Send",
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
            Center(
              child: Text(
                'Or',
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Center(
              child: InkWell(
                onTap: () {
                  print("object");
                  // Get.to(LoginScreen());
                  Get.back();
                },
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(colors: [
                      Color(0xffFEDA77),
                      Color(0xffDD2A7B),
                      Color(0xff8134AF),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                        .createShader(bounds);
                  },
                  child: Text(
                    "Back to sign in",
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
            ),
          ],
        ),
      ),
    );
  }
}
