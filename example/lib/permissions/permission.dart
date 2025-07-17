import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static int? _sdkInt;
  static bool isManualPermission = false;

  static Map<Permission, PermissionStatus?> _permissionsMap = {
    Permission.camera: null,
    Permission.microphone: null,
    Permission.bluetoothConnect: null,
  };
  static Future<void> getSdkversion() async {
    _sdkInt ??= (await DeviceInfoPlugin().androidInfo).version.sdkInt;
  }

  static Future<void> _checkPlatformPermission() async {
    if (Platform.isAndroid) {
      await getSdkversion();
      if (_sdkInt! >= 33) {
        _permissionsMap.remove(Permission.storage);
        _permissionsMap[Permission.audio] = null;
        _permissionsMap[Permission.photos] = null;
      } else {
        _permissionsMap[Permission.storage] = null;
      }
    } else {
      _permissionsMap[Permission.storage] = null;
    }

    if (Platform.isIOS) {
      _permissionsMap.remove(Permission.bluetoothConnect);
    }
  }

  ///get manual permission
  static Future<bool> getManualPermissions(
    List<Permission> manualPermissions,
  ) async {
    isManualPermission = true;
    final tempList = _permissionsMap;
    for (final element in manualPermissions) {
      _permissionsMap = {};
      _permissionsMap[element] = null;
    }
    await getPermissions(true);
    _permissionsMap = tempList;
    final res = await getManualPermissionStatus(manualPermissions);
    isManualPermission = false;
    return res;
  }

  ///get manual permission status
  static Future<bool> getManualPermissionStatus(
    List<Permission> manualPermissions,
  ) async {
    final tempList = _permissionsMap;
    for (final element in manualPermissions) {
      _permissionsMap = {};
      _permissionsMap[element] = null;
    }
    final status = await checkPermissions();
    _permissionsMap = tempList;
    return status;
  }

  /// return true all permissions are granded else not granded
  static Future<bool> checkPermissions({bool getStatusOnly = false}) async {
    if (!getStatusOnly) {
      if (!isManualPermission) {
        await _checkPlatformPermission();
      } else if (_permissionsMap.containsKey(Permission.storage)) {
        await _checkPlatformPermission();
      }
      final mylist = _permissionsMap.keys.toList();
      for (var i = 0; i < mylist.length; i++) {
        _permissionsMap[mylist[i]] = await mylist[i].status;
      }
    }

    for (final entry in _permissionsMap.entries) {
      if (entry.value != PermissionStatus.granted) {
        if (Platform.isAndroid) {
          if (_sdkInt! >= 34 && entry.value == PermissionStatus.limited) {
            continue;
          }
        }
        return false;
      }
    }

    return true;
  }

  ///it check permission status and trigger permission modal
  static Future<bool> getPermissions(bool manualPermission) async {
    var result = await checkPermissions();
    print('RESULT: ${result}');
    print('_PERMISSIONSMAP: ${_permissionsMap.entries}');
    if (manualPermission) {
      for (final entry in _permissionsMap.entries) {
        if (entry.value != PermissionStatus.granted &&
            entry.value?.isGranted == false) {
          if (Platform.isAndroid) {
            if (_sdkInt! >= 34 && entry.value == PermissionStatus.limited) {
              continue;
            }
          }
          // await Get.dialog(PermissionModal(permission: entry.key));
          await getPerm(entry.key);
        }
      }
    } else {
      var showpopup = false;
      for (final entry in _permissionsMap.entries) {
        if (entry.value != PermissionStatus.granted &&
            entry.value?.isGranted == false) {
          showpopup = true;
          if (Platform.isAndroid) {
            if (_sdkInt! >= 34 && entry.value == PermissionStatus.limited) {
              showpopup = false;
            }
          }
        }
      }
      if (showpopup) {
        for (final entry in _permissionsMap.entries) {
          if (entry.value != PermissionStatus.granted &&
              entry.value?.isGranted == false) {
            final status = entry.value!;
            if (status == PermissionStatus.permanentlyDenied) {
              await openAppSettings();
            } else {
              if (!status.isGranted) {
                await entry.key.request();
              }
            }
          }
        }
      }
    }
    return await checkPermissions();
  }

  static Future<String?> getPerm(Permission permission) async {
    final status = await permission.status;
    if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    } else {
      if (!status.isGranted) {
        await permission.request();
      }
      return 'true';
    }
    return null;
  }
}
