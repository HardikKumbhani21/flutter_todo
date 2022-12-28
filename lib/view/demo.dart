import 'dart:async';

import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  StreamController<int> _streamController = StreamController();
  int count = 0;

  @override
  void initState() {
    _streamController.addStream(getDataFromStream());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.data == 5) {
                  _streamController.sink.add(50000);
                }

                return Center(
                  child: Text("${snapshot.data}"),
                );
              },
              stream: _streamController.stream,
            ),
            StreamBuilder<int>(
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Center(
                  child: Text("${snapshot.data}"),
                );
              },
              stream: _streamController.stream,
            )
          ],
        ),
      ),
    );
  }
}

Future<int> getData() async {
  int i = 0;
  await Future.delayed(Duration(seconds: 5));
  Future.delayed(Duration(seconds: 7)).then((value) {
    i = 10;
  });
  return i;
}

Stream<int> getDataFromStream() async* {
  int i = 0;
  while (i < 100) {
    await Future.delayed(Duration(seconds: 1));
    yield ++i;
  }
  print("end");
}
