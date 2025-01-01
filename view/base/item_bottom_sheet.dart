import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/cart_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/confirmation_dialog.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/item_widget.dart';
import 'package:sixam_mart/view/base/quantity_button.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_snackbar.dart';
import 'image_viewer_screen.dart';

class ItemBottomSheet extends StatefulWidget {
  final Item? item;
  final bool isCampaign;
  final CartModel? cart;
  final int? cartIndex;
  final bool inStorePage;
  const ItemBottomSheet(
      {Key? key,
      required this.item,
      this.isCampaign = false,
      this.cart,
      this.cartIndex,
      this.inStorePage = false})
      : super(key: key);

  @override
  State<ItemBottomSheet> createState() => _ItemBottomSheetState();
}

class _ItemBottomSheetState extends State<ItemBottomSheet> {
  bool _newVariation = false;

  @override
  void initState() {
    super.initState();
    if (Get.find<SplashController>().module == null) {
      if (Get.find<SplashController>().cacheModule != null) {
        Get.find<SplashController>()
            .setCacheConfigModule(Get.find<SplashController>().cacheModule);
      }
    }
    if (widget.item != null) {
      Get.find<StoreController>().getCartStoreSuggestedItemList2(
          widget.item!.storeId, widget.item!.categoryId);
    }
    _newVariation = Get.find<SplashController>()
            .getModuleConfig2(widget.item!.moduleType)
            .newVariation ??
        false;
    Get.find<ItemController>().initData(widget.item, widget.cart);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      height: 1000,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      // padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: GetPlatform.isWeb
            ? const BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
            : const BorderRadius.vertical(
                top: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: GetBuilder<ItemController>(builder: (itemController) {
        double? startingPrice;
        double? endingPrice;
        if (widget.item!.choiceOptions!.isNotEmpty &&
            widget.item!.foodVariations!.isEmpty) {
          List<double?> priceList = [];
          for (var variation in widget.item!.variations!) {
            priceList.add(variation.price);
          }
          priceList.sort((a, b) => a!.compareTo(b!));
          startingPrice = priceList[0];
          if (priceList[0]! < priceList[priceList.length - 1]!) {
            endingPrice = priceList[priceList.length - 1];
          }
        } else {
          startingPrice = widget.item!.price;
        }

        double? price = widget.item!.price;
        double variationPrice = 0;
        Variation? variation;
        double? discount =
            (widget.isCampaign || widget.item!.storeDiscount == 0)
                ? widget.item!.discount
                : widget.item!.storeDiscount;
        String? discountType =
            (widget.isCampaign || widget.item!.storeDiscount == 0)
                ? widget.item!.discountType
                : 'percent';
        int? stock = widget.item!.stock ?? 0;

        if (_newVariation) {
          for (int index = 0;
              index < widget.item!.foodVariations!.length;
              index++) {
            for (int i = 0;
                i < widget.item!.foodVariations![index].variationValues!.length;
                i++) {
              if (itemController.selectedVariations[index][i]!) {
                variationPrice += widget.item!.foodVariations![index]
                    .variationValues![i].optionPrice!;
              }
            }
          }
        } else {
          List<String> variationList = [];
          for (int index = 0;
              index < widget.item!.choiceOptions!.length;
              index++) {
            variationList.add(widget.item!.choiceOptions![index]
                .options![itemController.variationIndex![index]]
                .replaceAll(' ', ''));
          }
          String variationType = '';
          bool isFirst = true;
          for (var variation in variationList) {
            if (isFirst) {
              variationType = '$variationType$variation';
              isFirst = false;
            } else {
              variationType = '$variationType-$variation';
            }
          }

          for (Variation variations in widget.item!.variations!) {
            if (variations.type == variationType) {
              price = variations.price;
              variation = variations;
              stock = variations.stock;
              break;
            }
          }
        }

        price = price! + variationPrice;
        double priceWithDiscount =
            PriceConverter.convertWithDiscount(price, discount, discountType)!;
        double addonsCost = 0;
        List<AddOn> addOnIdList = [];
        List<AddOns> addOnsList = [];
        for (int index = 0; index < widget.item!.addOns!.length; index++) {
          if (itemController.addOnActiveList[index]) {
            addonsCost = addonsCost +
                (widget.item!.addOns![index].price! *
                    itemController.addOnQtyList[index]!);
            addOnIdList.add(AddOn(
                id: widget.item!.addOns![index].id,
                quantity: itemController.addOnQtyList[index]));
            addOnsList.add(widget.item!.addOns![index]);
          }
        }
        bool isAvailable = DateConverter.isAvailable(
            widget.item!.availableTimeStarts, widget.item!.availableTimeEnds);

        return ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9),
          child: Stack(
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault,
                        bottom: Dimensions.paddingSizeDefault),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
                        SizedBox(
                          width: 400,
                          child: Center(
                            child: InkWell(
                              onTap: widget.isCampaign
                                  ? null
                                  : () {
                                      if (!widget.isCampaign) {
                                        Get.toNamed(
                                            RouteHelper.getItemImagesRoute(
                                                widget.item!));
                                      }
                                    },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                    child: CustomImage(
                                      image:
                                          '${widget.isCampaign ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}/${widget.item!.image}',
                                      width: 320,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  DiscountTag(
                                      discount: discount,
                                      discountType: discountType,
                                      fromTop: 20),
                                  SizedBox(
                                    width: 400,
                                    height: 400,
                                    child: widget.item != null
                                        ? ImageViewerScreen(item: widget.item!)
                                        : Container(), // Check if item is not null before passing it to ImageViewerScreen
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        // Content Section
                        Padding(
                          padding: const EdgeInsets.only(
                              right: Dimensions.paddingSizeDefault),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: Get.find<SplashController>()
                                          .configModel!
                                          .toggleVegNonVeg!
                                      ? 50
                                      : 0),
                              // Unit Type or Veg/Non-Veg Indicator
                              // if (Get.find<SplashController>().module!.themeId != 3)
                              //   ((Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && widget.item!.unitType != null) ||
                              //       (Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!))
                              //       ? Container(
                              //     padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                              //         color: Theme.of(context).cardColor,
                              //         boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), blurRadius: 5)]),
                              //     // child: Get.find<SplashController>().configModel!.moduleConfig!.module!.unit!
                              //     //     ? Text(
                              //     //   ''
                              //     //   // widget.item!.unitType ?? '',
                              //     //   // style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                              //     // )
                              //     //     : Row(children: [
                              //     //   Image.asset(widget.item!.veg == 1 ? Images.vegLogo : Images.nonVegLogo, height: 20, width: 20),
                              //     //   const SizedBox(width: Dimensions.paddingSizeSmall),
                              //     //   Text(widget.item!.veg == 1 ? 'veg'.tr : 'non_veg'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                              //     // ]),
                              //   )
                              const SizedBox(),
                              GetBuilder<WishListController>(
                                  builder: (wishList) {
                                return InkWell(
                                  onTap: () {
                                    if (Get.find<AuthController>()
                                        .isLoggedIn()) {
                                      print(
                                          "wishList.wishItemIdList.contains(widget.item!.id) ${wishList.wishItemIdList.contains(widget.item!.id)}");
                                      wishList.wishItemIdList
                                              .contains(widget.item!.id)
                                          ? wishList.removeFromWishList(
                                              widget.item!.id, false,
                                              getXSnackBar: true)
                                          : wishList.addToWishList(
                                              widget.item, null, false,
                                              getXSnackBar: true);
                                    } else {
                                      showCustomSnackBar(
                                          'you_are_not_logged_in'.tr,
                                          getXSnackBar: true);
                                    }
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.item!.name!,
                                          style: robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeLarge),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              8), // Adjust the space between the text and the icon
                                      Icon(
                                        wishList.wishItemIdList
                                                .contains(widget.item!.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: wishList.wishItemIdList
                                                .contains(widget.item!.id)
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).disabledColor,
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              // Store Name
                              InkWell(
                                onTap: () {
                                  if (widget.inStorePage) {
                                    Get.back();
                                  } else {
                                    Get.back();
                                    Get.find<CartController>()
                                        .forcefullySetModule(
                                            widget.item!.moduleId!);
                                    Get.toNamed(RouteHelper.getStoreRoute(
                                        id: widget.item!.storeId,
                                        page: 'item'));
                                    Get.offNamed(RouteHelper.getStoreRoute(
                                        id: widget.item!.storeId,
                                        page: 'item'));
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 1, 1, 1),
                                  child: Text(
                                    widget.item!.storeName!,
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              // Rating
                              !widget.isCampaign
                                  ? RatingBar(
                                      rating: widget.item!.avgRating,
                                      size: 15,
                                      ratingCount: widget.item!.ratingCount)
                                  : const SizedBox(),
                              // Price
                              Text(
                                '${PriceConverter.convertPriceV2(startingPrice, discount: discount, discountType: discountType)}'
                                '${endingPrice != null ? ' - ${PriceConverter.convertPriceV2(endingPrice, discount: discount, discountType: discountType)}' : ''}',
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                                textDirection: TextDirection.ltr,
                              ),
                              // Original Price
                              price > 0 && price > priceWithDiscount
                                  ? Text(
                                      '${PriceConverter.convertPrice(startingPrice)}'
                                      '${endingPrice != null ? ' - ${PriceConverter.convertPrice(endingPrice)}' : ''}',
                                      textDirection: TextDirection.ltr,
                                      style: robotoMedium.copyWith(
                                          color:
                                              Theme.of(context).disabledColor,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  : const SizedBox(),
                              // Wishlist Icon
                              if (Get.find<SplashController>()
                                      .module!
                                      .themeId !=
                                  3)
                                widget.isCampaign
                                    ? const SizedBox(height: 25)
                                    : GetBuilder<WishListController>(
                                        builder: (wishList) {
                                        return InkWell(
                                          onTap: () {
                                            if (Get.find<AuthController>()
                                                .isLoggedIn()) {
                                              print(
                                                  "wishList.wishItemIdList.contains(widget.item!.id) ${wishList.wishItemIdList.contains(widget.item!.id)}");
                                              wishList.wishItemIdList
                                                      .contains(widget.item!.id)
                                                  ? wishList.removeFromWishList(
                                                      widget.item!.id, false,
                                                      getXSnackBar: true)
                                                  : wishList.addToWishList(
                                                      widget.item, null, false,
                                                      getXSnackBar: true);
                                            } else {
                                              showCustomSnackBar(
                                                  'you_are_not_logged_in'.tr,
                                                  getXSnackBar: true);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .radiusDefault),
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.05)),
                                            padding: const EdgeInsets.all(
                                                Dimensions.paddingSizeSmall),
                                            margin: const EdgeInsets.only(
                                                top: Dimensions
                                                    .paddingSizeSmall),
                                          ),
                                        );
                                      }),
                              SizedBox(
                                  height: Get.find<SplashController>()
                                          .configModel!
                                          .toggleVegNonVeg!
                                      ? 50
                                      : 0),
                              // Unit Type or Veg/Non-Veg Indicator
                              // if (Get.find<SplashController>().module!.themeId != 3)
                              //   ((Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && widget.item!.unitType != null) ||
                              //       (Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!))
                              //       ? Container(
                              //     padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                              //         color: Theme.of(context).cardColor,
                              //         boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), blurRadius: 5)]),
                              //     // child: Get.find<SplashController>().configModel!.moduleConfig!.module!.unit!
                              //     //     ? Text(
                              //     //   ''
                              //     //   // widget.item!.unitType ?? '',
                              //     //   // style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                              //     // )
                              //     //     : Row(children: [
                              //     //   Image.asset(widget.item!.veg == 1 ? Images.vegLogo : Images.nonVegLogo, height: 20, width: 20),
                              //     //   const SizedBox(width: Dimensions.paddingSizeSmall),
                              //     //   Text(widget.item!.veg == 1 ? 'veg'.tr : 'non_veg'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                              //     // ]),
                              //   )
                              const SizedBox(),
                              _newVariation
                                  ? NewVariationView(
                                      item: widget.item,
                                      itemController: itemController,
                                      discount: discount,
                                      discountType: discountType,
                                      showOriginalPrice:
                                          price > priceWithDiscount,
                                    )
                                  : VariationView(
                                      item: widget.item,
                                      itemController: itemController,
                                    ),
                              SizedBox(
                                  height: (Get.find<SplashController>()
                                              .configModel!
                                              .moduleConfig!
                                              .module!
                                              .addOn! &&
                                          widget.item!.addOns!.isNotEmpty)
                                      ? Dimensions.paddingSizeLarge
                                      : 0),
                              // Addons
                              (Get.find<SplashController>()
                                          .configModel!
                                          .moduleConfig!
                                          .module!
                                          .addOn! &&
                                      widget.item!.addOns!.isNotEmpty)
                                  ? AddonView(
                                      itemController: itemController,
                                      item: widget.item!)
                                  : const SizedBox(),
                              // Availability
                              if (!isAvailable)
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeSmall),
                                  margin: const EdgeInsets.only(
                                      bottom: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                  ),
                                  child: Column(children: [
                                    Text('not_available_now'.tr,
                                        style: robotoMedium.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: Dimensions.fontSizeLarge,
                                        )),
                                    Text(
                                      '${'available_will_be'.tr} ${DateConverter.convertTimeToTime(widget.item!.availableTimeStarts!)} '
                                      '- ${DateConverter.convertTimeToTime(widget.item!.availableTimeEnds!)}',
                                      style: robotoRegular,
                                    ),
                                  ]),
                                ),
                            ],
                          ),
                        ),
                        // Add description, variations, addons, availability
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        // Description
                        if (widget.item!.description != null &&
                            widget.item!.description!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('description'.tr, style: robotoMedium),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraSmall),
                              Text(widget.item!.description!,
                                  style: robotoRegular),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                              if (Get.find<SplashController>().module != null &&
                                  Get.find<SplashController>()
                                          .module!
                                          .themeId !=
                                      3)
                                suggestedItemView(
                                    Get.find<CartController>().cartList),
                            ],
                          ),
                        // Variations
                      ],
                    ),
                  ),
                ),

                // const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                ///Bottom side..
                (!widget.item!.scheduleOrder! && !isAvailable)
                    ? const SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: GetPlatform.isWeb
                                ? const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(40))
                                : const BorderRadius.all(Radius.circular(0)),
                            boxShadow: ResponsiveHelper.isDesktop(context)
                                ? null
                                : [
                                    BoxShadow(
                                        color: Colors.grey[300]!,
                                        blurRadius: 10)
                                  ]),
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeDefault),
                        child: Column(children: [
                          Builder(builder: (context) {
                            double? cost = PriceConverter.convertWithDiscount(
                                (price! * itemController.quantity!),
                                discount,
                                discountType);
                            double withAddonCost = cost! + addonsCost;
                            return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${'total_amount'.tr}:',
                                      style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Row(children: [
                                    discount! > 0
                                        ? PriceConverter.convertAnimationPrice(
                                            (price * itemController.quantity!) +
                                                addonsCost,
                                            textStyle: robotoMedium.copyWith(
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    PriceConverter.convertAnimationPriceV2(
                                      withAddonCost,
                                      textStyle: robotoBold.copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ]),
                                ]);
                          }),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          SafeArea(
                            child: Row(children: [
                              // Quantity
                              Row(children: [
                                QuantityButton(
                                  onTap: () {
                                    if (itemController.quantity! > 1) {
                                      itemController.setQuantity(false, stock,
                                          widget.item!.quantityLimit,
                                          getxSnackBar: true);
                                    }
                                  },
                                  isIncrement: false,
                                  fromSheet: true,
                                ),
                                Text(itemController.quantity.toString(),
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge)),
                                QuantityButton(
                                  onTap: () => itemController.setQuantity(
                                      true, stock, widget.item!.quantityLimit,
                                      getxSnackBar: true),
                                  isIncrement: true,
                                  fromSheet: true,
                                ),
                              ]),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),

                              Expanded(
                                  child: CustomButton(
                                width: ResponsiveHelper.isDesktop(context)
                                    ? MediaQuery.of(context).size.width / 2.0
                                    : null,
                                /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                                      ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                                buttonText:
                                    (false /*Get.find<SplashController>().configModel!.moduleConfig!.module!.stock! && stock! <= 0*/)
                                        ? 'out_of_stock'.tr
                                        : widget.isCampaign
                                            ? 'order_now'.tr
                                            : (widget.cart != null ||
                                                    itemController.cartIndex !=
                                                        -1)
                                                ? 'update_in_cart'.tr
                                                : Get.find<SplashController>()
                                                            .module!
                                                            .themeId ==
                                                        3
                                                    ? 'order_service'.tr
                                                    : 'add_to_cart'.tr,
                                onPressed:
                                    (false /*Get.find<SplashController>().configModel!.moduleConfig!.module!.stock! && stock! <= 0*/)
                                        ? null
                                        : () {
                                            String? invalid;
                                            if (_newVariation) {
                                              for (int index = 0;
                                                  index <
                                                      widget
                                                          .item!
                                                          .foodVariations!
                                                          .length;
                                                  index++) {
                                                if (!widget
                                                        .item!
                                                        .foodVariations![index]
                                                        .multiSelect! &&
                                                    widget
                                                        .item!
                                                        .foodVariations![index]
                                                        .required! &&
                                                    !itemController
                                                        .selectedVariations[
                                                            index]
                                                        .contains(true)) {
                                                  invalid =
                                                      '${'choose_a_variation_from'.tr} ${widget.item!.foodVariations![index].name}';
                                                  break;
                                                } else if (widget
                                                        .item!
                                                        .foodVariations![index]
                                                        .multiSelect! &&
                                                    (widget
                                                            .item!
                                                            .foodVariations![
                                                                index]
                                                            .required! ||
                                                        itemController
                                                            .selectedVariations[
                                                                index]
                                                            .contains(true)) &&
                                                    widget
                                                            .item!
                                                            .foodVariations![
                                                                index]
                                                            .min! >
                                                        itemController
                                                            .selectedVariationLength(
                                                                itemController
                                                                    .selectedVariations,
                                                                index)) {
                                                  invalid =
                                                      '${'select_minimum'.tr} ${widget.item!.foodVariations![index].min} '
                                                      '${'and_up_to'.tr} ${widget.item!.foodVariations![index].max} ${'options_from'.tr}'
                                                      ' ${widget.item!.foodVariations![index].name} ${'variation'.tr}';
                                                  break;
                                                }
                                              }
                                            }

                                            if (invalid != null) {
                                              showCustomSnackBar(invalid,
                                                  getXSnackBar: true);
                                            } else {
                                              Get.back();
                                              CartModel cartModel = CartModel(
                                                  price,
                                                  priceWithDiscount,
                                                  variation != null
                                                      ? [variation]
                                                      : [],
                                                  itemController
                                                      .selectedVariations,
                                                  (price! -
                                                      PriceConverter
                                                          .convertWithDiscount(
                                                              price,
                                                              discount,
                                                              discountType)!),
                                                  itemController.quantity,
                                                  addOnIdList,
                                                  addOnsList,
                                                  widget.isCampaign,
                                                  stock,
                                                  widget.item,
                                                  widget.item!.quantityLimit !=
                                                          null
                                                      ? widget
                                                          .item!.quantityLimit!
                                                      : null);
                                              if (widget.isCampaign) {
                                                Get.toNamed(
                                                    RouteHelper
                                                        .getCheckoutRoute(
                                                            'campaign'),
                                                    arguments: CheckoutScreen(
                                                      storeId: null,
                                                      fromCart: false,
                                                      cartList: [cartModel],
                                                    ));
                                              } else {
                                                if (Get.find<CartController>()
                                                    .existAnotherStoreItem(
                                                        cartModel.item!.storeId,
                                                        Get.find<SplashController>()
                                                                    .module !=
                                                                null
                                                            ? Get.find<
                                                                    SplashController>()
                                                                .module!
                                                                .id
                                                            : Get.find<
                                                                    SplashController>()
                                                                .cacheModule!
                                                                .id)) {
                                                  Get.dialog(
                                                      ConfirmationDialog(
                                                        icon: Images.warning,
                                                        title:
                                                            'are_you_sure_to_reset'
                                                                .tr,
                                                        description: Get.find<
                                                                    SplashController>()
                                                                .configModel!
                                                                .moduleConfig!
                                                                .module!
                                                                .showRestaurantText!
                                                            ? 'if_you_continue'
                                                                .tr
                                                            : 'if_you_continue_without_another_store'
                                                                .tr,
                                                        onYesPressed: () {
                                                          Get.back();
                                                          Get.find<
                                                                  CartController>()
                                                              .removeAllAndAddToCart(
                                                                  cartModel);
                                                          showCartSnackBar();
                                                        },
                                                      ),
                                                      barrierDismissible:
                                                          false);
                                                } else {
                                                  Get.find<CartController>()
                                                      .addToCart(
                                                    cartModel,
                                                    widget.cartIndex ??
                                                        itemController
                                                            .cartIndex,
                                                  );
                                                  showCartSnackBar();
                                                }
                                              }
                                            }
                                          },
                              )),
                            ]),
                          ),
                        ]),
                      ),
              ]),
              Positioned(
                top: 5,
                right: 10,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                            blurRadius: 5)
                      ],
                    ),
                    child: const Icon(Icons.close, size: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget suggestedItemView(List<CartModel> cartList) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), blurRadius: 10)]
      ),
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GetBuilder<StoreController>(builder: (storeController) {
          List<Item>? suggestedItems;
          if (storeController.cartSuggestItemModel2 != null) {
            suggestedItems = [];
            List<int> cartIds = [];
            for (CartModel cartItem in cartList) {
              cartIds.add(cartItem.item!.id!);
            }
            for (Item item in storeController.cartSuggestItemModel2!.items!) {
              if (!cartIds.contains(item.id)) {
                suggestedItems.add(item);
              }
            }
          }
          if (storeController.cartSuggestItemModel2 != null &&
              storeController.cartSuggestItemModel2!.items!.isEmpty) {
            return const SizedBox();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: Dimensions.paddingSizeSmall),
              // const SizedBox(height: Dimensions.paddingSizeSmall),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeExtraSmall),
                  child: Text('you_may_also_like'.tr,
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(Get.context!).primaryColor))),

              SizedBox(
                  height: ResponsiveHelper.isDesktop(context) ? 160 : 145,
                  child: storeController.cartSuggestItemModel2 != null &&
                          suggestedItems!.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggestedItems.length,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                              left: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.paddingSizeExtraSmall
                                  : Dimensions.paddingSizeDefault),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: ResponsiveHelper.isDesktop(context)
                                  ? const EdgeInsets.symmetric(vertical: 20)
                                  : const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 500
                                    : 300,
                                padding: const EdgeInsets.only(
                                    right: Dimensions.paddingSizeSmall,
                                    left: Dimensions.paddingSizeExtraSmall),
                                margin: const EdgeInsets.only(
                                    right: Dimensions.paddingSizeSmall),
                                child: ItemWidget(
                                    isStore: false,
                                    item: suggestedItems![index],
                                    fromCartSuggestion: true,
                                    store: null,
                                    index: index,
                                    length: null,
                                    isCampaign: false,
                                    inStore: true,
                                    isRelated: true),
                              ),
                            );
                          },
                        )
                      : RelatedItemShimmer(
                          enabled:
                              storeController.cartSuggestItemModel2 == null ||
                                  storeController
                                      .cartSuggestItemModel2!.items!.isEmpty)),
            ],
          );
        }),
      ]),
    );
  }
}

class AddonView extends StatelessWidget {
  final Item item;
  final ItemController itemController;
  const AddonView({Key? key, required this.item, required this.itemController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('addons'.tr, style: robotoMedium),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Text(
              'optional'.tr,
              style: robotoRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.fontSizeSmall),
            ),
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: item.addOns!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (!itemController.addOnActiveList[index]) {
                  itemController.addAddOn(true, index);
                } else if (itemController.addOnQtyList[index] == 1) {
                  itemController.addAddOn(false, index);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Checkbox(
                      value: itemController.addOnActiveList[index],
                      activeColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall)),
                      onChanged: (bool? newValue) {
                        if (!itemController.addOnActiveList[index]) {
                          itemController.addAddOn(true, index);
                        } else if (itemController.addOnQtyList[index] == 1) {
                          itemController.addAddOn(false, index);
                        }
                      },
                      visualDensity:
                          const VisualDensity(horizontal: -3, vertical: -3),
                      side: BorderSide(
                          width: 2, color: Theme.of(context).hintColor),
                    ),
                    Text(
                      item.addOns![index].name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: itemController.addOnActiveList[index]
                          ? robotoMedium
                          : robotoRegular.copyWith(
                              color: Theme.of(context).hintColor),
                    ),
                  ]),
                  const Spacer(),
                  Text(
                    item.addOns![index].price! > 0
                        ? PriceConverter.convertPrice(item.addOns![index].price)
                        : 'free'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: itemController.addOnActiveList[index]
                        ? robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall)
                        : robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).disabledColor),
                  ),
                  itemController.addOnActiveList[index]
                      ? Container(
                          height: 25,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              color: Theme.of(context).cardColor),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (itemController.addOnQtyList[index]! >
                                          1) {
                                        itemController.setAddOnQuantity(
                                            false, index);
                                      } else {
                                        itemController.addAddOn(false, index);
                                      }
                                    },
                                    child: Center(
                                        child: Icon(
                                      (itemController.addOnQtyList[index]! > 1)
                                          ? Icons.remove
                                          : Icons.delete_outline_outlined,
                                      size: 18,
                                      color: (itemController
                                                  .addOnQtyList[index]! >
                                              1)
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).colorScheme.error,
                                    )),
                                  ),
                                ),
                                Text(
                                  itemController.addOnQtyList[index].toString(),
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => itemController
                                        .setAddOnQuantity(true, index),
                                    child: Center(
                                        child: Icon(Icons.add,
                                            size: 18,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                ),
                              ]),
                        )
                      : const SizedBox(),
                ]),
              ),
            );
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      ],
    );
  }
}

class VariationView extends StatelessWidget {
  final Item? item;
  final ItemController itemController;
  const VariationView(
      {Key? key, required this.item, required this.itemController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: item!.choiceOptions!.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
          bottom: item!.choiceOptions!.isNotEmpty
              ? Dimensions.paddingSizeLarge
              : 0),
      itemBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item!.choiceOptions![index].title!, style: robotoMedium),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Theme.of(context).cardColor,
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: item!.choiceOptions![index].options!.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeExtraSmall),
                  child: InkWell(
                    onTap: () {
                      itemController.setCartVariationIndex(index, i, item);
                    },
                    child: Row(children: [
                      Expanded(
                          child: Text(
                        item!.choiceOptions![index].options![i].trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: robotoRegular,
                      )),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Radio<int>(
                        value: i,
                        groupValue: itemController.variationIndex![index],
                        onChanged: (int? value) => itemController
                            .setCartVariationIndex(index, i, item),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
          SizedBox(
              height: index != item!.choiceOptions!.length - 1
                  ? Dimensions.paddingSizeLarge
                  : 0),
        ]);
      },
    );
  }
}

class NewVariationView extends StatelessWidget {
  final Item? item;
  final ItemController itemController;
  final double? discount;
  final String? discountType;
  final bool showOriginalPrice;
  const NewVariationView(
      {Key? key,
      required this.item,
      required this.itemController,
      required this.discount,
      required this.discountType,
      required this.showOriginalPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('omaraxxxxxxxxxxxxxxxz');
    print(item!.price);
    print(discount);
    print(discountType);
    print(itemController.item);
    // item!.price=0;

    return item!.foodVariations != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: item!.foodVariations!.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                bottom: (item!.foodVariations != null &&
                        item!.foodVariations!.isNotEmpty)
                    ? Dimensions.paddingSizeLarge
                    : 0),
            itemBuilder: (context, index) {
              int selectedCount = 0;
              if (item!.foodVariations![index].required!) {
                for (var value in itemController.selectedVariations[index]) {
                  if (value == true) {
                    selectedCount++;
                  }
                }
              }

              item!.price = 0;
              return Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                margin: EdgeInsets.only(
                    bottom: index != item!.foodVariations!.length - 1
                        ? Dimensions.paddingSizeLarge
                        : 0),
                decoration: BoxDecoration(
                    color:
                        itemController.selectedVariations[index].contains(true)
                            ? Theme.of(context).primaryColor.withOpacity(0.01)
                            : Theme.of(context).disabledColor.withOpacity(0.05),
                    border: Border.all(
                        color: itemController.selectedVariations[index]
                                .contains(true)
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).disabledColor,
                        width: 0.5),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(item!.foodVariations![index].name!,
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge)),
                            Container(
                              decoration: BoxDecoration(
                                color: item!.foodVariations![index].required! &&
                                        (item!.foodVariations![index]
                                                    .multiSelect!
                                                ? item!
                                                    .foodVariations![index].min!
                                                : 1) >
                                            selectedCount
                                    ? Theme.of(context)
                                        .colorScheme
                                        .error
                                        .withOpacity(0.1)
                                    : Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                              ),
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraSmall),
                              child: Text(
                                item!.foodVariations![index].required!
                                    ? (item!.foodVariations![index].multiSelect!
                                                ? item!
                                                    .foodVariations![index].min!
                                                : 1) <=
                                            selectedCount
                                        ? 'completed'.tr
                                        : 'required'.tr
                                    : 'optional'.tr,
                                style: robotoRegular.copyWith(
                                  color: item!.foodVariations![index].required!
                                      ? (item!.foodVariations![index]
                                                      .multiSelect!
                                                  ? item!.foodVariations![index]
                                                      .min!
                                                  : 1) <=
                                              selectedCount
                                          ? Theme.of(context).hintColor
                                          : Theme.of(context).colorScheme.error
                                      : Theme.of(context).hintColor,
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                              ),
                            ),
                          ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      item!.foodVariations![index].multiSelect!
                          ? Text(
                              '${'select_minimum'.tr} ${'${item!.foodVariations![index].min}'
                                  ' ${'and_up_to'.tr} ${item!.foodVariations![index].max} ${'options'.tr}'}',
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                  color: Theme.of(context).disabledColor),
                            )
                          : Text(
                              'select_one'.tr,
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall,
                                  color: Theme.of(context).primaryColor),
                            ),
                      SizedBox(
                          height: item!.foodVariations![index].multiSelect!
                              ? Dimensions.paddingSizeExtraSmall
                              : 0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: itemController.collapsVariation[index]
                            ? item!.foodVariations![index].variationValues!
                                        .length >
                                    4
                                ? 5
                                : item!.foodVariations![index].variationValues!
                                    .length
                            : item!
                                .foodVariations![index].variationValues!.length,
                        itemBuilder: (context, i) {
                          if (i == 4 &&
                              itemController.collapsVariation[index]) {
                            return Padding(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraSmall),
                              child: InkWell(
                                onTap: () => itemController
                                    .showMoreSpecificSection(index),
                                child: Row(children: [
                                  Icon(Icons.expand_more,
                                      size: 18,
                                      color: Theme.of(context).primaryColor),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    '${'view'.tr} ${item!.foodVariations![index].variationValues!.length - 4} ${'more_option'.tr}',
                                    style: robotoMedium.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ]),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: ResponsiveHelper.isDesktop(context)
                                      ? Dimensions.paddingSizeExtraSmall
                                      : 0),
                              child: InkWell(
                                onTap: () {
                                  itemController.setNewCartVariationIndex(
                                      index, i, item!);
                                },
                                child: Row(children: [
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        item!.foodVariations![index]
                                                .multiSelect!
                                            ? Checkbox(
                                                value: itemController
                                                        .selectedVariations[
                                                    index][i],
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusSmall)),
                                                onChanged: (bool? newValue) {
                                                  itemController
                                                      .setNewCartVariationIndex(
                                                          index, i, item!);
                                                },
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal: -3,
                                                        vertical: -3),
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Theme.of(context)
                                                        .hintColor),
                                              )
                                            : Radio(
                                                value: i,
                                                groupValue: itemController
                                                    .selectedVariations[index]
                                                    .indexOf(true),
                                                onChanged: (dynamic value) {
                                                  itemController
                                                      .setNewCartVariationIndex(
                                                          index, i, item!);
                                                },
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                                toggleable: false,
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal: -3,
                                                        vertical: -3),
                                              ),
                                        Text(
                                          item!.foodVariations![index]
                                              .variationValues![i].level!
                                              .trim(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: itemController
                                                  .selectedVariations[index][i]!
                                              ? robotoMedium
                                              : robotoRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                        ),
                                      ]),
                                  const Spacer(),
                                  showOriginalPrice
                                      ? Text(
                                          '+${PriceConverter.convertPrice(item!.foodVariations![index].variationValues![i].optionPrice)}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.ltr,
                                          style: /* itemController.selectedVariations[index][i]! ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, decoration: TextDecoration.lineThrough)
                              :*/
                                              robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                        )
                                      : const SizedBox(),
                                  SizedBox(
                                      width: showOriginalPrice
                                          ? Dimensions.paddingSizeExtraSmall
                                          : 0),
                                  Text(
                                    '+${PriceConverter.convertPrice(item!.foodVariations![index].variationValues![i].optionPrice, discount: discount, discountType: discountType)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textDirection: TextDirection.ltr,
                                    style: itemController
                                            .selectedVariations[index][i]!
                                        ? robotoMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall)
                                        : robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context)
                                                .disabledColor),
                                  ),
                                ]),
                              ),
                            );
                          }
                        },
                      ),
                    ]),
              );
            },
          )
        : const SizedBox();
  }
}

class RelatedItemShimmer extends StatelessWidget {
  final bool enabled;
  const RelatedItemShimmer({Key? key, required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              const EdgeInsets.fromLTRB(2, 2, Dimensions.paddingSizeSmall, 2),
          child: Container(
            height: 90,
            width: 250,
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
              duration: const Duration(seconds: 1),
              interval: const Duration(seconds: 1),
              enabled: enabled,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        color: Colors.grey[300],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 15,
                                  width: 100,
                                  color: Colors.grey[300]),
                              const SizedBox(height: 5),
                              Container(
                                  height: 10,
                                  width: 130,
                                  color: Colors.grey[300]),
                              const SizedBox(height: 5),
                              const RatingBar(
                                  rating: 0, size: 12, ratingCount: 0),
                              Row(children: [
                                Expanded(
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            height: 15,
                                            width: 50,
                                            color: Colors.grey[300]),
                                        const SizedBox(
                                            width: Dimensions
                                                .paddingSizeExtraSmall),
                                        Container(
                                            height: 10,
                                            width: 50,
                                            color: Colors.grey[300]),
                                      ]),
                                ),
                                const Icon(Icons.add, size: 20),
                              ]),
                            ]),
                      ),
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
