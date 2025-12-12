import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/utils/size_constant.dart';

class ItemPartCard extends StatelessWidget {
  const ItemPartCard({super.key, required this.item, this.onDeleteTap, this.onEditTap});
  final ItemModel item;
  final Function(BuildContext context)? onDeleteTap;
  final Function(BuildContext context)? onEditTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizeConstants.radiusMedium)),
      elevation: .6,
      shadowColor: Theme.of(context).shadowColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
        child: Slidable(
          closeOnScroll: true,
          key: GlobalKey(),
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                flex: 2,
                onPressed: onEditTap,
                backgroundColor: kBlueColor,
                foregroundColor: kWhiteColor,
                icon: Icons.edit_note_rounded,
                label: 'ویرایش',
              ),
              SlidableAction(
                flex: 2,
                onPressed: onDeleteTap,
                backgroundColor: kRedColor,
                foregroundColor: kWhiteColor,
                icon: Icons.delete,
                label: 'حذف',
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: sizeConstants.spacing12, horizontal: sizeConstants.spacing12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  color: Theme.of(context).brightness == Brightness.light ? kBlackColor12.withAlpha(20) : kGreyColor800.withAlpha(70),
                  blurRadius: 7,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: sizeConstants.spacing8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                border: Border.all(color: Theme.of(context).primaryColor.withAlpha(120)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing8, vertical: sizeConstants.spacing2),
                    decoration: BoxDecoration(
                      border: BoxBorder.fromLTRB(bottom: BorderSide(color: Theme.of(context).primaryColor.withAlpha(100))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.list_alt, size: 18.r),
                              SizedBox(width: sizeConstants.spacing4),
                              Flexible(
                                child: Text('جنس:', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: sizeConstants.spacing8),
                        Flexible(child: Text(item.name, maxLines: 1)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.attach_money_rounded, size: 18.r),
                              SizedBox(width: sizeConstants.spacing4),
                              Flexible(
                                child: Text('نرخ خرید:', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: sizeConstants.spacing8),
                        Flexible(child: Text('${item.unitCost} ؋', maxLines: 1, textDirection: TextDirection.ltr)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.money_off, size: 18.r),
                              SizedBox(width: sizeConstants.spacing4),
                              Flexible(
                                child: Text('مصرف:', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: sizeConstants.spacing8),
                        Flexible(child: Text('${item.landCost} ؋', maxLines: 1, textDirection: TextDirection.ltr)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.payments_outlined, size: 18.r),
                              SizedBox(width: sizeConstants.spacing4),
                              Flexible(
                                child: Text('تمام شد:', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: sizeConstants.spacing8),
                        Flexible(child: Text('${item.unitCost} ؋', maxLines: 1, textDirection: TextDirection.ltr)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long_outlined, size: 18.r),
                              SizedBox(width: sizeConstants.spacing4),
                              Flexible(
                                child: Text('نرخ فروش:', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: sizeConstants.spacing8),
                        Flexible(child: Text('${item.newRate} ؋', maxLines: 1, textDirection: TextDirection.ltr)),
                      ],
                    ),
                  ),
                  if (item.description != null && item.description!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long_outlined, size: 18.r),
                              SizedBox(width: sizeConstants.spacing4),
                              Flexible(
                                child: Text('توضیحات:', overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge),
                              ),
                            ],
                          ),
                          SizedBox(height: sizeConstants.spacing2),
                          Flexible(child: Text(item.description!, maxLines: 1, textDirection: TextDirection.ltr)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
