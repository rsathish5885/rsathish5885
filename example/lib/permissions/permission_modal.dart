// import '../../all_export.dart';

// class PermissionModal extends StatelessWidget {
//   final Permission permission;
//   final bool isAll;
//   const PermissionModal({
//     super.key,
//     required this.permission,
//     this.isAll = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     var imgName = '';
//     var title = '';
//     var description = '';

//     if (permission == Permission.bluetoothConnect) {
//       imgName = Images.permissions;
//       title = 'Bluetooth Access'.tr;
//       description =
//           'Please  allow  access to your bluetooth to Stream Video Live'.tr;
//     } else if (permission == Permission.camera) {
//       imgName = Images.permissions;
//       title = 'Camera Access'.tr;
//       description =
//           'Please allow access to your camera to Stream Video Live'.tr;
//     } else if (permission == Permission.microphone) {
//       imgName = Images.permissions;
//       title = 'Microphone Access'.tr;
//       description =
//           'Please allow access to your microphone to Stream Audio Live'.tr;
//     } else if (permission == Permission.storage ||
//         permission == Permission.audio ||
//         permission == Permission.photos) {
//       imgName = Images.permissions;
//       title = 'Photo and Media Access'.tr;
//       description =
//           'Please  allow  access to your photo and media to Stream Video Live'
//               .tr;
//     } else if (permission == Permission.notification) {
//       imgName = Images.notification;
//       title = 'Notification Access'.tr;
//       description =
//           'Please allow Notification to get More Notify about Gossip Bird'.tr;
//     }

//     if (isAll) {
//       imgName = Images.permissions;
//       title = 'Permission Access'.tr;
//       description =
//           'Please allow camera, microphone,bluetooth , photo and media to get More Notify about Gossip Bird'
//               .tr;
//     }

//     return AlertDialog(
//       // backgroundColor: Colors.transparent,
//       titlePadding: EdgeInsets.zero,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(20.0)),
//       ),
//       contentPadding: EdgeInsets.zero,
//       content: Container(
//         width: 300,
//         height: isTab ? 600 : 550,
//         padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
//         decoration: BoxDecoration(
//           color: commonVariable.darktheme
//               ? Colors.transparent
//               : Constants.primaryColor,
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(
//               width: isTab ? 170 : 220,
//               height: isTab ? 170 : 220,
//               child: AssetCheck(
//                 assetPath: imgName,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             RichText(
//               text: TextSpan(
//                 text: '$title\n',
//                 style: commonFunction.buildTextStyle(
//                   22,
//                   fontWeights: FontWeight600,
//                   commonVariable.darktheme
//                       ? Colorshite
//                       : Constants.livedatablacktext,
//                 ),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: description,
//                     style: commonFunction.buildTextStyle(
//                       15,
//                       fontWeights: FontWeight400,
//                       commonVariable.darktheme
//                           ? Colorshite
//                           : Constants.livedatablacktext,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 InkWell(
//                   onTap: () async {
//                     if (isAll) {
//                       Get.back(result: 'true');
//                       return;
//                     }
//                     final status = await permission.status;
//                     if (status == PermissionStatus.permanentlyDenied) {
//                       Get.back();
//                       await openAppSettings();
//                     } else {
//                       if (!status.isGranted) {
//                         await permission.request();
//                       }
//                       Get.back();
//                     }
//                   },
//                   child: Container(
//                     height: 45,
//                     decoration: BoxDecoration(
//                       gradient: commonVariable.darktheme
//                           ? Constants.gradientBlack
//                           : Constants.themeColor,
//                       borderRadius: BorderRadius.circular(40.0),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Continue'.tr,
//                         style: commonFunction.buildTextStyle(
//                           17,
//                           Constants.primaryColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 if (Platform.isAndroid)
//                   InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Container(
//                       height: 20,
//                       alignment: Alignment.center,
//                       margin: const EdgeInsets.only(top: 20),
//                       child: Text(
//                         'Skip'.tr,
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
