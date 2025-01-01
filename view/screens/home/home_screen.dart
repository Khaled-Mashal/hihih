import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/banner_controller.dart';
import 'package:sixam_mart/controller/campaign_controller.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/notification_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/parcel_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/item_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/paginated_list_view.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/screens/home/theme1/best_reviewed_item_view.dart';
import 'package:sixam_mart/view/screens/home/theme1/item_campaign_view1.dart';
import 'package:sixam_mart/view/screens/home/theme1/theme1_home_screen.dart';
import 'package:sixam_mart/view/screens/home/theme2/theme2_home_screen.dart';
import 'package:sixam_mart/view/screens/home/web_home_screen.dart';
import 'package:sixam_mart/view/screens/home/widget/banner_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/home/widget/module_view.dart';
import 'package:sixam_mart/view/screens/home/widget/service_view.dart';
import 'package:sixam_mart/view/screens/parcel/parcel_category_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Future<void> loadData(bool reload) async {
    Get.find<LocationController>().syncZoneData();
    if (Get.find<SplashController>().module != null &&
        !Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<BannerController>().getBannerList(reload);
      Get.find<CategoryController>().getCategoryList(reload);
      Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      Get.find<CampaignController>().getItemCampaignList(reload);
      Get.find<ItemController>().getPopularItemList(reload, 'all', false);
      Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
      Get.find<ItemController>().getReviewedItemList(reload, 'all', false);
      Get.find<StoreController>().getStoreList(1, reload);
    }
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
    }
    Get.find<SplashController>().getModules();
    if (Get.find<SplashController>().module == null &&
        Get.find<SplashController>().configModel!.module == null) {
      Get.find<BannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<LocationController>().getAddressList();
      }
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    HomeScreen.loadData(false);
    if (!ResponsiveHelper.isWeb()) {
      Get.find<LocationController>().getZone(
          Get.find<LocationController>().getUserAddress()!.latitude,
          Get.find<LocationController>().getUserAddress()!.longitude,
          false,
          updateInAddress: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      bool showMobileModule = !ResponsiveHelper.isDesktop(context) &&
          splashController.module == null &&
          splashController.configModel!.module == null;
      bool isParcel = splashController.module != null &&
          splashController.configModel!.moduleConfig!.module!.isParcel!;
      // bool isTaxiBooking = splashController.module != null && splashController.configModel!.moduleConfig!.module!.isTaxi!;

      return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: /*isTaxiBooking ? const RiderHomeScreen() :*/ isParcel
            ? const ParcelCategoryScreen()
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (Get.find<SplashController>().module != null) {
                      await Get.find<LocationController>().syncZoneData(); //Z00
                      await Get.find<BannerController>().getBannerList(true);
                      await Get.find<CategoryController>()
                          .getCategoryList(true);
                      await Get.find<StoreController>()
                          .getPopularStoreList(true, 'all', false);
                      await Get.find<CampaignController>()
                          .getItemCampaignList(true);
                      await Get.find<ItemController>()
                          .getPopularItemList(true, 'all', false);
                      await Get.find<StoreController>()
                          .getLatestStoreList(true, 'all', false);
                      await Get.find<ItemController>()
                          .getReviewedItemList(true, 'all', false);
                      await Get.find<StoreController>().getStoreList(1, true);
                      if (Get.find<AuthController>().isLoggedIn()) {
                        await Get.find<UserController>().getUserInfo();
                        await Get.find<NotificationController>()
                            .getNotificationList(true);
                      }
                    } else {
                      await Get.find<BannerController>().getFeaturedBanner();
                      await Get.find<SplashController>().getModules();
                      if (Get.find<AuthController>().isLoggedIn()) {
                        await Get.find<LocationController>().getAddressList();
                      }
                      await Get.find<StoreController>().getFeaturedStoreList();
                    }
                  },
                  child: ResponsiveHelper.isDesktop(context)
                      ? WebHomeScreen(
                          scrollController: _scrollController,
                        )
                      : (Get.find<SplashController>().module != null &&
                              Get.find<SplashController>().module!.themeId == 3)
                          ? Theme2HomeScreen(
                              scrollController: _scrollController,
                              splashController: splashController,
                              showMobileModule: showMobileModule,
                            )
                          : (Get.find<SplashController>().module != null &&
                                  Get.find<SplashController>()
                                          .module!
                                          .themeId ==
                                      2)
                              ? Theme1HomeScreen(
                                  scrollController: _scrollController,
                                  splashController: splashController,
                                  showMobileModule: showMobileModule,
                                )
                              : CustomScrollView(
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    // App Bar
                                    SliverAppBar(
                                      floating: true,
                                      elevation: 0,
                                      automaticallyImplyLeading: false,
                                      backgroundColor:
                                          ResponsiveHelper.isDesktop(context)
                                              ? Colors.transparent
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                      title: Center(
                                          child: Container(
                                        width: Dimensions.webMaxWidth,
                                        height: 50,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: Row(
                                          children: [
                                            (splashController.module != null &&
                                                    splashController
                                                            .configModel!
                                                            .module ==
                                                        null)
                                                ? InkWell(
                                                    onTap: () =>
                                                        splashController
                                                            .removeModule(),
                                                    child: Image.asset(
                                                        Images.moduleIcon,
                                                        height: 24,
                                                        width: 24,
                                                        color: Colors.white),
                                                  )
                                                : const SizedBox(),
                                            SizedBox(
                                                width: (splashController
                                                                .module !=
                                                            null &&
                                                        splashController
                                                                .configModel!
                                                                .module ==
                                                            null)
                                                    ? Dimensions
                                                        .paddingSizeExtraSmall
                                                    : 0),
                                            Expanded(
                                                child: InkWell(
                                              onTap: () =>
                                                  Get.find<LocationController>()
                                                      .navigateToLocationScreen(
                                                          'home'),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: Dimensions
                                                      .paddingSizeSmall,
                                                  horizontal: ResponsiveHelper
                                                          .isDesktop(context)
                                                      ? Dimensions
                                                          .paddingSizeSmall
                                                      : 0,
                                                ),
                                                child: GetBuilder<
                                                        LocationController>(
                                                    builder:
                                                        (locationController) {
                                                  return Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        locationController
                                                                    .getUserAddress()!
                                                                    .addressType ==
                                                                'home'
                                                            ? Icons.home_filled
                                                            : locationController
                                                                        .getUserAddress()!
                                                                        .addressType ==
                                                                    'office'
                                                                ? Icons.work
                                                                : Icons
                                                                    .location_on,
                                                        size: 24,
                                                        color: Colors.white,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Flexible(
                                                        child: Text(
                                                          locationController
                                                              .getUserAddress()!
                                                              .address!,
                                                          style: robotoRegular
                                                              .copyWith(
                                                            color: Colors.white,
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      const Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.white),
                                                    ],
                                                  );
                                                }),
                                              ),
                                            )),
                                            InkWell(
                                              child: GetBuilder<
                                                      NotificationController>(
                                                  builder:
                                                      (notificationController) {
                                                return Stack(children: [
                                                  const Icon(
                                                      Icons.notifications,
                                                      size: 29,
                                                      color: Colors.white),
                                                  notificationController
                                                          .hasNotification
                                                      ? Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child: Container(
                                                            height: 10,
                                                            width: 10,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor),
                                                            ),
                                                          ))
                                                      : const SizedBox(),
                                                ]);
                                              }),
                                              onTap: () => Get.toNamed(
                                                  RouteHelper
                                                      .getNotificationRoute()),
                                            ),
                                            InkWell(child: GetBuilder<
                                                    NotificationController>(
                                                builder:
                                                    (notificationController) {
                                              return Stack(children: [
                                                const Icon(Icons.chat,
                                                    size: 29,
                                                    color: Colors.white),
                                                notificationController
                                                        .hasNotification
                                                    ? Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                          height: 10,
                                                          width: 10,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor),
                                                          ),
                                                        ))
                                                    : const SizedBox(),
                                              ]);
                                            }), onTap: () {
                                              {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          'تواصل معنا',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: <Widget>[
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    try {
                                                                      await launch(
                                                                          'tel:781661669');
                                                                    } catch (e) {
                                                                      print(
                                                                          'Error launching phone app: $e');
                                                                    }
                                                                  },
                                                                  child:
                                                                      CustommButton(
                                                                    icon: Icons
                                                                        .phone,
                                                                    title:
                                                                        'الهاتف'
                                                                            .tr,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    info: '',
                                                                    onTap:
                                                                        () async {
                                                                      try {
                                                                        await launch(
                                                                            'tel:781661669');
                                                                      } catch (e) {
                                                                        print(
                                                                            'Error launching phone app: $e');
                                                                      }
                                                                    },
                                                                    iconColor:
                                                                        Colors
                                                                            .green,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    try {
                                                                      await launch(
                                                                          'tel:781661665');
                                                                    } catch (e) {
                                                                      print(
                                                                          'Error launching phone app: $e');
                                                                    }
                                                                  },
                                                                  child:
                                                                      CustommButton(
                                                                    icon: Icons
                                                                        .phone,
                                                                    title:
                                                                        'الهاتف(2)'
                                                                            .tr,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    info: '',
                                                                    onTap:
                                                                        () async {
                                                                      try {
                                                                        await launch(
                                                                            'tel:781661665');
                                                                      } catch (e) {
                                                                        print(
                                                                            'Error launching phone app: $e');
                                                                      }
                                                                    },
                                                                    iconColor:
                                                                        Colors
                                                                            .green,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                                CustommButton(
                                                                  icon: MdiIcons
                                                                      .whatsapp,
                                                                  title:
                                                                      'واتساب',
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  info: "",
                                                                  onTap:
                                                                      () async {
                                                                    var whatsappUrl =
                                                                        "whatsapp://send?phone=+967781661669";
                                                                    await canLaunch(
                                                                            whatsappUrl)
                                                                        ? launch(
                                                                            whatsappUrl)
                                                                        : '';
                                                                  },
                                                                  iconColor:
                                                                      Colors
                                                                          .green,
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                                CustommButton(
                                                                  icon: MdiIcons
                                                                      .facebook,
                                                                  title:
                                                                      'فيسبوك',
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  info: "",
                                                                  onTap:
                                                                      () async {
                                                                    var facebookUrl =
                                                                        "https://www.facebook.com/profile.php?id=61557100772272";
                                                                    await canLaunch(
                                                                            facebookUrl)
                                                                        ? launch(
                                                                            facebookUrl)
                                                                        : '';
                                                                  },
                                                                  iconColor:
                                                                      Colors
                                                                          .blue,
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                                CustommButton(
                                                                  icon: MdiIcons
                                                                      .instagram,
                                                                  title:
                                                                      'انستقرام',
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  info: "",
                                                                  onTap:
                                                                      () async {
                                                                    var instagramUrl =
                                                                        "https://www.instagram.com/talabatak_express?igsh=NTc4MTIwNjQ2YQ==";
                                                                    await canLaunch(
                                                                            instagramUrl)
                                                                        ? launch(
                                                                            instagramUrl)
                                                                        : '';
                                                                  },
                                                                  iconColor:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                                // CustommButton(
                                                                //   icon: Icons.location_on,
                                                                //   title: 'address'.tr,
                                                                //   color: Theme.of(context).primaryColor,
                                                                //   info: Get.find<SplashController>().configModel!.address ?? 'Address not available',
                                                                //   onTap: () {}, iconColor: Colors.white,
                                                                // ),
                                                                const SizedBox(
                                                                    height:
                                                                        8.0),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        actions: const [
                                                          // ElevatedButton(
                                                          //   child: Text("Submit"),
                                                          //   onPressed: () {
                                                          //     // your code
                                                          //   },
                                                          // )
                                                        ],
                                                      );
                                                    });
                                              }
                                            }),
                                            SizedBox(
                                                width: (splashController
                                                                .module !=
                                                            null &&
                                                        splashController
                                                                .configModel!
                                                                .module ==
                                                            null)
                                                    ? Dimensions
                                                        .paddingSizeExtraSmall
                                                    : 0),
                                            (splashController.module != null &&
                                                    splashController
                                                            .configModel!
                                                            .module ==
                                                        null)
                                                ? InkWell(
                                                    child: GetBuilder<
                                                            NotificationController>(
                                                        builder:
                                                            (notificationController) {
                                                      return const Icon(
                                                          Icons.qr_code_scanner,
                                                          size: 29,
                                                          color: Colors.white);
                                                    }),
                                                    onTap: () => Get.toNamed(
                                                        RouteHelper
                                                            .getQRScreen()),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      )),
                                      actions: const [SizedBox()],
                                    ),

                                    // Search Button
                                    !showMobileModule
                                        ? SliverPersistentHeader(
                                            pinned: true,
                                            delegate: SliverDelegate(
                                                child: Center(
                                                    child: Container(
                                              height: 50,
                                              width: Dimensions.webMaxWidth,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall),
                                              child: InkWell(
                                                onTap: () => Get.toNamed(
                                                    RouteHelper
                                                        .getSearchRoute()),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusSmall),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.black12,
                                                          spreadRadius: 1,
                                                          blurRadius: 5)
                                                    ],
                                                  ),
                                                  child: Row(children: [
                                                    Icon(
                                                      Icons.search,
                                                      size: 25,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    const SizedBox(
                                                        width: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    Expanded(
                                                        child: Text(
                                                      Get.find<SplashController>()
                                                              .configModel!
                                                              .moduleConfig!
                                                              .module!
                                                              .showRestaurantText!
                                                          ? 'search_food_or_restaurant'
                                                              .tr
                                                          : 'search_item_or_store'
                                                              .tr,
                                                      style: robotoRegular
                                                          .copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeSmall,
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                      ),
                                                    )),
                                                  ]),
                                                ),
                                              ),
                                            ))),
                                          )
                                        : const SliverToBoxAdapter(),

                                    SliverToBoxAdapter(
                                      child: Center(
                                          child: SizedBox(
                                        width: Dimensions.webMaxWidth,
                                        child: !showMobileModule
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    const BannerView(
                                                        isFeatured: false),
                                                    if (Get.find<SplashController>()
                                                                .module !=
                                                            null &&
                                                        Get.find<SplashController>()
                                                                .module!
                                                                .id ==
                                                            2 &&
                                                        (Get.find<SplashController>()
                                                                    .configModel!
                                                                    .asking_doctor_status ==
                                                                1 ||
                                                            Get.find<SplashController>()
                                                                    .configModel!
                                                                    .doctor_online_status ==
                                                                1))
                                                      const ServiceView(),

                                                    // const CategoryView(),
                                                    //remove  // const PopularStoreView(isPopular: true, isFeatured: false),

                                                    //remove   // const PopularItemView(isPopular: true),
                                                    //remove   // const PopularStoreView(isPopular: false, isFeatured: false),

                                                    //change  // const PopularItemView(isPopular: false),
                                                    const BestReviewedItemView(),

                                                    //change  // const ItemCampaignView(),
                                                    const ItemCampaignView1(),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 15, 10, 5),
                                                      child: Row(children: [
                                                        Expanded(
                                                            child: Text(
                                                          Get.find<SplashController>()
                                                                  .configModel!
                                                                  .moduleConfig!
                                                                  .module!
                                                                  .showRestaurantText!
                                                              ? 'all_restaurants'
                                                                  .tr
                                                              : 'all_stores'.tr,
                                                          style: robotoMedium
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeLarge),
                                                        )),
                                                        // const FilterView(),
                                                      ]),
                                                    ),

                                                    GetBuilder<StoreController>(
                                                        builder:
                                                            (storeController) {
                                                      return PaginatedListView(
                                                        scrollController:
                                                            _scrollController,
                                                        totalSize: storeController
                                                                    .storeModel !=
                                                                null
                                                            ? storeController
                                                                .storeModel!
                                                                .totalSize
                                                            : null,
                                                        offset: storeController
                                                                    .storeModel !=
                                                                null
                                                            ? storeController
                                                                .storeModel!
                                                                .offset
                                                            : null,
                                                        onPaginate: (int?
                                                            offset) async {
                                                          await storeController
                                                              .getStoreList(
                                                                  offset!,
                                                                  false);
                                                        },
                                                        itemView: ItemsView(
                                                          isStore: true,
                                                          items: null,
                                                          stores: storeController
                                                                      .storeModel !=
                                                                  null
                                                              ? storeController
                                                                  .storeModel!
                                                                  .stores
                                                              : null,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: ResponsiveHelper
                                                                    .isDesktop(
                                                                        context)
                                                                ? Dimensions
                                                                    .paddingSizeExtraSmall
                                                                : Dimensions
                                                                    .paddingSizeSmall,
                                                            vertical: ResponsiveHelper
                                                                    .isDesktop(
                                                                        context)
                                                                ? Dimensions
                                                                    .paddingSizeExtraSmall
                                                                : 0,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ])
                                            : Column(
                                                children: [
                                                  ModuleView(
                                                      splashController:
                                                          splashController),
                                                  // SizedBox(height: 10),
                                                  // ModuleView(splashController: splashController,isService: true),
                                                ],
                                              ),
                                      )),
                                    ),
                                  ],
                                ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.back();
            Get.toNamed(RouteHelper.getConversationRoute());
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.chat,
            color: Colors.white, // Set the color to white
          ),
        ),
      );
    });
  }
}

class CustommButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String info;
  final Color color;
  final Color iconColor; // New parameter for specifying icon color
  final VoidCallback onTap;

  const CustommButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.info,
    required this.color,
    required this.iconColor, // Updated constructor to accept iconColor
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0, // Adjust the height as needed
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25), // Adjust radius as needed
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor, // Use the provided icon color
            ),
            const SizedBox(
              width: 5.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage:
/*
SupportButton(
  icon: Icons.help_outline,
  title: 'Support',
  info: 'Tap for assistance',
  color: Colors.blue,
  onTap: () {
    // Action when the support button is tapped
  },
)
*/

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
