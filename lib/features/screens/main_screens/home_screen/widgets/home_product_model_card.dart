import 'package:flutter/material.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/utils/size_constant.dart';

class HomeProductModelCard extends StatelessWidget {
  const HomeProductModelCard({super.key, required this.name, required this.total, required this.color});
  final String name;
  final num total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sizeConstants.spacing12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: Theme.of(context).shadowColor.withAlpha(30),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4),
            height: sizeConstants.imageSmall,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: color,
            ),
            child: Center(
              child: Icon(Icons.settings_input_composite_rounded, color: kWhiteColor),
            ),
          ),
          SizedBox(height: sizeConstants.spacing12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.all_inbox_rounded, color: Theme.of(context).primaryColor, size: sizeConstants.iconS),
                  SizedBox(width: sizeConstants.spacing8),
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizeConstants.spacing8),
              Flexible(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing8, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sizeConstants.radiusSmall),
                      color: Theme.of(context).shadowColor.withAlpha(20),
                    ),
                    child: Text(
                      '$total ؋',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
