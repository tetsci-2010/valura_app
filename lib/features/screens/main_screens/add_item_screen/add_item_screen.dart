import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:valura/packages/dropdown_search_package/dropdown_search_package.dart';
import 'package:valura/utils/size_constant.dart';

class AddItemScreen extends StatelessWidget {
  static const String id = '/add_item_screen';
  static const String name = 'add_item_screen';
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAppbar(title: 'افزودن جنس'),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: sizeConstants.spacing16, vertical: sizeConstants.spacing12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: DropdownSearchPackage.dropdownSearch<ItemModel>(
                      itemAsString: (item) => item.name,
                      items: (filter, loadProps) => [
                        ItemModel(name: 'name', cost: 0, landCost: 0, newRate: 0),
                        ItemModel(name: 'name1', cost: 0, landCost: 0, newRate: 0),
                        ItemModel(name: 'name2', cost: 0, landCost: 0, newRate: 0),
                        ItemModel(name: 'name3', cost: 0, landCost: 0, newRate: 0),
                        ItemModel(name: 'name4', cost: 0, landCost: 0, newRate: 0),
                      ],
                      showSearchBox: true,
                    ),
                  ),
                  SizedBox(width: sizeConstants.spacing12),
                  GestureDetector(
                    onTap: () {
                      try {} catch (_) {}
                    },
                    child: Container(
                      width: sizeConstants.iconLarge,
                      padding: EdgeInsets.symmetric(vertical: sizeConstants.spacing12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Transform.flip(flipX: true, child: Icon(Icons.send_and_archive_rounded, color: kWhiteColor)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: AlignedGridView.count(
            padding: EdgeInsets.fromLTRB(sizeConstants.spacing16, sizeConstants.spacing12, sizeConstants.spacing16, sizeConstants.spacing20),
            physics: BouncingScrollPhysics(),
            itemCount: 10,
            crossAxisCount: 1,
            crossAxisSpacing: sizeConstants.spacing12,
            mainAxisSpacing: sizeConstants.spacing12,
            itemBuilder: (context, index) {
              return ItemPartCard(
                item: ItemModel(name: 'تیغه ۱۴ میلی متری برنجی', cost: 10, landCost: 12, newRate: 15),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ItemPartCard extends StatelessWidget {
  const ItemPartCard({super.key, required this.item});
  final ItemModel item;

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
            color: kBlackColor12.withAlpha(20),
            blurRadius: 7,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          Row(
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
              Flexible(child: Text('${item.cost} ؋', maxLines: 1, textDirection: TextDirection.ltr)),
            ],
          ),
          Row(
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
          Row(
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
              Flexible(child: Text('${item.cost} ؋', maxLines: 1, textDirection: TextDirection.ltr)),
            ],
          ),
          Row(
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
        ],
      ),
    );
  }
}
