import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/features/data/models/item_model.dart';
import 'package:valura/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:valura/utils/size_constant.dart';

class CreateItemScreen extends StatefulWidget {
  static const String id = '/create_item_screen';
  static const String name = 'create_item_screen';
  const CreateItemScreen({super.key});

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  late TextEditingController nameController;
  late TextEditingController costController;
  late TextEditingController landingExpenseController;
  late TextEditingController newRateController;
  late TextEditingController descController;
  late GlobalKey<FormState> formKey;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    costController = TextEditingController();
    landingExpenseController = TextEditingController();
    newRateController = TextEditingController();
    descController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    nameController.dispose();
    costController.dispose();
    landingExpenseController.dispose();
    newRateController.dispose();
    descController.dispose();
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
          child: Form(
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
                    valueListenable: costController,
                    builder: (context, value, child) {
                      return TitleWithDropdown(
                        title: 'نرخ خرید',
                        isRequired: true,
                        titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                        child: CustomTextFormField(
                          controller: costController,
                          hintText: 'نرخ خرید را وارد کنید',
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'فیلد ضروری';
                            }
                            return null;
                          },
                          onClearTap: () {
                            try {
                              costController.clear();
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
                    valueListenable: newRateController,
                    builder: (context, value, child) {
                      return TitleWithDropdown(
                        title: 'قیمت',
                        isRequired: true,
                        titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                        child: CustomTextFormField(
                          controller: newRateController,
                          hintText: 'قیمت را وارد کنید',
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
                  SizedBox(height: sizeConstants.spacing24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: 'submit',
                        isExtended: true,
                        label: Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: sizeConstants.spacing56),
                          child: Text(
                            'ثبت',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () {
                          try {
                            if (formKey.currentState?.validate() == true) {
                              ItemModel item = ItemModel(
                                name: nameController.text.trim(),
                                cost: num.tryParse(costController.text.trim()) ?? 0,
                                landCost: num.tryParse(landingExpenseController.text.trim()) ?? 0,
                                newRate: num.tryParse(newRateController.text.trim()) ?? 0,
                                description: descController.text.trim(),
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
                            costController.clear();
                            landingExpenseController.clear();
                            newRateController.clear();
                            descController.clear();
                          } catch (_) {}
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: sizeConstants.spacing24),
                ],
              ),
            ),
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

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.keybaordType,
    this.textInputAction,
    this.hintText,
    this.labelText,
    this.onClearTap,
    this.maxLines = 1,
    this.isDescription = false,
  });

  final TextEditingController? controller;
  final String? Function(String? text)? validator;
  final void Function(String? text)? onChanged;
  final int maxLines;
  final TextInputType? keybaordType;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? labelText;
  final Function()? onClearTap;
  final bool isDescription;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: isDescription ? 5 : maxLines,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keybaordType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kRedColor),
        ),
        focusedErrorBorder: OutlineInputBorder(),
        suffixIcon: controller?.text.isEmpty == true
            ? null
            : GestureDetector(
                onTap: onClearTap,
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sizeConstants.radiusSmall),
                    color: Theme.of(context).primaryColor.withAlpha(30),
                  ),
                  child: Icon(Icons.clear, color: kRedColor),
                ),
              ),
      ),
    );
  }
}

// TitleWithDropdown(
//             title: 'نام جنس',
//             child: DropdownSearchPackage.dropdownSearch<ItemModel>(
//               dropdownBuilder: (context, item) {
//                 return Text(item?.name ?? '');
//               },
//               itemAsString: (item) => item.name,
//               itemBuilder: (context, item, isDisabled, isSelected) {
//                 return Container(
//                   margin: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16),
//                   padding: EdgeInsetsGeometry.symmetric(vertical: sizeConstants.spacing12),
//                   decoration: BoxDecoration(
//                     border: BoxBorder.fromLTRB(
//                       bottom: BorderSide(color: Theme.of(context).primaryColor.withAlpha(50)),
//                     ),
//                   ),
//                   child: Text(item.name),
//                 );
//               },
//               items: (filter, loadProps) => [
//                 ItemModel(name: 'name1', cost: 0, landCost: 0, newRate: 0),
//                 ItemModel(name: 'name2', cost: 0, landCost: 0, newRate: 0),
//                 ItemModel(name: 'name3', cost: 0, landCost: 0, newRate: 0),
//                 ItemModel(name: 'name4', cost: 0, landCost: 0, newRate: 0),
//                 ItemModel(name: 'name5', cost: 0, landCost: 0, newRate: 0),
//               ],
//               onChanged: (item) {},
//               showSearchBox: true,
//               validator: (item) {
//                 return null;
//               },
//             ),
//           ),

class TitleWithDropdown extends StatelessWidget {
  const TitleWithDropdown({
    super.key,
    required this.title,
    required this.child,
    required this.titleStyle,
    this.isRequired = false,
  });
  final String title;
  final Widget child;
  final TextStyle titleStyle;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: sizeConstants.spacing12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: title,
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: isRequired ? ' *' : '',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kRedColor),
                ),
              ],
            ),
          ),
          SizedBox(height: sizeConstants.spacing8),
          child,
        ],
      ),
    );
  }
}
