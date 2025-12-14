import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/utils/size_constant.dart';

class LoadingCover extends StatelessWidget {
  const LoadingCover({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kGreyColor200.withAlpha(150),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing12, vertical: sizeConstants.spacing8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
            color: Theme.of(context).brightness == Brightness.light ? kGreyColor300 : kBlackColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoActivityIndicator(radius: 8.r),
              SizedBox(width: sizeConstants.spacing8),
              Text(
                'در حال بارگیری...',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
