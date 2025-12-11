import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/features/data/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/models/product_form_model.dart';
import 'package:valura/features/data/notifiers/add_item_notifier.dart';
import 'package:valura/features/data/providers/add_item_provider.dart';
import 'package:valura/features/data/providers/app_provider.dart';
import 'package:valura/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:valura/helpers/popup_helpers.dart';
import 'package:valura/packages/dropdown_search_package/dropdown_search_package.dart';
import 'package:valura/packages/sqflite_package/sqflite_package.dart';
import 'package:valura/packages/sqflite_package/sqflite_queries.dart';
import 'package:valura/packages/toast_package/toast_package.dart';
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
    return BlocConsumer<CreateItemBloc, CreateItemState>(
      listener: (context, state) {
        if (state is CreateProductFailure) {
          ToastPackage.showSimpleToast(context: context, message: state.errorMessage);
        } else if (state is CreateProductSuccess) {
          ToastPackage.showSimpleToast(context: context, message: 'ذخیره شد');
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Column(
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
                              _submitProduct(context);
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
                      child: Selector<AddItemProvider, num>(
                        selector: (context, addItemProvider) => addItemProvider.total,
                        builder: (context, total, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('جمع کل:'),
                              Flexible(
                                child: Text(
                                  '$total ؋',
                                  textDirection: TextDirection.ltr,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        },
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
                        padding: EdgeInsets.fromLTRB(
                          sizeConstants.spacing16,
                          sizeConstants.spacing12,
                          sizeConstants.spacing16,
                          sizeConstants.spacing20,
                        ),
                        physics: BouncingScrollPhysics(),
                        itemCount: addedItems.length,
                        crossAxisCount: 1,
                        crossAxisSpacing: sizeConstants.spacing12,
                        mainAxisSpacing: sizeConstants.spacing12,
                        itemBuilder: (context, index) {
                          final item = addedItems[index];
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
                                      onPressed: (context) {
                                        try {} catch (_) {}
                                      },
                                      backgroundColor: kBlueColor,
                                      foregroundColor: kWhiteColor,
                                      icon: Icons.edit_note_rounded,
                                      label: 'ویرایش',
                                    ),
                                    SlidableAction(
                                      flex: 2,
                                      onPressed: (slideContext) {
                                        try {
                                          PopupHelpers.showYesOrNoDialog(
                                            context: context,
                                            title: 'آیتم را حذف میکنید؟',
                                            onYesTap: () {
                                              try {
                                                context.read<AddItemProvider>().removeItemAt(index);
                                                context.pop();
                                                setState(() {});
                                              } catch (_) {}
                                            },
                                          );
                                        } catch (_) {}
                                      },
                                      backgroundColor: kRedColor,
                                      foregroundColor: kWhiteColor,
                                      icon: Icons.delete,
                                      label: 'حذف',
                                    ),
                                  ],
                                ),
                                child: ItemPartCard(
                                  item: ItemModel(
                                    id: item.id,
                                    itemId: item.itemId,
                                    purchaseRate: item.purchaseRate,
                                    description: item.description,
                                    name: item.name,
                                    unitCost: item.unitCost,
                                    landCost: item.landCost,
                                    newRate: item.newRate,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            if (state is CreatingProduct)
              Positioned.fill(
                child: Container(
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
                ),
              ),
          ],
        );
      },
    );
  }
}

_submitProduct(BuildContext context) {
  try {
    List<ItemModel> items = context.read<AddItemProvider>().addedItems;
    num total = context.read<AddItemProvider>().total;
    List<String> names = [];
    List<num> purchaseRates = [];
    List<num> landCosts = [];
    List<num> costs = [];
    List<num> newRates = [];
    for (var item in items) {
      names.add(item.name);
      purchaseRates.add(item.purchaseRate);
      landCosts.add(item.landCost);
      costs.add(item.unitCost);
      newRates.add(item.newRate);
    }
    final product = ProductFormModel(
      name: 'تولید',
      total: total,
      names: names,
      purchaseRates: purchaseRates,
      landCosts: landCosts,
      costs: costs,
      newRates: newRates,
    );
    context.read<CreateItemBloc>().add(CreateProduct(product: product));
  } catch (_) {}
}

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

class ItemPartCard extends StatelessWidget {
  const ItemPartCard({super.key, required this.item});
  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: sizeConstants.spacing12),
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
        ],
      ),
    );
  }
}
