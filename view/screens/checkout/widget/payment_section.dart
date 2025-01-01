import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/screens/checkout/widget/payment_method_bottom_sheet.dart';

class PaymentSection extends StatelessWidget {
  final int? storeId;
  final bool isCashOnDeliveryActive;
  final bool isDigitalPaymentActive;
  final bool isWalletActive;
  final double total;
  final OrderController orderController;
  const PaymentSection({
    Key? key,
    this.storeId,
    required this.isCashOnDeliveryActive,
    required this.isDigitalPaymentActive,
    required this.isWalletActive,
    required this.total,
    required this.orderController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: []),
      !ResponsiveHelper.isDesktop(context)
          ? const Divider()
          : const SizedBox(height: Dimensions.paddingSizeSmall),
      Container(
        decoration: ResponsiveHelper.isDesktop(context)
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Theme.of(context).cardColor,
                border: Border.all(
                    color: Theme.of(context).disabledColor.withOpacity(0.3),
                    width: 1),
              )
            : const BoxDecoration(),
        padding: ResponsiveHelper.isDesktop(context)
            ? const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeSmall,
                horizontal: Dimensions.radiusDefault)
            : EdgeInsets.zero,
        child: storeId != null
            ? orderController.paymentMethodIndex == 0
                ? Row(children: [
                    Image.asset(
                      Images.cash,
                      width: 20,
                      height: 20,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text(
                      PriceConverter.convertPrice(total),
                      textDirection: TextDirection.ltr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).primaryColor),
                    )
                  ])
                : const SizedBox()
            : InkWell(
                onTap: () {
                  if (ResponsiveHelper.isDesktop(context) &&
                      orderController.paymentMethodIndex == -1) {
                    Get.dialog(Dialog(
                        backgroundColor: Colors.transparent,
                        child: PaymentMethodBottomSheet(
                          isCashOnDeliveryActive: isCashOnDeliveryActive,
                          isDigitalPaymentActive: isDigitalPaymentActive,
                          isWalletActive: isWalletActive,
                          storeId: storeId,
                          totalPrice: total,
                        )));
                  }
                },
                child: Row(children: [
                  orderController.paymentMethodIndex != -1
                      ? Image.asset(
                          orderController.paymentMethodIndex == 0
                              ? Images.cash
                              : orderController.paymentMethodIndex == 1
                                  ? Images.wallet
                                  : Images.digitalPayment,
                          width: 20,
                          height: 20,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        )
                      : const SizedBox(width: Dimensions.paddingSizeSmall),

                  orderController.paymentMethodIndex != -1
                      ? PriceConverter.convertAnimationPrice(
                          orderController.viewTotalPrice,
                          textStyle: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).primaryColor),
                        )
                      : const SizedBox(),
                  // Text(
                  //   PriceConverter.convertPrice(total), textDirection: TextDirection.ltr,
                  //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                  // ),
                  SizedBox(
                      width: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.paddingSizeSmall
                          : 0),

                  storeId == null && ResponsiveHelper.isDesktop(context)
                      ? InkWell(
                          onTap: () {
                            Get.dialog(Dialog(
                                backgroundColor: Colors.transparent,
                                child: PaymentMethodBottomSheet(
                                  isCashOnDeliveryActive:
                                      isCashOnDeliveryActive,
                                  isDigitalPaymentActive:
                                      isDigitalPaymentActive,
                                  isWalletActive: isWalletActive,
                                  storeId: storeId,
                                  totalPrice: total,
                                )));
                          },
                          child: Image.asset(Images.paymentSelect,
                              height: 24, width: 24),
                        )
                      : const SizedBox(),
                ]),
              ),
      ),
    ]);
  }
}

class CustommButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double height;
  final double width;
  final Color buttonColor;

  const CustommButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.height = 24,
    this.width = 24,
    this.buttonColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
        child: child,
      ),
    );
  }
}
