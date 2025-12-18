import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/features/data/blocs/edit_item_bloc/edit_item_bloc.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/data/providers/add_item_provider.dart';
import 'package:valura/features/screens/main_screens/items_screen/items_screen.dart';
import 'package:valura/helpers/number_formatters.dart';
import 'package:valura/helpers/popup_helpers.dart';
import 'package:valura/packages/sqflite_package/sqflite_codes.dart';
import 'package:valura/packages/toast_package/toast_package.dart';
import 'package:valura/utils/size_constant.dart';
import 'package:valura/widgets/custom_appbar.dart';
import 'package:valura/widgets/custom_text_field.dart';
import 'package:valura/widgets/loading_cover.dart';
import 'package:valura/widgets/title_with_dropdown.dart';

class EditItemScreen extends StatefulWidget {
  static const String id = '/edit_item_screen';
  static const String name = 'edit_item_screen';
  final ItemModel? itemModel;
  final int? pId;
  final String? route;
  const EditItemScreen({super.key, this.itemModel, this.pId, this.route});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController nameController;
  late TextEditingController purchaseRateController;
  late TextEditingController landingExpenseController;
  late TextEditingController unitCostController;
  late TextEditingController newRateController;
  late TextEditingController descController;
  late GlobalKey<FormState> formKey;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    purchaseRateController = TextEditingController();
    landingExpenseController = TextEditingController();
    unitCostController = TextEditingController();
    descController = TextEditingController();
    newRateController = TextEditingController();
    if (widget.route == ItemsScreen.id) {
      context.read<EditItemBloc>().add(EditItem(id: widget.itemModel!.id));
    } else {
      if (widget.pId == null) {
        if (widget.itemModel != null) {
          ItemModel item = widget.itemModel!;
          String desc = item.description ?? '';
          nameController.text = item.name;
          purchaseRateController.text = '${item.purchaseRate}';
          landingExpenseController.text = '${item.landCost}';
          unitCostController.text = '${item.unitCost}';
          descController.text = desc;
          newRateController.text = '${item.newRate}';
        } else {
          HapticFeedback.heavyImpact();
        }
      } else {
        if (widget.pId != null && widget.itemModel != null) {
          context.read<EditItemBloc>().add(EditProductDetails(id: widget.itemModel!.id));
        } else {
          HapticFeedback.heavyImpact();
        }
      }
    }

    formKey = GlobalKey<FormState>();
  }

  dynamic editState;

  @override
  void dispose() {
    nameController.dispose();
    purchaseRateController.dispose();
    landingExpenseController.dispose();
    unitCostController.dispose();
    descController.dispose();
    newRateController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditItemBloc, EditItemState>(
      listener: (context, state) {
        if (state is EditingItem) {
          editState = state;
        } else if (state is EditItemFailure) {
          editState = state;
          ToastPackage.showSimpleToast(context: context, message: getErrorMessage(state.errorMessage));
        } else if (state is EditItemSuccess) {
          editState = state;
          if (state.item == null) {
            ToastPackage.showSimpleToast(context: context, message: 'جنس یافت نشد');
          } else {
            ItemModel item = state.item!;
            String desc = item.description ?? '';
            nameController.text = item.name;
            purchaseRateController.text = '${item.purchaseRate}';
            landingExpenseController.text = '${item.landCost}';
            unitCostController.text = '${item.unitCost}';
            descController.text = desc;
            newRateController.text = '${item.newRate}';
          }
        } else if (state is UpdateProductDetailsSuccess) {
          ToastPackage.showSimpleToast(context: context, message: 'ویرایش انجام شد');
          context.pop();
        } else if (state is UpdateProductDetailsFailure) {
          ToastPackage.showSimpleToast(context: context, message: getErrorMessage(state.errorMessage));
        } else if (state is UpdateItemSuccess) {
          ToastPackage.showSimpleToast(context: context, message: 'ویرایش انجام شد');
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted && context.mounted) {
              context.pop();
            }
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAppbar(title: 'ویرایش جنس', showBackBtn: true),
              Expanded(
                child: Stack(
                  children: [
                    Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: sizeConstants.spacing12),
                            ValueListenableBuilder(
                              valueListenable: nameController,
                              builder: (context, value, child) {
                                return TitleWithDropdown(
                                  title: 'نام جنس',
                                  titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                                  isRequired: true,
                                  child: CustomTextFormField(
                                    controller: nameController,
                                    hintText: 'نام جنس را وارد کنید',
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'فیلد ضروری';
                                      }
                                      return null;
                                    },
                                    onClearTap: () {
                                      try {
                                        nameController.clear();
                                      } catch (_) {}
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: sizeConstants.spacing12),
                            ValueListenableBuilder(
                              valueListenable: purchaseRateController,
                              builder: (context, value, child) {
                                return TitleWithDropdown(
                                  title: 'نرخ خرید',
                                  isRequired: true,
                                  titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                                  child: CustomTextFormField(
                                    controller: purchaseRateController,
                                    hintText: 'نرخ خرید را وارد کنید',
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'فیلد ضروری';
                                      }
                                      return null;
                                    },
                                    onClearTap: () {
                                      try {
                                        purchaseRateController.clear();
                                      } catch (_) {}
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: sizeConstants.spacing12),
                            ValueListenableBuilder(
                              valueListenable: landingExpenseController,
                              builder: (context, value, child) {
                                return TitleWithDropdown(
                                  title: 'مقدار مصرف',
                                  isRequired: true,
                                  titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                                  child: CustomTextFormField(
                                    controller: landingExpenseController,
                                    hintText: 'مقدار مصرف را وارد کنید',
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'فیلد ضروری';
                                      }
                                      return null;
                                    },
                                    onClearTap: () {
                                      try {
                                        landingExpenseController.clear();
                                      } catch (_) {}
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: sizeConstants.spacing12),
                            ValueListenableBuilder(
                              valueListenable: unitCostController,
                              builder: (context, value, child) {
                                return TitleWithDropdown(
                                  title: 'قیمت',
                                  isRequired: true,
                                  titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                                  child: CustomTextFormField(
                                    controller: unitCostController,
                                    hintText: 'قیمت را وارد کنید',
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'فیلد ضروری';
                                      }
                                      return null;
                                    },
                                    onClearTap: () {
                                      try {
                                        unitCostController.clear();
                                      } catch (_) {}
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: sizeConstants.spacing12),
                            ValueListenableBuilder(
                              valueListenable: newRateController,
                              builder: (context, value, child) {
                                return TitleWithDropdown(
                                  title: 'نرخ فروش',
                                  isRequired: true,
                                  titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                                  child: CustomTextFormField(
                                    controller: newRateController,
                                    hintText: 'نرخ فروش را وارد کنید',
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'فیلد ضروری';
                                      }
                                      return null;
                                    },
                                    onClearTap: () {
                                      try {
                                        newRateController.clear();
                                      } catch (_) {}
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: sizeConstants.spacing12),
                            ValueListenableBuilder(
                              valueListenable: descController,
                              builder: (context, value, child) {
                                return TitleWithDropdown(
                                  title: 'توضیحات',
                                  titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                                  child: CustomTextFormField(
                                    controller: descController,
                                    isDescription: true,
                                    hintText: 'توضیحات را وارد کنید',
                                    onClearTap: () {
                                      try {
                                        descController.clear();
                                      } catch (_) {}
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: sizeConstants.avatarXLarge),
                          ],
                        ),
                      ),
                    ),
                    if (editState is EditingItem || editState is UpdatingItem || editState is UpdatingProductDetails)
                      Positioned.fill(child: LoadingCover()),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: editState is! EditingItem
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      heroTag: 'submit',
                      isExtended: true,
                      label: Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: sizeConstants.spacing56),
                        child: Text(
                          'ذخیره',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        try {
                          if (formKey.currentState?.validate() == true) {
                            ItemModel item = ItemModel(
                              id: widget.itemModel!.id,
                              itemId: widget.itemModel!.itemId,
                              purchaseRate: num.tryParse(NumberFormatters.toEnglishDigits(purchaseRateController.text.trim())) ?? 0,
                              name: nameController.text.trim(),
                              unitCost: num.tryParse(NumberFormatters.toEnglishDigits(unitCostController.text.trim())) ?? 0,
                              landCost: num.tryParse(NumberFormatters.toEnglishDigits(landingExpenseController.text.trim())) ?? 0,
                              newRate: num.tryParse(NumberFormatters.toEnglishDigits(newRateController.text.trim())) ?? 0,
                              description: descController.text.trim(),
                            );
                            PopupHelpers.showYesOrNoDialog(
                              context: context,
                              title: 'فرم را ذخیره میکنید؟',
                              onYesTap: (bCtx) {
                                if (widget.itemModel != null && widget.pId == null && widget.route != ItemsScreen.id) {
                                  List<ItemModel> items = context.read<AddItemProvider>().addedItems;
                                  items.removeWhere((element) => element.id == widget.itemModel!.id);
                                  context.read<AddItemProvider>().addItem(item);
                                  bCtx.pop();
                                  context.pop();
                                } else {
                                  if (widget.route == ItemsScreen.id) {
                                    context.read<EditItemBloc>().add(UpdateItem(item: item));
                                  } else {
                                    context.read<EditItemBloc>().add(UpdateProductDetails(item: item, pId: widget.pId!));
                                  }
                                  bCtx.pop();
                                }
                              },
                            );
                          } else {
                            HapticFeedback.heavyImpact();
                          }
                        } catch (_) {}
                      },
                    ),
                    SizedBox(width: sizeConstants.spacing4),
                    FloatingActionButton(
                      backgroundColor: kRedColor,
                      heroTag: 'clear',
                      child: Icon(Icons.delete),
                      onPressed: () {
                        try {
                          nameController.clear();
                          purchaseRateController.clear();
                          landingExpenseController.clear();
                          unitCostController.clear();
                          descController.clear();
                        } catch (_) {}
                      },
                    ),
                  ],
                )
              : null,
        );
      },
    );
    // Scaffold(
    //   body: ,
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //   floatingActionButton: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       FloatingActionButton.extended(
    //         heroTag: 'submit',
    //         isExtended: true,
    //         label: Padding(
    //           padding: EdgeInsetsGeometry.symmetric(horizontal: sizeConstants.spacing56),
    //           child: Text(
    //             'ثبت',
    //             style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
    //           ),
    //         ),
    //         onPressed: () {
    //           try {
    //             if (formKey.currentState?.validate() == true) {
    //               ItemModel item = ItemModel(
    //                 name: nameController.text.trim(),
    //                 cost: num.tryParse(costController.text.trim()) ?? 0,
    //                 landCost: num.tryParse(landingExpenseController.text.trim()) ?? 0,
    //                 newRate: num.tryParse(newRateController.text.trim()) ?? 0,
    //                 description: descController.text.trim(),
    //               );
    //             } else {
    //               HapticFeedback.heavyImpact();
    //             }
    //           } catch (_) {}
    //         },
    //       ),
    //       SizedBox(width: sizeConstants.spacing4),
    //       FloatingActionButton(
    //         backgroundColor: kRedColor,
    //         heroTag: 'clear',
    //         child: Icon(Icons.delete),
    //         onPressed: () {
    //           try {
    //             nameController.clear();
    //             costController.clear();
    //             landingExpenseController.clear();
    //             newRateController.clear();
    //             descController.clear();
    //           } catch (_) {}
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}
