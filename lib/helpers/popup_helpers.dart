import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/utils/size_constant.dart';

class PopupHelpers {
  static void showPopupModal({required BuildContext context, Widget? child, String? title}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16, vertical: sizeConstants.spacing12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizeConstants.radiusMedium)),
          titlePadding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16, vertical: sizeConstants.spacing12),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title != null)
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              if (title == null) SizedBox(width: 1),
              InkWell(
                borderRadius: BorderRadius.circular(1000),
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.clear_rounded, color: kRedColor),
                ),
              ),
            ],
          ),
          content: Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (child != null) child,
              ],
            ),
          ),
        );
      },
    );
  }

  static void showYesOrNoDialog({
    required BuildContext context,
    required String title,
    Function()? onNoTap,
    Function(BuildContext bCtx)? onYesTap,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(sizeConstants.spacing16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizeConstants.radiusMedium)),
          content: Material(
            type: MaterialType.transparency,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: sizeConstants.spacing56),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap:
                            onNoTap ??
                            () {
                              try {
                                context.pop();
                              } catch (_) {}
                            },
                        child: Center(
                          child: Text(
                            'خیر',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 1.5,
                      height: 20,
                      color: Theme.of(context).primaryColor.withAlpha(100),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          if (onYesTap != null) {
                            onYesTap(context);
                          }
                        },
                        child: Center(
                          child: Text(
                            'بله',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
