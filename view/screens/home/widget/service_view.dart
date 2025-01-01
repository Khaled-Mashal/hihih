import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/service_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceView extends StatefulWidget {
  const ServiceView({
    Key? key,
  }) : super(key: key);

  @override
  _ServiceViewState createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<ServiceMode> servicesListData = [];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    servicesListData = <ServiceMode>[
      if (Get.find<SplashController>().configModel!.asking_doctor_status == 1)
        ServiceMode(
            status: Get.find<SplashController>()
                    .configModel!
                    .asking_doctor_status ??
                0,
            name:
                Get.find<SplashController>().configModel!.asking_doctor_name ??
                    '',
            phone:
                Get.find<SplashController>().configModel!.asking_doctor_phone ??
                    '',
            logo:
                Get.find<SplashController>().configModel!.Ask_doctor_logo ?? '',
            onTap: () {}),
      // if (Get.find<SplashController>().configModel!.doctor_online_status == 1)
      //   ServiceMode(
      //       status: Get.find<SplashController>().configModel!.doctor_online_status ?? 0,
      //       name: Get.find<SplashController>().configModel!.doctor_online_name ?? '',
      //       phone: null,
      //       logo: Get.find<SplashController>().configModel!.Ask_doctor_logo ?? '',
      //       onTap: () {}),
    ];
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool desktop = ResponsiveHelper.isDesktop(context);
    return servicesListData.isNotEmpty
        ? servicesListData[0].status == 0
            ? const SizedBox.shrink()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: TitleWidget(title: 'services'.tr, onTap: null),
                  ),
                  SizedBox(
                    height: 195,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 0, bottom: 0),
                      child: GestureDetector(
                        onTap: () => FitnessAppTheme.openWhatsApp(
                            servicesListData[0].phone ?? ''),
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 800 : 300]!,
                                spreadRadius: 1,
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(children: [
                                  ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(
                                              Dimensions.radiusSmall)),
                                      child: CustomImage(
                                        image:
                                            '${Get.find<SplashController>().configModel!.baseUrls!.businessLogoUrl}/${servicesListData[0].logo}',
                                        // height: context.width * 0.3,
                                        height: 170,
                                        width: Dimensions.webMaxWidth,
                                        fit: BoxFit.cover,
                                      )),
                                ]),
                                // Expanded(
                                //     child: Padding(
                                //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                //   child: Row(children: [
                                //     Expanded(
                                //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                //         Text(
                                //           servicesListData[0].name,
                                //           style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                //           maxLines: desktop ? 2 : 1,
                                //           overflow: TextOverflow.ellipsis,
                                //         ),
                                //       ]),
                                //     ),
                                //     const SizedBox(width: Dimensions.paddingSizeSmall),
                                //   ]),
                                // )),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              )

        // Container(
        //     color: Colors.amber,
        //     height: 175,
        //     width: MediaQuery.of(context).size.width,
        //     child: Column(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        //           child: TitleWidget(title: 'services'.tr, onTap: null),
        //         ),
        //         Expanded(
        //           child: Row(
        //             children: [
        //               servicesListData[0].status == 1
        //                   ? GestureDetector(
        //                       onTap: () => FitnessAppTheme.openWhatsApp(servicesListData[0].phone ?? ''),
        //                       child: SizedBox(
        //                           child: Container(
        //                               padding: EdgeInsets.all(6),
        //                               child: Container(
        //                                 padding: EdgeInsets.all(2),
        //                                 decoration: BoxDecoration(
        //                                   color: Theme.of(context).cardColor,
        //                                   borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 3),
        //                                   boxShadow: [
        //                                     BoxShadow(
        //                                       color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!,
        //                                       blurRadius: 5,
        //                                       spreadRadius: 1,
        //                                     )
        //                                   ],
        //                                 ),
        //                                 child: Column(
        //                                   children: [
        //                                     CustomImage(
        //                                       image: '${Get.find<SplashController>().configModel!.baseUrls!.businessLogoUrl}/${servicesListData[0].logo}',
        //                                       width: 100,
        //                                       height: 80,
        //                                     ),
        //                                     const SizedBox(height: 5),
        //                                     Center(
        //                                       child: Text(
        //                                         servicesListData[0].name,
        //                                         textAlign: TextAlign.center,
        //                                         style: robotoMedium.copyWith(fontSize: 12),
        //                                         maxLines: 2,
        //                                         overflow: TextOverflow.ellipsis,
        //                                       ),
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ))),
        //                     )
        //                   : SizedBox.shrink(),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   )

        : const SizedBox.shrink();
  }
}
