class CommonModel {
  int? status;
  String? message;
  Body? body;

  CommonModel({this.status, this.message, this.body});

  CommonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  String? myId;
  String? topic;
  String? token;
  String? roomCid;
  String? pushUrl;
  String? cid;

  Body(
      {this.myId,
      this.token,
      this.roomCid,
      this.pushUrl,
      this.cid,
      this.topic});

  Body.fromJson(Map<String, dynamic> json) {
    myId = json['myId'];
    token = json['token'];
    roomCid = json['roomCid'];
    pushUrl = json['pushUrl'];
    cid = json['cid'];
    topic = json['topic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['myId'] = this.myId;
    data['token'] = this.token;
    data['roomCid'] = this.roomCid;
    data['pushUrl'] = this.pushUrl;
    data['cid'] = this.cid;
    data['topic'] = this.topic;

    return data;
  }
}
