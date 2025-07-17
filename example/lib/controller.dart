import 'package:dio/dio.dart';
import 'package:examle/config.dart';
import 'package:examle/model.dart';

class Common {
  apicall() async {
    String endPoint =
        'https://stgapi.gossipbirdapp.com/gossipbirdapi/api/neteaseTemp';
    var dio = Dio(BaseOptions(
      baseUrl: endPoint,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    ))
      ..interceptors.add(LogInterceptor());
    var responseData = await dio.get(endPoint);
    var response = CommonModel.fromJson(responseData.data);
    var userId = response.body?.myId.toString() ?? '';
    var tempId = userId.contains('G') ? userId.split('G')[1] : userId;
    GlobalVariable.token = response.body?.token.toString() ?? "";
    GlobalVariable.userId = int.tryParse(tempId) ?? 0;
    GlobalVariable.random = response.body?.topic.toString() ?? '';
  }
}

var common = Common();
