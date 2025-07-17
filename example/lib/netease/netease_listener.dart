import 'package:nertc_core/nertc_core.dart';

import 'netase.dart';

class NeteaseListener extends NERtcAudioMixingEventCallback
    with NERtcChannelEventCallback, NERtcStatsEventCallback {
  @override
  void onAudioHasHowling() {}

  @override
  void onAudioRecording(int code, String filePath) {}

  @override
  void onClientRoleChange(int oldRole, int newRole) {
    print('onClientRoleChange oldRole: $oldRole');
    print('onClientRoleChange newRole: $newRole');
  }

  @override
  void onConnectionStateChanged(int state, int reason) {}

  @override
  void onConnectionTypeChanged(int newConnectionType) {}

  @override
  void onDisconnect(int reason) {
    print('onDisconnect REASON: $reason');
  }

  @override
  void onError(int code) {
    print('onError RESULT: $code');
  }

  @override
  void onFirstAudioDataReceived(int uid) {}

  @override
  void onFirstAudioFrameDecoded(int uid) {}

  @override
  void onFirstVideoDataReceived(int uid, int? streamType) {}

  @override
  void onFirstVideoFrameDecoded(
    int uid,
    int width,
    int height,
    int? streamType,
  ) {}

  @override
  void onJoinChannel(int result, int channelId, int elapsed, int uid) {
    print('onJoinChannel UID: $uid');
    print('onJoinChannel CHANNELID: $channelId');
    print('onJoinChannel RESULT: $result');
  }

  @override
  void onLeaveChannel(int result) {
    print('onLeaveChannel RESULT: $result');
  }

  @override
  void onLiveStreamState(String taskId, String pushUrl, int liveState) {}

  @override
  void onLocalAudioVolumeIndication(int volume, bool vadFlag) {}

  @override
  void onLocalPublishFallbackToAudioOnly(bool isFallback, int streamType) {}

  @override
  void onMediaRelayReceiveEvent(int event, int code, String channelName) {}

  @override
  void onMediaRelayStatesChange(int state, String channelName) {}

  @override
  void onReJoinChannel(int result, int channelId) {}

  @override
  void onRecvSEIMsg(int userID, String seiMsg) {}

  @override
  void onReconnectingStart() {}

  @override
  void onRemoteAudioVolumeIndication(
    List<NERtcAudioVolumeInfo> volumeList,
    int totalVolume,
  ) {}

  @override
  void onRemoteSubscribeFallbackToAudioOnly(
    int uid,
    bool isFallback,
    int streamType,
  ) {}

  @override
  void onUserAudioMute(int uid, bool muted) {}

  @override
  void onUserAudioStart(int uid) {
    NeteaseUtils.audienceAudio(uid);
  }

  @override
  void onUserAudioStop(int uid) {}

  @override
  void onUserJoined(int uid, NERtcUserJoinExtraInfo? joinExtraInfo) {}

  @override
  void onUserLeave(
    int uid,
    int reason,
    NERtcUserLeaveExtraInfo? leaveExtraInfo,
  ) {}

  @override
  void onUserSubStreamVideoStart(int uid, int maxProfile) {}

  @override
  void onUserSubStreamVideoStop(int uid) {}

  @override
  void onUserVideoMute(int uid, bool muted, int? streamType) {}

  @override
  void onUserVideoStart(int uid, int maxProfile) {}

  @override
  void onUserVideoStop(int uid) {}

  @override
  void onWarning(int code) {}

  @override
  void onAudioMixingStateChanged(int reason) {}

  @override
  void onNetworkQuality(List<NERtcNetworkQualityInfo> statsList) {}

  @override
  void onAudioMixingTimestampUpdate(int timestampMs) {}

  @override
  void onLocalAudioStats(NERtcAudioSendStats stats) {}

  @override
  void onLocalVideoStats(NERtcVideoSendStats stats) {}

  @override
  void onRemoteAudioStats(List<NERtcAudioRecvStats> statsList) {}

  @override
  void onRemoteVideoStats(List<NERtcVideoRecvStats> statsList) {}

  @override
  void onRtcStats(NERtcStats stats) {}
}
