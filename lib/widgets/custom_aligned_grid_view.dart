import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:valura/utils/size_constant.dart';

class CustomAlignedGridView extends StatelessWidget {
  const CustomAlignedGridView({super.key, required this.itemBuilder, required this.length, required this.crossAxisCount, this.paddings});
  final Widget? Function(BuildContext context, int index) itemBuilder;
  final int length;
  final int crossAxisCount;
  final EdgeInsetsGeometry? paddings;

  @override
  Widget build(BuildContext context) {
    return AlignedGridView.count(
      padding: paddings ?? EdgeInsets.symmetric(horizontal: sizeConstants.spacing8, vertical: sizeConstants.spacing12),
      physics: BouncingScrollPhysics(),
      itemCount: length,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: sizeConstants.spacing12,
      mainAxisSpacing: sizeConstants.spacing12,
      itemBuilder: itemBuilder,
    );
  }
}
