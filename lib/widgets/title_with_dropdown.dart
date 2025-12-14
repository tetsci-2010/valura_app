import 'package:flutter/material.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/utils/size_constant.dart';

class TitleWithDropdown extends StatelessWidget {
  const TitleWithDropdown({
    super.key,
    required this.title,
    required this.child,
    required this.titleStyle,
    this.isRequired = false,
  });
  final String title;
  final Widget child;
  final TextStyle titleStyle;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: sizeConstants.spacing12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: title,
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: isRequired ? ' *' : '',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kRedColor),
                ),
              ],
            ),
          ),
          SizedBox(height: sizeConstants.spacing8),
          child,
        ],
      ),
    );
  }
}
