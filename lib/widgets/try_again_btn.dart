import 'package:flutter/material.dart';
import 'package:valura/constants/colors.dart';

class TryAgainBtn extends StatelessWidget {
  const TryAgainBtn({super.key, this.onTryAgain});
  final Function()? onTryAgain;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(1000),
      onTap: onTryAgain,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          border: Border.all(color: Theme.of(context).textTheme.bodyLarge?.color ?? kGreyColor),
        ),
        child: Icon(Icons.refresh_rounded),
      ),
    );
  }
}
