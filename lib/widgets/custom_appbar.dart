import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/utils/my_media_query.dart';
import 'package:valura/utils/size_constant.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, this.child, this.title, this.showBackBtn = false});
  final Widget? child;
  final String? title;
  final bool showBackBtn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMediaQueryWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(sizeConstants.radiusLarge),
          bottomRight: Radius.circular(sizeConstants.radiusLarge),
        ),
        color: Theme.of(context).primaryColor,
      ),
      padding: EdgeInsets.fromLTRB(
        sizeConstants.spacing16,
        ScreenUtil().statusBarHeight,
        sizeConstants.spacing16,
        sizeConstants.spacing16,
      ),
      child: showBackBtn
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    try {
                      context.pop();
                    } catch (_) {}
                  },
                  child: Padding(
                    padding: EdgeInsets.all(sizeConstants.spacing8),
                    child: Icon(Icons.arrow_back_rounded, color: kWhiteColor),
                  ),
                ),
                _getTitle(context, title, child),
                Icon(Icons.arrow_back_ios_new_rounded, color: kTransparentColor),
              ],
            )
          : _getTitle(context, title, child),
    );
  }
}

_getTitle(BuildContext context, String? title, Widget? child) {
  return title == null
      ? child ?? SizedBox.fromSize(size: Size.zero)
      : Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: kWhiteColor),
          ),
        );
}
