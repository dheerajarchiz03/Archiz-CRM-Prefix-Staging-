import 'package:date_field/date_field.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:flutter/material.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:get/get.dart';

class CustomDateFormField extends StatelessWidget {
  final String labelText;
  final Function(DateTime? value) onChanged;
  final DateTime? initialValue;

  const CustomDateFormField(
      {super.key,
      required this.labelText,
      required this.onChanged,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return DateTimeFormField(
        decoration: InputDecoration(
          focusColor: Colors.red,
          contentPadding:
              const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
          labelText: labelText,
          labelStyle:
              regularDefault.copyWith(color: Theme.of(context).hintColor),
          fillColor: Theme.of(context).cardColor,
          filled: true,
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 0.5, color: Theme.of(context).hintColor),
              borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 0.5, color: Theme.of(context).hintColor),
              borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 0.5, color: Theme.of(context).hintColor),
              borderRadius: BorderRadius.circular(Dimensions.defaultRadius)),
          suffixIcon: Icon(
            Icons.calendar_month,
            size: 25,
            color: Theme.of(context).hintColor,
          ),
        ),
        materialDatePickerOptions: MaterialDatePickerOptions(
            confirmText: LocalStrings.confirm.tr,
            cancelText: LocalStrings.cancel.tr),
        style: regularDefault.copyWith(
            color: Theme.of(context).textTheme.bodyMedium!.color),
        mode: DateTimeFieldPickerMode.date,
        autovalidateMode: AutovalidateMode.always,
        initialValue: initialValue,
        onChanged: onChanged);
  }
}
