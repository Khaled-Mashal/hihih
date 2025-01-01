import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';

class ItemShimmerV2 extends StatelessWidget {
  final bool isEnabled;
  final bool isStore;
  final bool hasDivider;
  const ItemShimmerV2(
      {Key? key,
      required this.isEnabled,
      required this.hasDivider,
      this.isStore = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool desktop = ResponsiveHelper.isDesktop(context);

    return Padding(
      padding:
          const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
      child: Container(
        height: 220,
        width: 180,
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: [
            BoxShadow(
              color: Colors
                  .grey[Get.find<ThemeController>().darkTheme ? 700 : 300]!,
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: true,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children: [
                  Container(
                    height: 125,
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(Dimensions.radiusSmall)),
                      color: Colors.grey[300],
                    ),
                  ),
                  Positioned(
                    top: Dimensions.paddingSizeExtraSmall,
                    right: Dimensions.paddingSizeExtraSmall,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.8),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Row(children: [
                        Icon(Icons.star,
                            color: Theme.of(context).primaryColor, size: 15),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text('0.0', style: robotoRegular),
                      ]),
                    ),
                  ),
                ]),
                Expanded(
                  child: Stack(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                                height: 15,
                                width: 100,
                                color: Colors.grey[300]),
                            const SizedBox(height: 2),
                            Container(
                                height: 10, width: 70, color: Colors.grey[300]),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      height: 10,
                                      width: 40,
                                      color: Colors.grey[300]),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Container(
                                      height: 15,
                                      width: 40,
                                      color: Colors.grey[300]),
                                ]),
                          ]),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor),
                          child: const Icon(Icons.add,
                              size: 20, color: Colors.white),
                        )),
                  ]),
                ),
              ]),
        ),
      ),
    );
  }
}
