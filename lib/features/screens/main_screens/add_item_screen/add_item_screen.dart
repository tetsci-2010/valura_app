import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/notifiers/add_item_notifier.dart';
import 'package:valura/features/data/providers/add_item_provider.dart';
import 'package:valura/features/data/providers/app_provider.dart';
import 'package:valura/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:valura/packages/dropdown_search_package/dropdown_search_package.dart';
import 'package:valura/packages/sqflite_package/sqflite_package.dart';
import 'package:valura/packages/sqflite_package/sqflite_queries.dart';
import 'package:valura/utils/dependency_injection.dart';
import 'package:valura/utils/size_constant.dart';

class AddItemScreen extends StatefulWidget {
  static const String id = '/add_item_screen';
  static const String name = 'add_item_screen';
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  @override
  void initState() {
    super.initState();
    AddItemNotifier.total = ValueNotifier(0);
  }

  @override
  void dispose() {
    AddItemNotifier.disposeTotal();
    super.dispose();
  }

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
                      onChanged: (item) {
                        if (item != null) {
                          context.read<AddItemProvider>().addItem(item);
                        }
                      },
                      itemAsString: (item) => item.name,
                      dropdownBuilder: (context, item) => Text(
                        item?.name ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      items: (filter, _) async {
                        if (filter.isEmpty) {
                          List<ItemModel> list = context.read<AppProvider>().dropDownItems;
                          if (list.isEmpty) {
                            SqflitePackage db = SqflitePackage();
                            List<Map<String, dynamic>> dbList = await db.query(table: itemsTable, limit: 50);
                            List<ItemModel> pDbList = dbList.map((e) => ItemModel.fromDB(e)).toList();
                            return pDbList;
                          } else {
                            return list;
                          }
                        }
                        // <- filter comes automatically
                        try {
                          final db = SqflitePackage();
                          List<Map<String, dynamic>> maps = await db.query(
                            table: itemsTable,
                            where: 'name LIKE ?',
                            whereArgs: ['%$filter%'],
                            limit: 50,
                          );
                          List<ItemModel> itemss = maps.map((e) => ItemModel.fromDB(e)).toList();
                          di<AppProvider>().updateDropDownItems(items: itemss);
                          return itemss;
                        } catch (e) {
                          return [];
                        }
                      },
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
            Container(
              padding: EdgeInsets.fromLTRB(
                sizeConstants.spacing20,
                sizeConstants.spacing2,
                sizeConstants.spacing20,
                sizeConstants.spacing12,
              ),
              decoration: BoxDecoration(
                border: BoxBorder.fromLTRB(bottom: BorderSide(color: Theme.of(context).primaryColor.withAlpha(100))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('جمع کل:'),
                  Flexible(
                    child: Text(
                      '۱۲۰۰ ؋',
                      textDirection: TextDirection.ltr,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: Selector<AddItemProvider, List<ItemModel>>(
            selector: (context, addItemProvider) => addItemProvider.addedItems,
            builder: (context, addedItems, child) {
              if (addedItems.isEmpty) {
                return Center(
                  child: Text('لیست خالی هست'),
                );
              }
              return AlignedGridView.count(
                padding: EdgeInsets.fromLTRB(sizeConstants.spacing16, sizeConstants.spacing12, sizeConstants.spacing16, sizeConstants.spacing20),
                physics: BouncingScrollPhysics(),
                itemCount: addedItems.length,
                crossAxisCount: 1,
                crossAxisSpacing: sizeConstants.spacing12,
                mainAxisSpacing: sizeConstants.spacing12,
                itemBuilder: (context, index) {
                  return ItemPartCard(
                    item: ItemModel(
                      id: addedItems[index].id,
                      itemId: addedItems[index].itemId,
                      purchaseRate: addedItems[index].purchaseRate,
                      description: addedItems[index].description,
                      name: addedItems[index].name,
                      unitCost: addedItems[index].unitCost,
                      landCost: addedItems[index].landCost,
                      newRate: addedItems[index].newRate,
                    ),
                  );
                },
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
            color: Theme.of(context).brightness == Brightness.light ? kBlackColor12.withAlpha(20) : kGreyColor800.withAlpha(70),
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
              Flexible(child: Text('${item.unitCost} ؋', maxLines: 1, textDirection: TextDirection.ltr)),
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
              Flexible(child: Text('${item.unitCost} ؋', maxLines: 1, textDirection: TextDirection.ltr)),
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
