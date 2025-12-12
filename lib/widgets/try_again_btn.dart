import 'package:flutter/material.dart';

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
          border: Border.all(),
        ),
        child: Icon(Icons.refresh_rounded),
      ),
    );
  }
}
