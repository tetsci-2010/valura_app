import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/features/data/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/helpers/number_formatters.dart';
import 'package:valura/helpers/popup_helpers.dart';
import 'package:valura/packages/sqflite_package/sqflite_codes.dart';
import 'package:valura/packages/toast_package/toast_package.dart';
import 'package:valura/utils/size_constant.dart';
import 'package:valura/widgets/custom_appbar.dart';
import 'package:valura/widgets/custom_text_field.dart';
import 'package:valura/widgets/title_with_dropdown.dart';

class CreateItemScreen extends StatefulWidget {
  static const String id = '/create_item_screen';
  static const String name = 'create_item_screen';
  const CreateItemScreen({super.key});

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
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
    formKey = GlobalKey<FormState>();
  }

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomAppbar(title: 'ثبت جنس'),
        Expanded(
          child: BlocConsumer<CreateItemBloc, CreateItemState>(
            listener: (context, state) {
              if (state is CreateItemSuccess) {
                ToastPackage.showSimpleToast(context: context, message: 'جنس ثبت شد');
                nameController.clear();
                unitCostController.clear();
                purchaseRateController.clear();
                landingExpenseController.clear();
                unitCostController.clear();
                newRateController.clear();
                descController.clear();
              } else if (state is CreateItemFailure) {
                ToastPackage.showSimpleToast(context: context, message: getErrorMessage(state.errorMessage));
              }
            },
            builder: (context, state) {
              return Form(
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
                              readOnly: state is CreatingItem,
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
                              readOnly: state is CreatingItem,
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
                              readOnly: state is CreatingItem,
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
                              readOnly: state is CreatingItem,
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
                              readOnly: state is CreatingItem,
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
                              readOnly: state is CreatingItem,
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
                      SizedBox(height: sizeConstants.spacing24),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton.extended(
                            heroTag: 'submit',
                            isExtended: true,
                            label: Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: sizeConstants.spacing56),
                              child: state is CreatingItem
                                  ? CupertinoActivityIndicator(color: kWhiteColor)
                                  : Text(
                                      'ثبت',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
                                    ),
                            ),
                            onPressed: () {
                              try {
                                if (formKey.currentState?.validate() == true) {
                                  ItemModel item = ItemModel(
                                    id: 0,
                                    itemId: 0,
                                    purchaseRate: num.tryParse(NumberFormatters.toEnglishDigits(purchaseRateController.text.trim())) ?? 0,
                                    name: nameController.text.trim(),
                                    unitCost: num.tryParse(NumberFormatters.toEnglishDigits(unitCostController.text.trim())) ?? 0,
                                    landCost: num.tryParse(NumberFormatters.toEnglishDigits(landingExpenseController.text.trim())) ?? 0,
                                    newRate: num.tryParse(NumberFormatters.toEnglishDigits(newRateController.text.trim())) ?? 0,
                                    description: descController.text.trim(),
                                  );
                                  PopupHelpers.showYesOrNoDialog(
                                    context: context,
                                    title: 'فرم را ثبت میکنید؟',
                                    onYesTap: (bCtx) {
                                      context.read<CreateItemBloc>().add(CreateItem(itemModel: item));
                                      bCtx.pop();
                                    },
                                  );
                                } else {
                                  HapticFeedback.heavyImpact();
                                }
                              } catch (_) {}
                            },
                          ),
                          if (state is! CreatingItem) SizedBox(width: sizeConstants.spacing4),
                          if (state is! CreatingItem)
                            FloatingActionButton(
                              backgroundColor: kRedColor,
                              heroTag: 'clear',
                              child: Icon(Icons.delete),
                              onPressed: () {
                                try {
                                  PopupHelpers.showYesOrNoDialog(
                                    context: context,
                                    title: 'فرم را پاک میکنید؟',
                                    onYesTap: (bCtx) {
                                      nameController.clear();
                                      purchaseRateController.clear();
                                      landingExpenseController.clear();
                                      unitCostController.clear();
                                      descController.clear();
                                      bCtx.pop();
                                    },
                                  );
                                } catch (_) {}
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: sizeConstants.spacing24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
