import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/config_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/module_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/corner_banner/banner.dart';
import 'package:sixam_mart/view/base/corner_banner/corner_discount_tag.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/base/organic_tag.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemWidgetV2 extends StatelessWidget {
  final Item? item;
  final Store? store;
  final bool isStore;
  final int index;
  final int? length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  final bool fromCartSuggestion;
  final double? imageHeight;
  final double? imageWidth;
  final bool? isCornerTag;
    final bool isService;
  const ItemWidgetV2({Key? key, required this.item, required this.isStore, required this.store, required this.index,
   required this.length, this.inStore = false, this.isCampaign = false, this.isFeatured = false, this.fromCartSuggestion = false, this.imageHeight, this.imageWidth, this.isCornerTag = false,this.isService=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool ltr = Get.find<LocalizationController>().isLtr;
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    if(isStore) {
      discount = store!.discount != null ? store!.discount!.discount : 0;
      discountType = store!.discount != null ? store!.discount!.discountType : 'percent';
      // bool _isClosedToday = Get.find<StoreController>().isRestaurantClosed(true, store.active, store.offDay);
      // _isAvailable = DateConverter.isAvailable(store.openingTime, store.closeingTime) && store.active && !_isClosedToday;
      isAvailable = store!.open == 1 && store!.active!;
    }else {
      discount = (item!.storeDiscount == 0 || isCampaign) ? item!.discount : item!.storeDiscount;
      discountType = (item!.storeDiscount == 0 || isCampaign) ? item!.discountType : 'percent';
      isAvailable = DateConverter.isAvailable(item!.availableTimeStarts, item!.availableTimeEnds);
    }

    return 
    !isStore?
    GetBuilder<ItemController>(builder: (itemController) {
   return
   Padding(
    padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
   child:InkWell(
      onTap: () {
        if(isStore) {
          if(store != null) {
            if(isFeatured && Get.find<SplashController>().moduleList != null) {
              for(ModuleModel module in Get.find<SplashController>().moduleList!) {
                if(module.id == store!.moduleId) {
                  Get.find<SplashController>().setModule(module);
                  break;
                }
              }
            }
            
            Get.toNamed(
              RouteHelper.getStoreRoute(id: store!.id, page: isFeatured ? 'module' : 'item'),
              arguments: StoreScreen(store: store, fromModule: isFeatured),
            );
          }
        }else {
          if(isFeatured && Get.find<SplashController>().moduleList != null) {
            for(ModuleModel module in Get.find<SplashController>().moduleList!) {
              if(module.id == item!.moduleId) {
                Get.find<SplashController>().setModule(module);
                break;
              }
            }
          }
          Get.find<ItemController>().navigateToItemPage(item, context, inStore: inStore, isCampaign: isCampaign);
        }
      },
      child:Container(
                      height: 230,
                      width: 180,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: [BoxShadow(
                          color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!,
                          blurRadius: 5, spreadRadius: 1,
                        )],
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                        Stack(children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}/${item!.image}',
                              height: 125, width: 170, fit: BoxFit.cover,
                            ),
                          ),
                          DiscountTag(
                            discount: item!.discount, discountType: item!.discountType,
                            inLeft: true,
                          ),
                          itemController.isAvailable(item!) ? const SizedBox() : const NotAvailableWidget(isStore: true),
                          Positioned(
                            top: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Row(children: [
                                Icon(Icons.star, color: Theme.of(context).primaryColor, size: 15),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Text(item!.avgRating!.toStringAsFixed(1), style: robotoRegular),
                              ]),
                            ),
                          ),

                          OrganicTag(item: item!, placeTop: item!.discount! == 0),
                        ]),

                        Expanded(
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Center(
                                  child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                                    Text(
                                      item!.name ?? '', textAlign: TextAlign.center,
                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                    (Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                                        ? Image.asset(item!.veg == 0 ? Images.nonVegImage : Images.vegImage,
                                        height: 10, width: 10, fit: BoxFit.contain) : const SizedBox(),
                                  ]),
                                ),
                                const SizedBox(height: 2),

                                Text(
                                  item!.storeName ?? '', textAlign: TextAlign.center,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),

                                (Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && item!.unitType != null) ? Text(
                                  '(${item!.unitType ?? ''})', textAlign: TextAlign.center,
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                                ) : const SizedBox(),
                                const SizedBox(height: 2),
                               
                                Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                   if(item!.price==0.0)
                                 Flexible(child: Text(
                                    PriceConverter.convertPriceV2(item!.price),
                                     style: robotoMedium, textDirection: TextDirection.ltr,
                                  )) ,
                                   if(item!.price!=0.0)
                                  itemController.getDiscount(item!)! > 0  ? Flexible(child: Text(
                                    PriceConverter.convertPrice(itemController.getStartingPrice(item!)),
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  )) : const SizedBox(),
                                    if(item!.price!=0.0)
                                  SizedBox(width: item!.discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),
                                   if(item!.price!=0.0)
                                  Text(
                                    PriceConverter.convertPrice(
                                      itemController.getStartingPrice(item!), discount: itemController.getDiscount(item!),
                                      discountType: itemController.getDiscountType(item!),
                                    ),
                                    style: robotoMedium, textDirection: TextDirection.ltr,
                                  ),
                                ]),
                              ]),
                            ),
                            Positioned(bottom: 0, right: 0, child: Container(
                              height: 25, width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor
                              ),
                              child: const Icon(Icons.add, size: 20, color: Colors.white),
                            )),
                          ]),
                        ),

                      ]),
                    ),
                  
        ));
    }):
      InkWell(
      onTap: () {
        if(isStore) {
          if(store != null) {
            if(isFeatured && Get.find<SplashController>().moduleList != null) {
              for(ModuleModel module in Get.find<SplashController>().moduleList!) {
                if(module.id == store!.moduleId) {
                  Get.find<SplashController>().setModule(module);
                  break;
                }
              }
            }
            
            Get.toNamed(
              RouteHelper.getStoreRoute(id: store!.id, page: isFeatured ? 'module' : 'item'),
              arguments: StoreScreen(store: store, fromModule: isFeatured),
            );
          }
        }else {
          if(isFeatured && Get.find<SplashController>().moduleList != null) {
            for(ModuleModel module in Get.find<SplashController>().moduleList!) {
              if(module.id == item!.moduleId) {
                Get.find<SplashController>().setModule(module);
                break;
              }
            }
          }
          Get.find<ItemController>().navigateToItemPage(item, context, inStore: inStore, isCampaign: isCampaign);
        }
      },
        child: Stack(
          children: [
            Container(
              padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(fromCartSuggestion ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall) : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              margin: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5, offset: Offset(0, 0))],
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      
                Expanded(child: Padding(
                  padding: EdgeInsets.symmetric(vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
                  child: Row(children: [
      
                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: CustomImage(
                          image: '${isCampaign ? baseUrls!.campaignImageUrl : isStore ? baseUrls!.storeImageUrl
                              : baseUrls!.itemImageUrl}'
                              '/${isStore ? store != null ? store!.logo : '' : item!.image}',
                          height: imageHeight ?? (desktop ? 120 : length == null ? 100 : 65), width: imageWidth ?? (desktop ? 120 : 80), fit: BoxFit.cover,
                        ),
                      ),
      
                      (isStore || isCornerTag!) ? DiscountTag(
                        discount: discount, discountType: discountType,
                        freeDelivery: isStore ? store!.freeDelivery : false,
                      ) : const SizedBox(),
      
                      !isStore ? OrganicTag(item: item!, placeInImage: true) : const SizedBox(),
      
                      isAvailable ? const SizedBox() : NotAvailableWidget(isStore: isStore),
                    ]),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
      
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      
                        Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                          Text(
                            isStore ? store!.name! : item!.name!,
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            maxLines: desktop ? 2 : 1, overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
      
                          (!isStore && Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                              ? Image.asset(item != null && item!.veg == 0 ? Images.nonVegImage : Images.vegImage,
                              height: 10, width: 10, fit: BoxFit.contain) : const SizedBox(),
                        ]),
                        SizedBox(height: isStore ? Dimensions.paddingSizeExtraSmall : 0),
      
                        (isStore ? store!.address != null : item!.storeName != null) ? Text(
                          isStore ? store!.address ?? '' : item!.storeName ?? '',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).disabledColor,
                          ),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ) : const SizedBox(),
                        SizedBox(height: ((desktop || isStore) && (isStore ? store!.address != null : item!.storeName != null)) ? 5 : 0),
      
                        !isStore ? RatingBar(
                          rating: isStore ? store!.avgRating : item!.avgRating, size: desktop ? 15 : 12,
                          ratingCount: isStore ? store!.ratingCount : item!.ratingCount,
                        ) : const SizedBox(),
                        SizedBox(height: (!isStore && desktop) ? Dimensions.paddingSizeExtraSmall : 0),
                        if(Get.find<SplashController>().module!=null&&Get.find<SplashController>().module!.themeId!=3)
                        (Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && item != null && item!.unitType != null) ? Text(
                          '(${ item!.unitType ?? ''})',
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                        ) : const SizedBox(),
      
                        isStore ? RatingBar(
                          rating: isStore ? store!.avgRating : item!.avgRating, size: desktop ? 15 : 12,
                          ratingCount: isStore ? store!.ratingCount : item!.ratingCount,
                        ) : Row(children: [
                          if(item!.price==0.0)
                            Text(
                            PriceConverter.convertPriceV2(item!.price),
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).disabledColor,
                              // decoration: TextDecoration.lineThrough,
                            ),
                             textDirection: TextDirection.ltr,
                          ),
                           if(item!.price!=0.0)
                          Text(
                            PriceConverter.convertPrice(item!.price, discount: discount, discountType: discountType),
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                          ),
                           if(item!.price!=0.0)
                          SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),
                          if(item!.price!=0.0)
                          discount! > 0 ? Text(
                            PriceConverter.convertPrice(item!.price),
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).disabledColor,
                              decoration: TextDecoration.lineThrough,
                            ), textDirection: TextDirection.ltr,
                          ) : const SizedBox(),
                        ]),
      
                      ]),
                    ),
      
                    Column(mainAxisAlignment: isStore ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [
      
                      const SizedBox(),
      
                      fromCartSuggestion ? Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Icon(Icons.add, color: Theme.of(context).cardColor, size: 12),
                      ) : GetBuilder<WishListController>(builder: (wishController) {
                        bool isWished = isStore ? wishController.wishStoreIdList.contains(store!.id)
                            : wishController.wishItemIdList.contains(item!.id);
                        return Get.find<SplashController>().module!=null&& Get.find<SplashController>().module!.themeId!=3? InkWell(
                          onTap: !wishController.isRemoving ? () {
                            if(Get.find<AuthController>().isLoggedIn()) {
                              isWished ? wishController.removeFromWishList(isStore ? store!.id : item!.id, isStore)
                                  : wishController.addToWishList(item, store, isStore);
                            }else {
                              showCustomSnackBar('you_are_not_logged_in'.tr);
                            }
                          } : null,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
                            child: Icon(
                              isWished ? Icons.favorite : Icons.favorite_border,  size: desktop ? 30 : 25,
                              color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                            ),
                          ),
                        ):SizedBox.shrink();
                      }),
      
                    ]),
      
                  ]),
                )),
      
              ]),
            ),
      
            (!isStore && isCornerTag! == false) ? Positioned(
              right: ltr ? 0 : null, left: ltr ? null : 0,
              child: CornerDiscountTag(
                bannerPosition: ltr ? CornerBannerPosition.topRight : CornerBannerPosition.topLeft,
                elevation: 0,
                discount: discount, discountType: discountType,
                freeDelivery: isStore ? store!.freeDelivery : false,
            )) : const SizedBox(),
      
          ],
        ),
      );
    
    // Container();
      //  Container(
      //                 width: 160,
      //                 margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall,right:Dimensions.paddingSizeExtraSmall,left: Dimensions.paddingSizeExtraSmall ),
      //                 decoration: BoxDecoration(
      //                   color: Theme.of(context).cardColor,
      //                   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      //                   boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
      //                 ),
      //                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

      //                   Stack(children: [
      //                     ClipRRect(
      //                       borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
      //                       child: CustomImage(
      //                         image: '${isCampaign ? baseUrls!.campaignImageUrl : isStore ? baseUrls!.storeImageUrl
      //                       : baseUrls!.itemImageUrl}'
      //                       '/${isStore ? store != null ? store!.logo : '' : item!.image}',
      //                         height: 120, width: 160, fit: BoxFit.cover,
      //                       ),
      //                     ),
      //                     (isStore || isCornerTag!) ? DiscountTag(
      //                       discount: discount, discountType: discountType,
      //                       freeDelivery: isStore ? store!.freeDelivery : false,
      //                     ) : const SizedBox(),
      //                     // storeController.isOpenNow(storeList[index]) ? const SizedBox() : const NotAvailableWidget(isStore: true),
      //                     Positioned(
      //                       top: Dimensions.paddingSizeExtraSmall, right: Dimensions.paddingSizeExtraSmall,
      //                       child: GetBuilder<WishListController>(builder: (wishController) {
      //                         // bool isWished =wishController.wishItemIdList.contains(item!.id);
      //                         return InkWell(
      //                           // onTap: () {
      //                           //   if(Get.find<AuthController>().isLoggedIn()) {
      //                           //     isWished ? wishController.removeFromWishList(item!.id, false)
      //                           //         : wishController.addToWishList(item, null, true);
      //                           //   }else {
      //                           //     showCustomSnackBar('you_are_not_logged_in'.tr);
      //                           //   }
      //                           // },
      //                           // child: Container(
      //                           //   padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      //                           //   decoration: BoxDecoration(
      //                           //     color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      //                           //   ),
      //                           //   child: Icon(
      //                           //     isWished ? Icons.favorite : Icons.favorite_border,  size: 15,
      //                           //     color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
      //                           //   ),
      //                           // ),
      //                         );
      //                       }),
      //                     ),
      //                   ]),

      //                   Expanded(
      //                     child: Padding(
      //                       padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
      //                       child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      //                         // Text(
      //                         //   item!.name ?? '',
      //                         //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
      //                         //   maxLines: 1, overflow: TextOverflow.ellipsis,
      //                         // ),
      //                         const SizedBox(height: Dimensions.paddingSizeExtraSmall),

      //                         // Text(
      //                         //   storeList[index].address ?? '',
      //                         //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
      //                         //   maxLines: 1, overflow: TextOverflow.ellipsis,
      //                         // ),
      //                         const SizedBox(height: Dimensions.paddingSizeExtraSmall),

      //                         // RatingBar(
      //                         //   rating: item!.avgRating,
      //                         //   ratingCount: item!.ratingCount,
      //                         //   size: 12,
      //                         // ),
      //                       ]),
      //                     ),
      //                   ),

      //                 ]),
      //               );
                 
   
  
  }
}
