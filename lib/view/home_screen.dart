import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  final username = TextEditingController();
  final password = TextEditingController();
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: Column(
                    children: [
                      Container(
                        height: 235,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text("ADD DATA",
                                    style: TextStyle(fontSize: 15)),
                              )),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: username,
                                decoration: InputDecoration(
                                  hintText: "Username",
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 20),
                                  prefixIcon:
                                      Icon(Icons.person_outline_outlined),
                                  enabledBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  focusedBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  focusedErrorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: password,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 20),
                                  prefixIcon: Icon(Icons.lock_open),
                                  enabledBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  focusedBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  focusedErrorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MaterialButton(
                                      onPressed: () {
                                        Map<String, dynamic> data = {
                                          "Username": username.text,
                                          "Password": password.text,
                                          "timetamp": DateTime.now(),
                                        };
                                        userCollection
                                            .add(data)
                                            .then(
                                                (value) => print("User Added"))
                                            .catchError((Error) => print(
                                                "Faild to add user:$Error"));
                                        username.clear();
                                        password.clear();
                                        Navigator.pop(context);
                                      },
                                      child: Text("ADD")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("CANCEL")),
                                ],
                              )
                            ]),
                      )
                    ],
                  )),
            );
          },
          child: Icon(Icons.add)),
      appBar: AppBar(title: Text("Todo ")),
      body: StreamBuilder<QuerySnapshot>(
        stream: userCollection.orderBy('timetamp').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Somthing Went Wrong"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('${data["Username"]}'),
                subtitle: Text('${data["Password"]}'),
                trailing: Wrap(children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Column(
                              children: [
                                Container(
                                  height: 235,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text("ADD DATA",
                                              style: TextStyle(fontSize: 15)),
                                        )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          controller: username,
                                          decoration: InputDecoration(
                                            hintText: "Username",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 20),
                                            prefixIcon: Icon(
                                                Icons.person_outline_outlined),
                                            enabledBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none),
                                            errorBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        BorderSide.none),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          controller: password,
                                          decoration: InputDecoration(
                                            hintText: "Password",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 20),
                                            prefixIcon: Icon(Icons.lock_open),
                                            enabledBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none),
                                            errorBorder: UnderlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        BorderSide.none),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            MaterialButton(
                                                onPressed: () {
                                                  Map<String, dynamic> data = {
                                                    "Username": username.text,
                                                    "Password": password.text
                                                  };
                                                  userCollection
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .update(data)
                                                      .then((value) => print(
                                                          " User Updated"))
                                                      .catchError((error) =>
                                                          debugPrint(
                                                              "Data not updated$error"));
                                                  username.clear();
                                                  password.clear();
                                                  Navigator.pop(context);
                                                },
                                                child: Text("ADD")),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("CANCEL")),
                                          ],
                                        )
                                      ]),
                                )
                              ],
                            )),
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      userCollection
                          .doc(snapshot.data!.docs[index].id)
                          .delete()
                          .then((value) => print("user Deleted"))
                          .catchError((error) => print("error$error"));
                    },
                    icon: Icon(Icons.delete),
                  ),
                ]),
              );
            },
          );
        },
      ),
    );
  }
}
