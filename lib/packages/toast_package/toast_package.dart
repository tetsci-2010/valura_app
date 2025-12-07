import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:valura/constants/colors.dart';

class ToastPackage {
  static void showSimpleToast({
    required String message,
    AlignmentGeometry? toastAlignment,
    ToastificationStyle? toastStyle,
    Duration? closeDuration,
    bool? dragToClose,
    bool? clickToClose,
    bool? showProgressBar,
  }) {
    Toastification toast = Toastification();
    toast.show(
      title: Text(message),
      type: ToastificationType.info,
      style: toastStyle,
      alignment: toastAlignment ?? Alignment.topCenter,
      autoCloseDuration: closeDuration ?? Duration(seconds: 3),
      dragToClose: dragToClose,
      closeOnClick: clickToClose,
      showProgressBar: showProgressBar ?? true,
    );
  }

  static void showWarningToast({
    required String message,
    AlignmentGeometry? toastAlignment,
    ToastificationStyle? toastStyle,
    Duration? closeDuration,
    bool? dragToClose,
    bool? clickToClose,
    bool? showProgressBar,
  }) {
    Toastification toast = Toastification();
    toast.dismissAll();
    toast.show(
      title: Text(message),
      type: ToastificationType.warning,
      backgroundColor: kOrangeAccentColor.withAlpha(20),
      style: toastStyle,
      alignment: toastAlignment ?? Alignment.topCenter,
      autoCloseDuration: closeDuration ?? Duration(seconds: 3),
      dragToClose: dragToClose,
      closeOnClick: clickToClose,
      showProgressBar: showProgressBar ?? true,
    );
  }
}
