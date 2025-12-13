import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';



void successToast({required String msg}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: AppColors.tealShade,
    textColor: AppColors.white,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    fontSize: 13,
    timeInSecForIosWeb: 2,
  );
}

void errorToast({required String? msg, int? timeInSecForIosWeb}) {
  Fluttertoast.showToast(
    msg: msg ?? "Something went wrong",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    fontSize: 13,
    backgroundColor: Colors.red,
    timeInSecForIosWeb: timeInSecForIosWeb ?? 2,
  );
}
