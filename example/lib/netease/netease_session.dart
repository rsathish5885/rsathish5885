import 'package:flutter/material.dart';

class NeteaseSession {
  ValueNotifier<bool> mirror = ValueNotifier(false);
  bool subStream = false;
  int? uid;

  NeteaseSession({this.uid, this.subStream = false, bool mirror = false}) {
    this.mirror.value = mirror;
  }

  NeteaseSession.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    mirror.value = json['mirror'] == null ? false : json['mirror'] as bool;
    subStream = json['subStream'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['subStream'] = subStream;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NeteaseSession &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          subStream == other.subStream;

  @override
  int get hashCode => uid.hashCode ^ subStream.hashCode;
}
