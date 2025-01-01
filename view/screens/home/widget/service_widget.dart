import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/theme_controller.dart';
import 'package:sixam_mart/data/model/response/service_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';

class ServiceWidget extends StatelessWidget {
  const ServiceWidget(
      {Key? key, this.serviceMode, this.animationController, this.animation})
      : super(key: key);

  final ServiceMode? serviceMode;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          onTap: serviceMode!.phone != null
              ? () => FitnessAppTheme.openWhatsApp(serviceMode!.phone ?? '')
              : () => FitnessAppTheme.openChatDoctor(),
          child: SizedBox(
            // width: 100,
            height: 100,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall + 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[
                              Get.find<ThemeController>().darkTheme
                                  ? 800
                                  : 300]!,
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ],

                      // borderRadius: const BorderRadius.only(
                      //   bottomRight: Radius.circular(8.0),
                      //   bottomLeft: Radius.circular(8.0),
                      //   topLeft: Radius.circular(8.0),
                      //   topRight: Radius.circular(8.0),
                      // ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 0, right: 0, bottom: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            color: Colors.amber,
                            child: CustomImage(
                                image:
                                    '${Get.find<SplashController>().configModel!.baseUrls!.businessLogoUrl}/${serviceMode!.logo}',
                                width: 180,
                                height: 80),
                          ),

                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              serviceMode!.name,
                              textAlign: TextAlign.center,
                              style: robotoMedium.copyWith(fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          //  const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
