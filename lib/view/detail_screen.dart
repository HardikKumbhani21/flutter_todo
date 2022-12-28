import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/view/product_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  File? image;
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
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
            Center(
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
                  "Upload your profile picture",
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
            SizedBox(
              height: 40,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.width / 3,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: image == null
                        ? Border.all(color: Colors.black)
                        : Border.all(color: Colors.transparent),
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
                          icon: Icon(
                            Icons.camera_alt_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Enter your name',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                border: OutlineInputBorder(),
                hintText: "Name",
              ),
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () async {
                // Get.off(PostScreen());
                FocusScopeNode currentFocus = FocusScope.of(context);
                currentFocus.unfocus();
                setState(() {
                  isLoading = true;
                });
                var result = await createAccount(nameController.text, context);
                setState(() {
                  isLoading = false;
                });
                if (result) {
                  Get.off(ProductScreen());
                }
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
                        "Save",
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
    );
  }

  Future<bool> createAccount(String name, BuildContext context) async {
    try {
      var uploadResponse = await FirebaseStorage.instance
          .ref()
          .child('profile')
          .child(
              'profile_${widget.uid}_${DateTime.now()}.${image!.path.split(".")[image!.path.split(".").length - 1]}')
          .putFile(this.image!, SettableMetadata(contentType: "image/png"));
      String userProfilePictureUrl = await uploadResponse.ref.getDownloadURL();
      print("check done");
      print(userProfilePictureUrl);
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(widget.uid)
          .set({"user_profile": userProfilePictureUrl, "full_name": name});
      return true;
    } catch (e) {
      print("Error: " + e.toString());
      return false;
    }
  }
}
