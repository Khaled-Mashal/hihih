import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/cart_widget.dart';
import 'package:sixam_mart/view/base/veg_filter_widget.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Function? onBackPressed;
  final bool showCart;
  final Function(String value)? onVegFilterTap;
  final String? type;
  final String? leadingIcon;
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.backButton = true,
      this.onBackPressed,
      this.showCart = false,
      this.leadingIcon,
      this.onVegFilterTap,
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? const WebMenuBar()
        : AppBar(
            title: Text(title,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  // color:Theme.of(context).textTheme.bodyLarge!.color
                  color: Colors.white,
                )),
            centerTitle: true,
            leading: backButton
                ? IconButton(
                    icon: leadingIcon != null
                        ? Image.asset(leadingIcon!, height: 22, width: 22)
                        : const Icon(Icons.arrow_back_ios),
                    // color: Theme.of(context).textTheme.bodyLarge!.color,
                    // color:Theme.of(context).textTheme.bodyLarge!.color
                    color: Colors.white,
                    onPressed: () => onBackPressed != null
                        ? onBackPressed!()
                        : Navigator.pop(context),
                  )
                : IconButton(
                    onPressed: () {
                      Get.back();
                      // Get.dialog(const SignUpScreen());
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
            // backgroundColor: Theme.of(context).cardColor,
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            actions: showCart || onVegFilterTap != null
                ? [
                    showCart
                        ? IconButton(
                            onPressed: () =>
                                Get.toNamed(RouteHelper.getCartRoute()),
                            icon: CartWidget(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                size: 25),
                          )
                        : const SizedBox(),
                    onVegFilterTap != null
                        ? VegFilterWidget(
                            type: type,
                            onSelected: onVegFilterTap,
                            fromAppBar: true,
                          )
                        : const SizedBox(),
                  ]
                : [const SizedBox()],
          );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 70 : 50);
}