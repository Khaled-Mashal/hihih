import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/global_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:sixam_mart/view/base/item_shimmer.dart';
import 'package:sixam_mart/view/base/item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/home/theme1/store_widget.dart';
import 'package:sixam_mart/view/screens/home/theme2/item_widget2.dart';
import 'package:sixam_mart/view/screens/home/web/web_store_widget.dart';

class ItemsView extends StatefulWidget {
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
  final bool showTheme2Clinic;
  ItemsView(
      {Key? key,
      required this.stores,
      required this.items,
      required this.isStore,
      this.isScrollable = false,
      this.shimmerLength = 10,
      this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall),
      this.noDataText,
      this.isCampaign = false,
      this.inStorePage = false,
      this.isFeatured = false,
      this.showTheme1Store = false,
      this.showTheme2Clinic = false})
      : super(key: key);

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  @override
  Widget build(BuildContext context) {
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
    print("Home:: loadData $length stores ");
    return Column(children: [
      !isNull
          ? length > 0
              ? GridView.builder(
                  key: UniqueKey(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: ResponsiveHelper.isDesktop(context)
                        ? Dimensions.paddingSizeExtremeLarge
                        : Dimensions.paddingSizeLarge,
                    mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                        ? Dimensions.paddingSizeExtremeLarge
                        : 0.01,
                    childAspectRatio: ResponsiveHelper.isDesktop(context) &&
                            widget.stores != null
                        ? (1 / 0.8)
                        : widget.showTheme1Store
                            ? 1.9
                            : ResponsiveHelper.isMobile(context)
                                ? 2.9
                                : 3,
                    crossAxisCount: ResponsiveHelper.isMobile(context)
                        ? 1
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
                    return widget.showTheme2Clinic
                        ? ItemWidget2(
                            isStore: widget.isStore,
                            item: widget.isStore ? null : widget.items![index],
                            isFeatured: widget.isFeatured,
                            store:
                                widget.isStore ? widget.stores![index] : null,
                            index: index,
                            length: length,
                            isCampaign: widget.isCampaign,
                            inStore: widget.inStorePage,
                          )
                        : widget.showTheme1Store
                            ? StoreWidget(
                                store: widget.stores![index],
                                index: index,
                                inStore: widget.inStorePage)
                            : ResponsiveHelper.isDesktop(context) &&
                                    widget.stores != null
                                ? WebStoreWidget(store: widget.stores![index])
                                : ItemWidget(
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
                          : 'no_item_available'.tr),
                )
          : GridView.builder(
              key: UniqueKey(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.paddingSizeLarge,
                mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.paddingSizeLarge
                    : 0.01,
                childAspectRatio: ResponsiveHelper.isDesktop(context)
                    ? (1 / 0.7)
                    : widget.showTheme1Store
                        ? 1.9
                        : ResponsiveHelper.isMobile(context)
                            ? 4
                            : 3,
                crossAxisCount: ResponsiveHelper.isMobile(context)
                    ? 1
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
                        : ItemShimmer(
                            isEnabled: isNull,
                            isStore: widget.isStore,
                            hasDivider: index != widget.shimmerLength - 1);
              },
            ),
    ]);
  }
}
