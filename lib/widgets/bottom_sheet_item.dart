import 'package:flutter/material.dart';
import 'package:valura/utils/size_constant.dart';

class BottomSheetItem extends StatelessWidget {
  const BottomSheetItem({super.key, required this.title, required this.color, this.onTap, required this.icon, this.bottom = false});
  final String title;
  final Color color;
  final Function()? onTap;
  final IconData icon;
  final bool bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(sizeConstants.spacing12),
            child: Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: sizeConstants.spacing12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
        if (bottom) SizedBox(height: sizeConstants.spacing24),
      ],
    );
  }
}
