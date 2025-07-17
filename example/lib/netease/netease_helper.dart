import 'dart:io';

import 'package:examle/call.dart';
import 'package:examle/config.dart';
import 'package:examle/controller.dart';
import 'package:examle/permissions/permission.dart';
import 'package:flutter/material.dart';
import 'package:nertc_core/nertc_core.dart';

import 'netase.dart';

class NeteaseHelper {
  static Future<void> createHostLiveRoom(
    LiveType liveType,
    BuildContext context,
  ) async {
    await common.apicall();
    try {
      NeteaseUtils.neteaseEngine.leaveChannel();
    } catch (e) {
      print('E: ${e}');
    }
    final permissionStatus = await AppPermission.getPermissions(Platform.isIOS);
    if (permissionStatus) {
      await NeteaseUtils.neteaseEngine.deviceManager
          .setPlayoutDeviceMute(false);
      if (liveType == LiveType.video) {
        await NeteaseUtils.initVideo();
      }
      await NeteaseUtils.initAudio(LiveUserType.host);
      await NeteaseUtils.initRenderer(
        GlobalVariable.userId,
        GlobalVariable.random,
        liveType,
      );
      var localVideo = true;
      await NeteaseUtils.neteaseEngine.enableLocalVideo(localVideo);
      debugPrint(' NeteaseUtils.userRender: ${NeteaseUtils.userRender}');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CallPage()));
    }
  }

  static Future<void> hostLiveEnd(LiveType liveType) async {
    NeteaseUtils.neteaseEngine.leaveChannel();
    NeteaseUtils.dispose;
  }

  Future<void> joinAsCoHost() async {
    await NeteaseUtils.neteaseEngine.setClientRole(NERtcUserRole.broadcaster);
    await NeteaseUtils.broadStart(GlobalVariable.userId);
  }

  Future<void> coHostLeave() async {
    await NeteaseUtils.neteaseEngine.setClientRole(NERtcUserRole.audience);
  }
}
