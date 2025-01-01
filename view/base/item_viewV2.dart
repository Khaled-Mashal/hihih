import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/item_shimmerV2.dart';
import 'package:sixam_mart/view/base/item_widgetV2.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:sixam_mart/view/base/item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/home/theme1/store_widget.dart';
import 'package:sixam_mart/view/screens/home/web/web_store_widget.dart';

class ItemsViewV2 extends StatefulWidget {
  List<Item?>? items;
  List<Store?>? stores;
  final bool isStore;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String? noDataText;
  final bool isCampaign;
  final bool inStorePage;
  final bool isFeatured;
  final bool showTheme1Store;
  final bool isService;
  ItemsViewV2(
      {Key? key,
      required this.stores,
      required this.items,
      required this.isStore,
      this.isScrollable = false,
      this.shimmerLength = 20,
      this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall),
      this.noDataText,
      this.isCampaign = false,
      this.inStorePage = false,
      this.isFeatured = false,
      this.showTheme1Store = false,
      this.isService = false})
      : super(key: key);

  @override
  State<ItemsViewV2> createState() => _ItemsViewV2State();
}

class _ItemsViewV2State extends State<ItemsViewV2> {
  @override
  Widget build(BuildContext context) {
    print("storeController.storeItemModel!.items 1 ${widget.items}");
    bool isNull = true;
    int length = 0;
    if (widget.isStore) {
      isNull = widget.stores == null;
      if (!isNull) {
        widget.stores = GlobalHelper.makeListUniqueStore(widget.stores);
        length = widget.stores!.length;
      }
    } else {
      isNull = widget.items == null;
      if (!isNull) {
        widget.items = GlobalHelper.makeListUnique(widget.items);
        length = widget.items!.length;
      }
    }
    print("Home:: loadData $length   stores ");
    return Column(children: [
      !isNull
          ? length > 0
              ? GridView.builder(
                  key: UniqueKey(),
                  gridDelegate: Get.find<SplashController>().module != null &&
                          Get.find<SplashController>().module!.themeId == 3 &&
                          widget.items != null
                      ? SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: ResponsiveHelper.isDesktop(context)
                              ? Dimensions.paddingSizeExtremeLarge
                              : Dimensions.paddingSizeSmall,
                          mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                              ? Dimensions.paddingSizeExtremeLarge
                              : 10,
                          childAspectRatio:
                              ResponsiveHelper.isDesktop(context) &&
                                      widget.stores != null
                                  ? (1 / 0.8)
                                  : widget.showTheme1Store
                                      ? 2
                                      : ResponsiveHelper.isMobile(context)
                                          ? 3
                                          : 3,
                          crossAxisCount: ResponsiveHelper.isMobile(context)
                              ? ResponsiveHelper.isTab(context)
                                  ? 4
                                  : 1
                              : ResponsiveHelper.isDesktop(context) &&
                                      widget.stores != null
                                  ? 4
                                  : 3,
                        )
                      : SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: ResponsiveHelper.isDesktop(context)
                              ? Dimensions.paddingSizeExtremeLarge
                              : Dimensions.paddingSizeSmall,
                          mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                              ? Dimensions.paddingSizeExtremeLarge
                              : 10,
                          childAspectRatio:
                              ResponsiveHelper.isDesktop(context) &&
                                      widget.stores != null
                                  ? (1 / 0.8)
                                  : widget.showTheme1Store
                                      ? 2
                                      : ResponsiveHelper.isMobile(context)
                                          ? widget.isStore
                                              ? 3
                                              : 0.75
                                          : 3,
                          crossAxisCount: ResponsiveHelper.isMobile(context)
                              ? ResponsiveHelper.isTab(context)
                                  ? widget.isStore
                                      ? 2
                                      : 4
                                  : widget.isStore
                                      ? 1
                                      : 2
                              : ResponsiveHelper.isDesktop(context) &&
                                      widget.stores != null
                                  ? 4
                                  : 3,
                        ),
                  physics: widget.isScrollable
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  shrinkWrap: widget.isScrollable ? false : true,
                  itemCount: length,
                  padding: widget.padding,
                  itemBuilder: (context, index) {
                    return widget.showTheme1Store
                        ? StoreWidget(
                            store: widget.stores![index],
                            index: index,
                            inStore: widget.inStorePage)
                        : ResponsiveHelper.isDesktop(context) &&
                                widget.stores != null
                            ? WebStoreWidget(store: widget.stores![index])
                            : widget.items == null
                                ? ItemWidget(
                                    isStore: widget.isStore,
                                    item: widget.isStore
                                        ? null
                                        : widget.items![index],
                                    isFeatured: widget.isFeatured,
                                    store: widget.isStore
                                        ? widget.stores![index]
                                        : null,
                                    index: index,
                                    length: length,
                                    isCampaign: widget.isCampaign,
                                    inStore: widget.inStorePage,
                                  )
                                : Get.find<SplashController>().module != null &&
                                        Get.find<SplashController>()
                                                .module!
                                                .themeId ==
                                            3 &&
                                        widget.items != null
                                    ? ItemWidget(
                                        isStore: widget.isStore,
                                        item: widget.isStore
                                            ? null
                                            : widget.items![index],
                                        isFeatured: widget.isFeatured,
                                        store: widget.isStore
                                            ? widget.stores![index]
                                            : null,
                                        index: index,
                                        length: length,
                                        isCampaign: widget.isCampaign,
                                        inStore: widget.inStorePage,
                                      )
                                    : ItemWidgetV2(
                                        isStore: widget.isStore,
                                        item: widget.isStore
                                            ? null
                                            : widget.items![index],
                                        isFeatured: widget.isFeatured,
                                        store: widget.isStore
                                            ? widget.stores![index]
                                            : null,
                                        index: index,
                                        length: length,
                                        isCampaign: widget.isCampaign,
                                        inStore: widget.inStorePage,
                                      );
                  },
                )
              : NoDataScreen(
                  text: widget.noDataText ??
                      (widget.isStore
                          ? Get.find<SplashController>()
                                  .configModel!
                                  .moduleConfig!
                                  .module!
                                  .showRestaurantText!
                              ? 'no_restaurant_available'.tr
                              : 'no_store_available'.tr
                          : widget.isService
                              ? 'no_services_available'.tr
                              : 'no_item_available'.tr),
                )
          : GridView.builder(
              key: UniqueKey(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // crossAxisSpacing: Dimensions.paddingSizeLarge,
                crossAxisSpacing: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.paddingSizeLarge
                    : Dimensions.paddingSizeSmall,
                mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.paddingSizeLarge
                    : 10,
                // mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
                childAspectRatio: ResponsiveHelper.isDesktop(context)
                    ? (1 / 0.7)
                    : widget.showTheme1Store
                        ? 2
                        : ResponsiveHelper.isMobile(context)
                            ? 0.8
                            : 3,
                crossAxisCount: ResponsiveHelper.isMobile(context)
                    ? ResponsiveHelper.isTab(context)
                        ? 4
                        : 2
                    : ResponsiveHelper.isDesktop(context)
                        ? 4
                        : 3,
              ),
              physics: widget.isScrollable
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              shrinkWrap: widget.isScrollable ? false : true,
              itemCount: widget.shimmerLength,
              padding: widget.padding,
              itemBuilder: (context, index) {
                return widget.showTheme1Store
                    ? StoreShimmer(isEnable: isNull)
                    : ResponsiveHelper.isDesktop(context)
                        ? const WebStoreShimmer()
                        : ItemShimmerV2(
                            isEnabled: isNull,
                            isStore: widget.isStore,
                            hasDivider: index != widget.shimmerLength - 1);
                // : ItemShimmer(isEnabled: isNull, isStore: widget.isStore, hasDivider: index != widget.shimmerLength-1);
              },
            ),
    ]);
  }
}
