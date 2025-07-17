// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:examle/netease/netease_helper.dart';
import 'package:examle/netease/netease_listener.dart';
import 'package:examle/netease/netease_utils.dart';
import 'package:flutter/material.dart';

void main() => runApp(RtcApp());

class RtcApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLNBeauty',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() {
    return _MainPageState();
  }
}

enum ConfirmAction { CANCEL, ACCEPT }

class _MainPageState extends State<MainPage> {
  NeteaseListener listener = NeteaseListener();
  bool loader = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('FUBeauty')),
        body: Container(
          margin: const EdgeInsets.all(15.0),
          child: loader
              ? Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: 200.0,
                          height: 55.0,
                          child: ElevatedButton(
                              onPressed: () async {
                                loader = true;
                                setState(() {});
                                await NeteaseUtils.initRtcEngine(
                                    listener, listener);
                                await NeteaseHelper.createHostLiveRoom(
                                  LiveType.video,
                                  context,
                                );
                                loader = false;
                                setState(() {});
                              },
                              child: const Text(
                                'Connect',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        )
                      ],
                    ),
                  ],
                ),
        ));
  }
}
