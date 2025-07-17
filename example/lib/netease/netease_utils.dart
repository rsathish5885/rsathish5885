import 'package:examle/config.dart';
import 'package:examle/netease/nertc_video_view.dart';
import 'package:flutter/material.dart';
import 'package:nertc_core/nertc_core.dart';

import 'netase.dart';

enum LiveType { audio, video, screenshare }

enum LiveUserType { host, guest, audience, admin1 }

class NeteaseUtils {
  static final neteaseEngine = NERtcEngine.instance;
  static var userRender = <NeteaseSession>{};
  static final videoRenderCache = VideoRenderCache(6);
  static LiveUserType? userType;
  static LiveType? type;
  static bool neteaseCall = false;
  static void get dispose => userRender.clear();
  static String? token = GlobalVariable.token;
  static String? neteaseKey = Config.APP_KEY;

  static Future<void> initRtcEngine(
    NERtcChannelEventCallback channelCallback,
    NERtcAudioMixingEventCallback audioCallback,
  ) async {
    final options = NERtcOptions(
      audioAutoSubscribe: true,
      videoAutoSubscribe: true,
      videoCaptureObserverEnabled: true,
      disableFirstJoinUserCreateChannel: true,
      serverRecordSpeaker: false,
      serverRecordAudio: false,
      serverRecordVideo: false,
      publishSelfStream: true,
      videoDecodeMode: NERtcMediaCodecMode.hardware,
      videoEncodeMode: NERtcMediaCodecMode.hardware,
      serverRecordMode: NERtcServerRecordMode
          .values[NERtcServerRecordMode.mixAndSingle.index],
      videoSendMode: NERtcVideoSendMode.values[NERtcVideoSendMode.high.index],
    );
    await neteaseEngine
        .create(
          appKey: neteaseKey!,
          channelEventCallback: channelCallback,
          options: options,
        )
        .then((value) => initAudio(LiveUserType.host))
        .then((value) => _initAudioEnable())
        .catchError((e) {});

    neteaseEngine.audioMixingManager.setEventCallback(audioCallback);
  }

  static Future<int> joinChannel(String roomId) async {
    print('ROOMID: ${roomId}');
    print('TOKEN: ${token}');
    await neteaseEngine.setChannelProfile(NERtcChannelProfile.liveBroadcasting);
    final data = await neteaseEngine.joinChannel(
      token,
      roomId,
      GlobalVariable.userId,
      NERtcJoinChannelOptions('1.0.1', null),
    );
    return data;
  }

  static Future<int> switchChannel(roomId) async {
    await neteaseEngine.setChannelProfile(NERtcChannelProfile.liveBroadcasting);
    return await neteaseEngine.switchChannel(token, '$roomId');
  }

  static Future<void> initRenderer(
      int streamId, String topic, LiveType type) async {
    await neteaseEngine.setClientRole(NERtcUserRole.broadcaster);
    if (LiveType.video == type) {
      var result = await neteaseEngine.startVideoPreview();
      debugPrint('initRenderer result: ${result}');
    }
    await joinChannel(topic);
    userRender.add(
      NeteaseSession(
        uid: streamId,
        mirror: true,
        subStream: false,
      ),
    );
  }

  static Future<void> _initAudioEnable() async {
    await neteaseEngine.enableLocalAudio(true);
    await neteaseEngine.enableLocalVideo(true);
    await neteaseEngine.enableAudioVolumeIndication(true, 100);
    neteaseEngine.setClientRole(NERtcUserRole.audience);
  }

  static Future<int> initAudio(LiveUserType usertype) async {
    // var qulity = await AppSharedPreferences.getAudioQulity();
    var qulity = 'Speech';
    if (usertype == LiveUserType.audience) {
      qulity = 'Music';
    }
    var audioQulity = NERtcAudioScenario.scenarioSpeech;
    switch (qulity) {
      case 'Speech':
        audioQulity = NERtcAudioScenario.scenarioSpeech;
        break;
      case 'Music':
        audioQulity = NERtcAudioScenario.scenarioMusic;
        break;
    }
    const audioFreq = NERtcAudioProfile.profileStandardExtend;
    return await neteaseEngine.setAudioProfile(audioFreq, audioQulity);
  }

  static Future<int> initVideo() async {
    await neteaseEngine.enableDualStreamMode(false);
    var config = NERtcVideoConfig();
    config.videoCropMode = NERtcVideoCropMode.cropDefault;
    config.height = 540;
    config.width = 960;
    config.minFrameRate = NERtcVideoFrameRate.fps_7;
    config.frameRate = NERtcVideoFrameRate.fps_24;
    config.frontCamera = true;
    final captureConfig = NERtcCameraCaptureConfig.manual(1280, 720);
    await neteaseEngine.setCameraCaptureConfig(captureConfig);
    return neteaseEngine.setLocalVideoConfig(config);
  }

  static Future<void> broadStart(int streamId, {int canvasCall = 0}) async {
    if (userType != LiveUserType.host) {
      final session =
          NeteaseSession(uid: streamId, subStream: false, mirror: true);
      userRender.add(session);
    }
  }

  static void audienceAudio(int streamId) {
    if (type == LiveType.audio) {
      final session = NeteaseSession(
        uid: streamId,
        subStream: false,
        mirror: false,
      );
      neteaseCall = true;
      userRender.add(session);
    }
  }

  static Future<int> muteStream(bool mute, LiveType type) async {
    if (LiveType.audio == type) {
      return await neteaseEngine.muteLocalAudioStream(mute);
    } else {
      return await neteaseEngine.muteLocalVideoStream(mute);
    }
  }

  //  -----------   attach External Audio source to current live   -----------------

  static Future<int> startMediaPlayer(String path) =>
      neteaseEngine.audioMixingManager
          .startAudioMixing(NERtcAudioMixingOptions(path: path));

  static Future<int> stopMediaPlayer() =>
      neteaseEngine.audioMixingManager.stopAudioMixing();

  static Future<int> playMediaPlayer() =>
      neteaseEngine.audioMixingManager.resumeAudioMixing();

  static Future<int> pauseMediaPlayer() =>
      neteaseEngine.audioMixingManager.pauseAudioMixing();

  static Future<int> setMusicPosition(int position) =>
      neteaseEngine.audioMixingManager.setAudioMixingPosition(position);

  static Future<int> getVolume() =>
      neteaseEngine.audioMixingManager.getAudioMixingPlaybackVolume();

  static Future<void> setMusicVolume(int value) async {
    await neteaseEngine.audioMixingManager.setAudioMixingPlaybackVolume(value);
    await neteaseEngine.audioMixingManager.setAudioMixingSendVolume(value);
  }
}
