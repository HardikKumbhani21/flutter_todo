import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController descr = TextEditingController();
  bool isLoading = false;
  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Data",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white38,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            image == null
                                ? SizedBox()
                                : Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              right: 0,
                              child: Center(
                                child: IconButton(
                                    onPressed: () async {
                                      final ImagePicker _picker = ImagePicker();
                                      final XFile? image =
                                          await _picker.pickImage(
                                              source: ImageSource.gallery);
                                      this.image = File(
                                        image!.path,
                                      );
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.camera)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: descr,
                      maxLines: 5,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white,
                        labelText: "Description",
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      height: 60,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.blue,
                      onPressed: () async {
                        setState(
                          () {
                            isLoading = true;
                          },
                        );
                        await createpost(image!, descr.text);
                        descr.clear();
                        setState(
                          () {
                            isLoading = false;
                          },
                        );

                        Get.back();
                      },
                      child: Text("Submit",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ),
            ]),
          ),
          isLoading
              ? Positioned(child: Center(child: CircularProgressIndicator()))
              : SizedBox(),
        ],
      ),
    );
  }

  Future<void> createpost(FileImage, String desc) async {
    var uploadresponse = await FirebaseStorage.instance
        .ref()
        .child('userPost')
        .child('userpost${GetStorage().read('uid')}_${DateTime.now()}')
        .putFile(
          this.image!,
        );
    String postimageurl = await uploadresponse.ref.getDownloadURL();
    Map<String, dynamic> post = {
      'uid': '${GetStorage().read('uid')}',
      'desc': desc,
      'image': postimageurl,
    };

    FirebaseFirestore.instance.collection('userPost').add(post).then((value) {
      FirebaseFirestore.instance
          .collection('userPost')
          .doc(value.id)
          .collection('like');
    });
  }
}
