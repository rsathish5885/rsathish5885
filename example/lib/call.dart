// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:examle/netease/nertc_video_view.dart';
import 'package:examle/netease/netease_helper.dart';
import 'package:examle/netease/netease_utils.dart';
import 'package:examle/strings.dart';
import 'package:examle/widget/slider_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:nertc_faceunity/nertc_faceunity.dart';
import 'package:flutter/material.dart';
import 'package:nertc_core/nertc_core.dart';
import 'colors.dart';
import 'config.dart';

class CallPage extends StatefulWidget {
  CallPage({Key? key});

  @override
  _CallPageState createState() {
    return _CallPageState();
  }
}

class _CallPageState extends State<CallPage>
    with NERtcChannelEventCallback, NERtcDeviceEventCallback {
  var _beautyEngine = NERtcFaceUnityEngine();
  var _faceUnityParams = NEFaceUnityParams();
  var _currentFilterNameKeyIndex = 0;
  @override
  void initState() {
    _beautyEngine.create(beautyKey: Uint8List.fromList(Config.auth)).then((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: buildCallingWidget(context),
      ),
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context);
      },
    );
  }

  Widget buildCallingWidget(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(child: buildVideoViews(context)),
      _selectItem(),
    ]);
  }

  Widget _selectItem() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                _topBeautyTitle(),
                Spacer(),
                _topBeautyRightTitle(),
              ],
            ),
          ),
          Center(
            child: Container(
              height: 60,
              child: ListView.builder(
                  itemCount: filterNames.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildFilterName(index);
                  }),
            ),
          ),
          _buildBeautyItem(
              beautyType: Strings.filterLevel,
              level: _faceUnityParams.filterLevel,
              max: 1,
              onChange: (value) => {
                    _beautyEngine.setFilterLevel(value),
                    _faceUnityParams.filterLevel = value
                  }),
          _buildBeautyItem(
              beautyType: Strings.colorLevel,
              level: _faceUnityParams.colorLevel,
              max: 2,
              onChange: (value) => {
                    _beautyEngine.setColorLevel(value),
                    _faceUnityParams.colorLevel = value
                  }),
          _buildBeautyItem(
              beautyType: Strings.blurLevel,
              level: _faceUnityParams.blurLevel,
              max: 6,
              onChange: (value) => {
                    _beautyEngine.setBlurLevel(value),
                    _faceUnityParams.blurLevel = value
                  }),
          _buildBeautyItem(
              beautyType: Strings.eyeEnlarging,
              level: _faceUnityParams.eyeBright,
              max: 1,
              onChange: (value) => {
                    _beautyEngine.setEyeEnlarging(value),
                    _faceUnityParams.eyeBright = value
                  }),
          _buildBeautyItem(
              beautyType: Strings.cheekThinning,
              level: _faceUnityParams.cheekThinning,
              max: 1,
              onChange: (value) => {
                    _beautyEngine.setCheekThinning(value),
                    _faceUnityParams.cheekThinning = value
                  }),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _topBeautyTitle() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 8),
      child: Align(
          alignment: Alignment.center,
          child: Text(
            Strings.beauty,
            style: TextStyle(
                color: UIColors.black_333333,
                fontSize: 16,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget _topBeautyRightTitle() {
    return GestureDetector(
      onTap: () {
        _faceUnityParams = NEFaceUnityParams();
        _currentFilterNameKeyIndex = 0;
        _beautyEngine.setMultiFUParams(_faceUnityParams);
        setState(() {});
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 8, right: 8),
        child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              Strings.resetBeauty,
              style: TextStyle(
                  color: UIColors.black_333333,
                  fontSize: 16,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  Widget _buildBeautyItem({
    required String beautyType,
    required double level,
    required double max,
    required Function(double value) onChange,
  }) {
    return Center(
      child: SliderWidget(
        beautyType: beautyType,
        onChange: onChange,
        level: level,
        max: max,
      ),
    );
  }

  Widget buildVideoViews(BuildContext context) {
    var list = NeteaseUtils.userRender.toList();
    return NERtcVideoViewX(
      uid: null,
      subStream: list[0].subStream,
      mirrorListenable: list[0].mirror,
    );
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 9 / 16,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          var data = list[index];
          return NERtcVideoViewX(
            uid: null,
            subStream: data.subStream,
            mirrorListenable: data.mirror,
          );
        });
  }

  @override
  void dispose() {
    NeteaseHelper.hostLiveEnd(LiveType.video);
    super.dispose();
  }

  @override
  void onConnectionTypeChanged(int newConnectionType) {
    print('onConnectionTypeChanged->' + newConnectionType.toString());
  }

  @override
  void onDisconnect(int reason) {
    print('onDisconnect->' + reason.toString());
  }

  @override
  void onFirstAudioDataReceived(int uid) {
    print('onFirstAudioDataReceived->' + uid.toString());
  }

  @override
  void onFirstVideoDataReceived(int uid, int? streamType) {
    print('onFirstVideoDataReceived->' + uid.toString());
  }

  @override
  void onLeaveChannel(int result) {
    print('onLeaveChannel->' + result.toString());
  }

  @override
  void onUserAudioMute(int uid, bool muted) {
    print('onUserAudioMute->' + uid.toString() + ', ' + muted.toString());
  }

  @override
  void onUserAudioStart(int uid) {
    print('onUserAudioStart->' + uid.toString());
  }

  @override
  void onUserAudioStop(int uid) {
    print('onUserAudioStop->' + uid.toString());
  }

  @override
  void onUserJoined(int uid, NERtcUserJoinExtraInfo? joinExtraInfo) {
    print('onUserJoined->' + uid.toString());
  }

  @override
  void onUserLeave(
      int uid, int reason, NERtcUserLeaveExtraInfo? leaveExtraInfo) {
    print('onUserLeave->' + uid.toString() + ', ' + reason.toString());
  }

  @override
  void onUserVideoMute(int uid, bool muted, int? streamType) {
    print('onUserVideoMute->' + uid.toString() + ', ' + muted.toString());
  }

  // @override
  // void onUserVideoProfileUpdate(int uid, int maxProfile) {
  //   print('onUserVideoProfileUpdate->' +
  //       uid.toString() +
  //       ', ' +
  //       maxProfile.toString());
  // }

  @override
  void onUserVideoStart(int uid, int maxProfile) {
    print('onUserVideoStart->' + uid.toString() + ', ' + maxProfile.toString());
  }

  Widget _buildFilterName(int index) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        onPressed: () {
          _faceUnityParams.filterName = filterNames[index];
          _beautyEngine.setFilterName(_faceUnityParams.filterName);
          _currentFilterNameKeyIndex = index;
          setState(() {});
        },
        child: Text(filterNames[index]),
        // shape: CircleBorder(),
        // elevation: 1.0,
        fillColor:
            _currentFilterNameKeyIndex == index ? Colors.blue : Colors.grey,
      ),
    ));
  }

  @override
  void onAudioRecording(int code, String filePath) {}

  @override
  void onLocalPublishFallbackToAudioOnly(bool isFallback, int streamType) {}

  @override
  void onMediaRelayReceiveEvent(int event, int code, String channelName) {}

  @override
  void onMediaRelayStatesChange(int state, String channelName) {}

  @override
  void onRemoteSubscribeFallbackToAudioOnly(
      int uid, bool isFallback, int streamType) {}

  @override
  void onJoinChannel(int result, int channelId, int elapsed, int uid) {}
}
