import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class MyFollowerFollowingList extends StatelessWidget {
  MyFollowerFollowingList(
      {Key? key, required this.myFollowerFollowingIdList, required this.lable})
      : super(key: key);

  final String lable;
  final List<String> myFollowerFollowingIdList;
  CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection('userProfile');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          "My ${lable}",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xffFEDA77),
            Color(0xffDD2A7B),
            Color(0xff8134AF),
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return StreamBuilder(
            stream: userProfileCollection
                .doc(
                  "${myFollowerFollowingIdList[index]}",
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something went wrong"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("loading"),
                );
              }

              return ListTile(
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "${(snapshot.data!.data() as Map)['user_profile']}")),
                title: Text(
                  "${(snapshot.data!.data() as Map)['full_name']}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              );
            },
          );
        },
        itemCount: myFollowerFollowingIdList.length,
      ),
    );
  }
}
