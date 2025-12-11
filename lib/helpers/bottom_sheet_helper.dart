import 'package:flutter/material.dart';
import 'package:valura/utils/my_media_query.dart';
import 'package:valura/utils/size_constant.dart';

class BottomSheetHelper {
  static void showBottomSheet({required BuildContext context, Widget? child}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(width: getMediaQueryWidth(context), child: child),
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(sizeConstants.radiusLarge),
          topRight: Radius.circular(sizeConstants.radiusLarge),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 10,
      isDismissible: true,
      showDragHandle: true,
    );
  }
}
