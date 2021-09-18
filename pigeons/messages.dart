import 'package:pigeon/pigeon.dart';

class NECreateFaceUnityRequest {
  Uint8List? beautyKey;
  String? logDir;
  int? logLevel;
}

class NEFUInt {
  int? value;
}

class NEFUBool {
  bool? value;
}

class NEFUDouble {
  double? value;
}

class NEFUString {
  String? value;
}

class SetFaceUnityParamsRequest {
  double? filterLevel;
  double? colorLevel;
  double? redLevel;
  double? blurLevel;
  double? eyeBright;
  double? eyeEnlarging;
  double? cheekThinning;
  //mycode isBeautyOn
  bool? isBeautyOn;
  double? cheekNarrow;
  double? cheekSmall;
  double? cheekV;
  double? chinLevel;
  double? foreHeadLevel;
  double? noseLevel;
  double? mouthLevel;
  double? toothWhiten;
  double? sharpenLevel;
  double? blureType;
  String? filterName;
}

@HostApi()
abstract class NEFTFaceUnityEngineApi {
  NEFUInt create(NECreateFaceUnityRequest request);

  NEFUBool setIsBeautyOn(NEFUBool isBeautyOn);

  NEFUInt setFilterLevel(NEFUDouble filterLevel);

  NEFUInt setFilterName(NEFUString filterName);

  NEFUInt setColorLevel(NEFUDouble colorLevel);

  NEFUInt setRedLevel(NEFUDouble redLevel);

  NEFUInt setBlurLevel(NEFUDouble blurLevel);

  NEFUInt setEyeEnlarging(NEFUDouble eyeEnlarging);

  NEFUInt setCheekThinning(NEFUDouble cheekThinning);

  NEFUInt setEyeBright(NEFUDouble eyeBright);

  NEFUInt setCheekNarrow(NEFUDouble cheekNarrow);

  NEFUInt setCheekSmall(NEFUDouble cheekSmall);

  NEFUInt setCheekV(NEFUDouble cheekV);

  NEFUInt setChinLevel(NEFUDouble chinLevel);

  NEFUInt setForeHeadLevel(NEFUDouble foreHeadLevel);

  NEFUInt setNoseLevel(NEFUDouble noseLevel);

  NEFUInt setMouthLevel(NEFUDouble mouthLevel);

  NEFUInt setToothWhiten(NEFUDouble toothWhiten);

  NEFUInt setSharpenLevel(NEFUDouble sharpenLevel);
  
  NEFUInt setBlureType(NEFUDouble blureType);

  NEFUInt setMultiFUParams(SetFaceUnityParamsRequest request);

  NEFUInt release();
}
