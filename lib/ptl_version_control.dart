library ptl_version_control;

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ptl_version_control/utilities.dart';

import 'api_call.dart';

/// A Calculator.
class PTLVersionChecker {
  checkV2({required String BaseUrl, required String EndPoint}) async {
    try {
      await VersionController(baseUrl: BaseUrl)
          .request('/api/mobile-app/auth/public/version', Method.GET, {
        'version_code':
            await PackageInfo.fromPlatform().then((value) => value.buildNumber),
        'current_os': Platform.isAndroid ? 'android' : 'ios'
      }).then((value) async {
        // print("update value -> $value");
        if ("${value['result']['status']}" != Utils.ACTIVE) {
          await VersionController(baseUrl: BaseUrl).request(
              '/api/mobile-app/auth/public/latest/version', Method.GET, {
            'current_os': Platform.isAndroid ? 'android' : 'ios'
          }).then((detailsValue) => {
                Get.generalDialog(
                    transitionBuilder: (ctx, anim1, anim2, child) =>
                        BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 4 * anim1.value,
                            sigmaY: 4 * anim1.value,
                          ),
                          child: FadeTransition(
                            child: child,
                            opacity: anim1,
                          ),
                        ),
                    pageBuilder: (bCtx, anim1, anim2) => WillPopScope(
                          onWillPop: () async => false,
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Container(
                              child: Row(children: [
                                Spacer(),
                                Text(
                                    "${value['result']['status']}" ==
                                            "${Utils.DEACTIVATE}"
                                        ? "Unsuported version"
                                        : "${value['result']['status']}" ==
                                                "${Utils.DEPRICATED}"
                                            ? 'Deprecated version'
                                            : "New Version Available",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    )),
                                Spacer(),
                                "${value['result']['status']}" !=
                                        Utils.DEACTIVATE
                                    ? Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.grey.shade200),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.grey.shade600,
                                          size: 20,
                                        ),
                                      )
                                    : Container()
                              ]),
                            ),
                            actionsPadding: EdgeInsets.all(24),
                            actions: [
                              InkWell(
                                onTap: () {
                                  OpenStore.instance.open(
                                    appStoreId:
                                        '1641085153', // AppStore id of your app for iOS
                                    androidAppBundleId:
                                        'com.pulsetechltd.medbox', // Android app bundle package name
                                  );
                                },
                                child: Container(
                                  height: 45,
                                  width: Get.width,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: AppColors.secondaryColor),
                                  child: Text("Update Now",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                            content: Container(
                              height: 200,
                              child: Column(
                                children: [
                                  if ("${value['result']['status']}" !=
                                      Utils.ACTIVE)
                                    Text(
                                      "${value['result']['status']}" ==
                                              "${Utils.DEACTIVATE}"
                                          ? "To continue using MedBox update to the latest version"
                                          : "This version of MedBox is deprecated, will no longer be supported after ${value['result']['deactivated_date']}",
                                      style: TextStyle(
                                          color: Colors.red.shade400,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  Spacer(),
                                  Text(
                                    "New Version",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${detailsValue['result']['version_name']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                  Spacer(),
                                  if (detailsValue['result']['description'] !=
                                      null)
                                    Row(
                                      children: [
                                        Text.rich(TextSpan(
                                            text: "What is new:\n",
                                            style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.bold),
                                            children: [
                                              TextSpan(
                                                  text: detailsValue['result']
                                                      ['description'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                  ))
                                            ])),
                                      ],
                                    ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ))
              });
        }
      });
    } on Exception catch (e) {
      print("error occured");
      // Get.snackbar("Verson Error", "${e}");
      // analytics.logEvent(name: "Version Update error", parameters: {
      //   'name': GetStorage().read(Pref.LOGIN_VALUmE)?['result']['name'],
      //   'phone': GetStorage().read(Pref.LOGIN_VALUE)?['result']['phone_number'],
      //   "error text": e,
      // }
      // );
    }
  }
}
