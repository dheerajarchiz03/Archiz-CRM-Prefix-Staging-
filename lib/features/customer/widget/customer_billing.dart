import 'package:archiz_staging_admin/common/components/card/custom_card.dart';
import 'package:archiz_staging_admin/common/components/divider/custom_divider.dart';
import 'package:archiz_staging_admin/core/utils/dimensions.dart';
import 'package:archiz_staging_admin/core/utils/local_strings.dart';
import 'package:archiz_staging_admin/core/utils/style.dart';
import 'package:archiz_staging_admin/features/customer/model/customer_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerBilling extends StatelessWidget {
  const CustomerBilling({
    super.key,
    required this.customerModel,
  });
  final Customer customerModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.space10),
      child: Column(
        children: [
          CustomCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.billingAddress.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(customerModel.address ?? '-'),
                  ],
                ),
                const CustomDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.city.tr, style: lightSmall),
                    Text(LocalStrings.state.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(customerModel.billingCity ?? '-'),
                    Text(customerModel.billingState ?? '-'),
                  ],
                ),
                const CustomDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.zipCode.tr, style: lightSmall),
                    Text(LocalStrings.country.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(customerModel.billingZip ?? '-'),
                    Text(customerModel.billingCountry ?? '-'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomCard(
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocalStrings.shippingAddress.tr,
                            style: lightSmall),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(customerModel.address ?? '-'),
                      ],
                    ),
                  ],
                ),
                const CustomDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.city.tr, style: lightSmall),
                    Text(LocalStrings.state.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(customerModel.shippingCity ?? '-'),
                    Text(customerModel.shippingState ?? '-'),
                  ],
                ),
                const CustomDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(LocalStrings.zipCode.tr, style: lightSmall),
                    Text(LocalStrings.country.tr, style: lightSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(customerModel.shippingZip ?? '-'),
                    Text(customerModel.shippingCountry ?? '-'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
