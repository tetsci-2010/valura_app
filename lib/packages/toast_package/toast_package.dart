import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:valura/constants/colors.dart';

class ToastPackage {
  static void showSimpleToast({
    required BuildContext context,
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
      title: Text(message, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
      type: ToastificationType.info,
      style: toastStyle,
      alignment: toastAlignment ?? Alignment.topCenter,
      autoCloseDuration: closeDuration ?? Duration(seconds: 3),
      dragToClose: dragToClose,
      closeOnClick: clickToClose,
      showProgressBar: showProgressBar ?? true,
      primaryColor: Theme.of(context).primaryColor,
      progressBarTheme: ProgressIndicatorThemeData(color: Theme.of(context).primaryColor),
      closeButton: ToastCloseButton(showType: CloseButtonShowType.always),
    );
  }

  static void showWarningToast({
    required BuildContext context,
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
      title: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: kWhiteColor),
      ),
      type: ToastificationType.warning,
      backgroundColor: kOrangeColor,
      style: toastStyle,
      alignment: toastAlignment ?? Alignment.topCenter,
      autoCloseDuration: closeDuration ?? Duration(seconds: 3),
      dragToClose: dragToClose,
      closeOnClick: clickToClose,
      showProgressBar: showProgressBar ?? true,
    );
  }
}
