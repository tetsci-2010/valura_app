import 'package:flutter/material.dart';
import 'package:valura/constants/colors.dart';
import 'package:valura/utils/size_constant.dart';

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
    this.readOnly = false,
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
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: isDescription ? 5 : maxLines,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keybaordType,
      textInputAction: textInputAction,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor.withAlpha(150) : kGreyColor500,
        ),
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
