import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/features/data/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/models/product_form_model.dart';
import 'package:valura/features/data/notifiers/add_item_notifier.dart';
import 'package:valura/features/data/providers/add_item_provider.dart';
import 'package:valura/features/data/providers/app_provider.dart';
import 'package:valura/features/screens/main_screens/add_item_screen/widgets/item_part_card.dart';
import 'package:valura/features/screens/main_screens/edit_item_screen/edit_item_screen.dart';
import 'package:valura/helpers/popup_helpers.dart';
import 'package:valura/packages/dropdown_search_package/dropdown_search_package.dart';
import 'package:valura/packages/sqflite_package/sqflite_package.dart';
import 'package:valura/packages/sqflite_package/sqflite_queries.dart';
import 'package:valura/packages/toast_package/toast_package.dart';
import 'package:valura/utils/dependency_injection.dart';
import 'package:valura/utils/size_constant.dart';
import 'package:valura/widgets/custom_aligned_grid_view.dart';
import 'package:valura/widgets/custom_appbar.dart';
import 'package:valura/widgets/loading_cover.dart';

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
          context.read<AddItemProvider>().clearItems();
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
                      return CustomAlignedGridView(
                        crossAxisCount: 1,
                        length: addedItems.length,
                        itemBuilder: (context, index) {
                          final item = addedItems[index];
                          return ItemPartCard(
                            onDeleteTap: (slideContext) {
                              try {
                                PopupHelpers.showYesOrNoDialog(
                                  context: context,
                                  title: 'آیتم را حذف میکنید؟',
                                  onYesTap: (bCtx) {
                                    try {
                                      context.read<AddItemProvider>().removeItemAt(index);
                                      bCtx.pop();
                                      setState(() {});
                                    } catch (_) {}
                                  },
                                );
                              } catch (_) {}
                            },
                            onEditTap: (context) {
                              try {
                                context.push(EditItemScreen.id, extra: {'item_model': item});
                              } catch (_) {}
                            },
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
                child: LoadingCover(),
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
    if (items.isEmpty) {
      ToastPackage.showSimpleToast(context: context, message: 'حداقل یک جنس را باید انتخاب کنید.');
      return;
    }
    num total = context.read<AddItemProvider>().total;
    List<int> itemIds = [];
    List<String> names = [];
    List<num> purchaseRates = [];
    List<num> landCosts = [];
    List<num> costs = [];
    List<num> newRates = [];
    List<String?> descriptions = [];
    for (var item in items) {
      itemIds.add(item.itemId);
      names.add(item.name);
      purchaseRates.add(item.purchaseRate);
      landCosts.add(item.landCost);
      costs.add(item.unitCost);
      newRates.add(item.newRate);
      descriptions.add(item.description);
    }
    final product = ProductFormModel(
      itemIds: itemIds,
      name: 'تولید',
      total: total,
      names: names,
      purchaseRates: purchaseRates,
      landCosts: landCosts,
      costs: costs,
      newRates: newRates,
      descriptions: descriptions,
    );
    context.read<CreateItemBloc>().add(CreateProduct(product: product));
  } catch (_) {}
}
