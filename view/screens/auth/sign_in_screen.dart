import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/custom_validator.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/custom_text_field.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/screens/auth/widget/condition_check_box.dart';
import 'package:sixam_mart/view/screens/auth/widget/guest_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/model/body/signup_body.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  const SignInScreen(
      {Key? key, required this.exitFromApp, required this.backFromThis})
      : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _countryDialCode;
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();
    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel!.country!)
        .dialCode;
    if (Get.find<AuthController>().showPassView) {
      Get.find<AuthController>().showHidePass(isUpdate: false);
    }

    _countryDialCode =
        Get.find<AuthController>().getUserCountryCode().isNotEmpty
            ? Get.find<AuthController>().getUserCountryCode()
            : CountryCode.fromCountryCode(
                    Get.find<SplashController>().configModel!.country!)
                .dialCode;
    _phoneController.text = Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
    if (Get.find<AuthController>().showPassView) {
      Get.find<AuthController>().showHidePass(isUpdate: false);
    }
  }

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  // final FocusNode _phoneFocus = FocusNode();
  // final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  // String? _countryDialCode;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
            return Future.value(false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: const TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            ));
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
            return Future.value(false);
          }
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: ResponsiveHelper.isDesktop(context)
            ? Colors.transparent
            : Theme.of(context).cardColor,
        appBar: (ResponsiveHelper.isDesktop(context)
            ? null
            : !widget.exitFromApp
                ? AppBar(
                    leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    actions: const [SizedBox()],
                  )
                : null),
        endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
        body: SafeArea(
            child: Scrollbar(
          child: Center(
            child: Container(
              width: context.width > 700 ? 700 : context.width,
              padding: context.width > 700
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.all(Dimensions.paddingSizeLarge),
              margin: context.width > 700
                  ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                  : null,
              decoration: context.width > 700
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
                    )
                  : null,
              child: GetBuilder<AuthController>(builder: (authController) {
                // ResponsiveHelper.isDesktop(context) ? Align(
                //   alignment: Alignment.topRight,
                //   child: IconButton(
                //     onPressed: () => Get.back(),
                //     icon: const Icon(Icons.clear),
                //   ),
                // ) : const SizedBox(),

                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      ResponsiveHelper.isDesktop(context)
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () => Get.back(),
                                  icon: const Icon(Icons.clear),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: ResponsiveHelper.isDesktop(context)
                            ? const EdgeInsets.all(40)
                            : EdgeInsets.zero,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(Images.logo, width: 125),
                              // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              // Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),
                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge),

                              Align(
                                alignment: Alignment.topRight,
                                child: Text('sign_up'.tr,
                                    style: robotoBold.copyWith(
                                        fontSize:
                                            Dimensions.fontSizeExtraLarge)),
                              ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeDefault),

                              Row(children: [
                                Expanded(
                                  child: CustomTextField(
                                    titleText: 'first_name'.tr,
                                    hintText: 'ex_jhon'.tr,
                                    controller: _firstNameController,
                                    focusNode: _firstNameFocus,
                                    nextFocus: _lastNameFocus,
                                    inputType: TextInputType.name,
                                    capitalization: TextCapitalization.words,
                                    prefixIcon: Icons.person,
                                    showTitle:
                                        ResponsiveHelper.isDesktop(context),
                                  ),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Expanded(
                                  child: CustomTextField(
                                    titleText: 'last_name'.tr,
                                    hintText: 'ex_doe'.tr,
                                    controller: _lastNameController,
                                    focusNode: _lastNameFocus,
                                    nextFocus:
                                        ResponsiveHelper.isDesktop(context)
                                            ? _emailFocus
                                            : _phoneFocus,
                                    inputType: TextInputType.name,
                                    capitalization: TextCapitalization.words,
                                    prefixIcon: Icons.person,
                                    showTitle:
                                        ResponsiveHelper.isDesktop(context),
                                  ),
                                )
                              ]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),

                              Row(children: [
                                ResponsiveHelper.isDesktop(context)
                                    ? Expanded(
                                        child: CustomTextField(
                                          titleText: 'email'.tr,
                                          hintText: 'enter_email'.tr,
                                          controller: _emailController,
                                          focusNode: _emailFocus,
                                          nextFocus: ResponsiveHelper.isDesktop(
                                                  context)
                                              ? _phoneFocus
                                              : _passwordFocus,
                                          inputType: TextInputType.emailAddress,
                                          prefixImage: Images.mail,
                                          showTitle: ResponsiveHelper.isDesktop(
                                              context),
                                        ),
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                    width: ResponsiveHelper.isDesktop(context)
                                        ? Dimensions.paddingSizeSmall
                                        : 0),
                                Expanded(
                                  child: CustomTextField(
                                    titleText:
                                        ResponsiveHelper.isDesktop(context)
                                            ? 'phone'.tr
                                            : 'enter_phone_number'.tr,
                                    controller: _phoneController,
                                    focusNode: _phoneFocus,
                                    nextFocus:
                                        ResponsiveHelper.isDesktop(context)
                                            ? _passwordFocus
                                            : _emailFocus,
                                    inputType: TextInputType.phone,
                                    isPhone: true,
                                    showTitle:
                                        ResponsiveHelper.isDesktop(context),
                                    onCountryChanged:
                                        (CountryCode countryCode) {
                                      _countryDialCode = countryCode.dialCode;
                                    },
                                    countryDialCode: _countryDialCode != null
                                        ? CountryCode.fromCountryCode(
                                                Get.find<SplashController>()
                                                    .configModel!
                                                    .country!)
                                            .code
                                        : Get.find<LocalizationController>()
                                            .locale
                                            .countryCode,
                                  ),
                                ),
                              ]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                              Row(children: [
                                Expanded(
                                  child: ListTile(
                                    onTap: () =>
                                        authController.toggleRememberMe(),
                                    leading: Checkbox(
                                      visualDensity: const VisualDensity(
                                          horizontal: -4, vertical: -4),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: authController.isActiveRememberMe,
                                      onChanged: (bool? isChecked) =>
                                          authController.toggleRememberMe(),
                                    ),
                                    title: Text('remember_me'.tr),
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(
                                        horizontal: 0, vertical: -4),
                                    dense: true,
                                    horizontalTitleGap: 0,
                                  ),
                                ),

                                // TextButton(
                                //   onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute(false, null)),
                                //   child: Text('${'forgot_password'.tr}?', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
                                // ),
                              ]),
                              // !ResponsiveHelper.isDesktop(context) ? CustomTextField(
                              //   titleText: 'email'.tr,
                              //   hintText: 'enter_email'.tr,
                              //   controller: _emailController,
                              //   focusNode: _emailFocus,
                              //   nextFocus: _passwordFocus,
                              //   inputType: TextInputType.emailAddress,
                              //   prefixIcon: Icons.mail,
                              // ) : const SizedBox(),
                              // SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),

                              // Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                              //   Expanded(
                              //     child: Column(children: [
                              //       CustomTextField(
                              //         titleText: 'password'.tr,
                              //         hintText: '8_character'.tr,
                              //         controller: _passwordController,
                              //         focusNode: _passwordFocus,
                              //         nextFocus: _confirmPasswordFocus,
                              //         inputType: TextInputType.visiblePassword,
                              //         prefixIcon: Icons.lock,
                              //         isPassword: true,
                              //         showTitle: ResponsiveHelper.isDesktop(context),
                              //         onChanged: (value){
                              //           if(value != null && value.isNotEmpty){
                              //             if(!authController.showPassView){
                              //               authController.showHidePass();
                              //             }
                              //             authController.validPassCheck(value);
                              //           }else{
                              //             if(authController.showPassView){
                              //               authController.showHidePass();
                              //             }
                              //           }
                              //         },
                              //       ),
                              //
                              //       authController.showPassView ? const PassView() : const SizedBox(),
                              //     ]),
                              //   ),
                              //   SizedBox(width: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),
                              //
                              //   ResponsiveHelper.isDesktop(context) ? Expanded(child: CustomTextField(
                              //     titleText: 'confirm_password'.tr,
                              //     hintText: '8_character'.tr,
                              //     controller: _confirmPasswordController,
                              //     focusNode: _confirmPasswordFocus,
                              //     nextFocus: Get.find<SplashController>().configModel!.refEarningStatus == 1 ? _referCodeFocus : null,
                              //     inputAction: Get.find<SplashController>().configModel!.refEarningStatus == 1 ? TextInputAction.next : TextInputAction.done,
                              //     inputType: TextInputType.visiblePassword,
                              //     prefixIcon: Icons.lock,
                              //     isPassword: true,
                              //     showTitle: ResponsiveHelper.isDesktop(context),
                              //     onSubmit: (text) => (GetPlatform.isWeb) ? _register(authController, _countryDialCode!) : null,
                              //   )) : const SizedBox()
                              //
                              // ]),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                              //
                              // !ResponsiveHelper.isDesktop(context) ? CustomTextField(
                              //   titleText: 'confirm_password'.tr,
                              //   hintText: '8_character'.tr,
                              //   controller: _confirmPasswordController,
                              //   focusNode: _confirmPasswordFocus,
                              //   nextFocus: Get.find<SplashController>().configModel!.refEarningStatus == 1 ? _referCodeFocus : null,
                              //   inputAction: Get.find<SplashController>().configModel!.refEarningStatus == 1 ? TextInputAction.next : TextInputAction.done,
                              //   inputType: TextInputType.visiblePassword,
                              //   prefixIcon: Icons.lock,
                              //   isPassword: true,
                              //   onSubmit: (text) => (GetPlatform.isWeb) ? _register(authController, _countryDialCode!) : null,
                              // ) : const SizedBox(),
                              // SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),
                              //
                              // (Get.find<SplashController>().configModel!.refEarningStatus == 1 ) ? CustomTextField(
                              //   titleText: 'refer_code'.tr,
                              //   hintText: 'enter_refer_code'.tr,
                              //   controller: _referCodeController,
                              //   focusNode: _referCodeFocus,
                              //   inputAction: TextInputAction.done,
                              //   inputType: TextInputType.text,
                              //   capitalization: TextCapitalization.words,
                              //   prefixImage: Images.referCode,
                              //   prefixSize: 14,
                              //   showTitle: ResponsiveHelper.isDesktop(context),
                              // ) : const SizedBox(),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),

                              ConditionCheckBox(
                                  authController: authController,
                                  fromSignUp: true),
                              const SizedBox(
                                  height: Dimensions.paddingSizeLarge),
                              // CustomButton(
                              //   height: ResponsiveHelper.isDesktop(context) ? 45 : null,
                              //   width:  ResponsiveHelper.isDesktop(context) ? 180 : null,
                              //   buttonText: ResponsiveHelper.isDesktop(context) ? 'login' : 'sign_in'.tr,
                              //   onPressed: () => _login(authController, _countryDialCode!),
                              //   isLoading: authController.isLoading,
                              //   radius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : Dimensions.radiusDefault,
                              //   isBold: !ResponsiveHelper.isDesktop(context),
                              //   fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraSmall : null,
                              // ),

                              CustomButton(
                                height: ResponsiveHelper.isDesktop(context)
                                    ? 45
                                    : null,
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 180
                                    : null,
                                radius: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.radiusSmall
                                    : Dimensions.radiusDefault,
                                isBold: !ResponsiveHelper.isDesktop(context),
                                fontSize: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.fontSizeExtraSmall
                                    : null,
                                buttonText: 'sign_up'.tr,
                                isLoading: authController.isLoading,
                                onPressed: authController.acceptTerms
                                    ? () => _register(
                                        authController, _countryDialCode!)
                                    : null,
                              ),
                              const Padding(padding: EdgeInsets.all(1)),

                              CustomButton(
                                height: ResponsiveHelper.isDesktop(context)
                                    ? 45
                                    : null,
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 180
                                    : null,
                                radius: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.radiusSmall
                                    : Dimensions.radiusDefault,
                                isBold: !ResponsiveHelper.isDesktop(context),
                                fontSize: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.fontSizeExtraSmall
                                    : null,
                                buttonText: '${'forgot_password'.tr}?',
                                isLoading: authController.isLoading,
                                onPressed: () => Get.toNamed(
                                    RouteHelper.getForgotPassRoute(
                                        false, null)),
                              ),
                              // CustomButton(
                              //   height: ResponsiveHelper.isDesktop(context) ? 45 : null,
                              //   width:  ResponsiveHelper.isDesktop(context) ? 180 : null,
                              //   radius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : Dimensions.radiusDefault,
                              //   isBold: !ResponsiveHelper.isDesktop(context),
                              //   fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraSmall : null,
                              //   buttonText: 'sign_up'.tr,
                              //   isLoading: authController.isLoading,
                              //   onPressed:(){
                              //     authController.acceptTerms ? () => _register(authController, _countryDialCode!) : null;
                              //     // _login(authController, _countryDialCode!);
                              //     },
                              // ),

                              const SizedBox(
                                  height: Dimensions.paddingSizeExtraLarge),

                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ResponsiveHelper.isDesktop(context)
                                        ? const SizedBox()
                                        : const GuestButton(),
                                  ]),
                            ]),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        )),

        // SafeArea(child: Scrollbar(
        //   child: Center(
        //     child: Container(
        //       height: ResponsiveHelper.isDesktop(context) ? 690 : null,
        //       width: context.width > 700 ? 500 : context.width,
        //       padding: context.width > 700 ? const EdgeInsets.symmetric(horizontal: 0) : const EdgeInsets.all(Dimensions.paddingSizeExtremeLarge),
        //       //margin: context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : EdgeInsets.zero,
        //       decoration: context.width > 700 ? BoxDecoration(
        //         color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        //         boxShadow: ResponsiveHelper.isDesktop(context) ? null : [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
        //       ) : null,
        //       child: GetBuilder<AuthController>(builder: (authController) {
        //         return Center(
        //             child: SingleChildScrollView(
        //               child: Stack(
        //                 children: [
        //                   ResponsiveHelper.isDesktop(context) ? Positioned(
        //                     top: 0,
        //                     right: 0,
        //                     child: Align(
        //                       alignment: Alignment.topRight,
        //                       child: IconButton(
        //                         padding: EdgeInsets.zero,
        //                         onPressed: () => Get.back(),
        //                         icon: const Icon(Icons.clear),
        //                       ),
        //                     ),
        //                   ) : const SizedBox(),
        //
        //                   Padding(
        //                     padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.all(40) : EdgeInsets.zero,
        //                     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //                       Image.asset(Images.logo, width: 125),
        //                       // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        //                       // Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),
        //                       const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        //
        //                       Align(
        //                         alignment: Get.find<LocalizationController>().isLtr ? Alignment.topLeft : Alignment.topRight,
        //                         child: Text('sign_in'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
        //                       ),
        //                       const SizedBox(height: Dimensions.paddingSizeDefault),
        //
        //                       CustomTextField(
        //                         titleText: ResponsiveHelper.isDesktop(context) ? 'phone'.tr : 'enter_phone_number'.tr,
        //                         hintText: '',
        //                         controller: _phoneController,
        //                         focusNode: _phoneFocus,
        //                         nextFocus: _passwordFocus,
        //                         inputType: TextInputType.phone,
        //                         isPhone: true,
        //                         showTitle: ResponsiveHelper.isDesktop(context),
        //                         onCountryChanged: (CountryCode countryCode) {
        //                           _countryDialCode = countryCode.dialCode;
        //                         },
        //                         countryDialCode: _countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
        //                       ),
        //                       const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        //
        //                       CustomTextField(
        //                         titleText: ResponsiveHelper.isDesktop(context) ? 'password'.tr : 'enter_your_password'.tr,
        //                         hintText: 'enter_your_password'.tr,
        //                         controller: _passwordController,
        //                         focusNode: _passwordFocus,
        //                         inputAction: TextInputAction.done,
        //                         inputType: TextInputType.visiblePassword,
        //                         prefixIcon: Icons.lock,
        //                         isPassword: true,
        //                         showTitle: ResponsiveHelper.isDesktop(context),
        //                         onSubmit: (text) => (GetPlatform.isWeb) ? _login(authController, _countryDialCode!) : null,
        //                         onChanged: (value){
        //                           if(value != null && value.isNotEmpty){
        //                             if(!authController.showPassView){
        //                               authController.showHidePass();
        //                             }
        //                             authController.validPassCheck(value);
        //                           }else{
        //                             if(authController.showPassView){
        //                               authController.showHidePass();
        //                             }
        //                           }
        //                         },
        //                       ),
        //                       const SizedBox(height: Dimensions.paddingSizeSmall),
        //
        //
        //                       Row(children: [
        //                         Expanded(
        //                           child: ListTile(
        //                             onTap: () => authController.toggleRememberMe(),
        //                             leading: Checkbox(
        //                               visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        //                               activeColor: Theme.of(context).primaryColor,
        //                               value: authController.isActiveRememberMe,
        //                               onChanged: (bool? isChecked) => authController.toggleRememberMe(),
        //                             ),
        //                             title: Text('remember_me'.tr),
        //                             contentPadding: EdgeInsets.zero,
        //                             visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        //                             dense: true,
        //                             horizontalTitleGap: 0,
        //                           ),
        //                         ),
        //                         TextButton(
        //                           onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute(false, null)),
        //                           child: Text('${'forgot_password'.tr}?', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
        //                         ),
        //                       ]),
        //                       const SizedBox(height: Dimensions.paddingSizeLarge),
        //
        //                       Align(
        //                           alignment: Alignment.center,
        //                           child: ConditionCheckBox(authController: authController, fromSignUp: false)
        //                       ),
        //
        //                       const SizedBox(height: Dimensions.paddingSizeDefault),
        //
        //                       CustomButton(
        //                         height: ResponsiveHelper.isDesktop(context) ? 45 : null,
        //                         width:  ResponsiveHelper.isDesktop(context) ? 180 : null,
        //                         buttonText: ResponsiveHelper.isDesktop(context) ? 'login' : 'sign_in'.tr,
        //                         onPressed: () => _login(authController, _countryDialCode!),
        //                         isLoading: authController.isLoading,
        //                         radius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : Dimensions.radiusDefault,
        //                         isBold: !ResponsiveHelper.isDesktop(context),
        //                         fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraSmall : null,
        //                       ),
        //                       const SizedBox(height: Dimensions.paddingSizeDefault),
        //
        //                       ResponsiveHelper.isDesktop(context) ? const SizedBox() :
        //                       Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //
        //                         Text('or'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
        //                         const SizedBox(height: Dimensions.paddingSizeDefault),
        //                         CustomButton(
        //                         height: ResponsiveHelper.isDesktop(context) ? 45 : null,
        //                         width:  ResponsiveHelper.isDesktop(context) ? 180 : null,
        //                         buttonText: 'sign_up'.tr,
        //                         onPressed: ()  {
        //                             if(ResponsiveHelper.isDesktop(context)){
        //                               Get.back();
        //                               Get.dialog(const SignUpScreen());
        //                             }else{
        //                               Get.toNamed(RouteHelper.getSignUpRoute());
        //                             }
        //                           },
        //                         // isLoading: authController.isLoading,
        //                         radius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : Dimensions.radiusDefault,
        //                         isBold: !ResponsiveHelper.isDesktop(context),
        //                         fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraSmall : null,
        //                       ),
        //                         // InkWell(
        //                         //   onTap: () {
        //                         //     if(ResponsiveHelper.isDesktop(context)){
        //                         //       Get.back();
        //                         //       Get.dialog(const SignUpScreen());
        //                         //     }else{
        //                         //       Get.toNamed(RouteHelper.getSignUpRoute());
        //                         //     }
        //                         //   },
        //                         //   child: Padding(
        //                         //     padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        //                         //     child: Text('sign_up'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
        //                         //   ),
        //                         // ),
        //                       ]),
        //                       const SizedBox(height: Dimensions.paddingSizeSmall),
        //
        //                       const SocialLoginWidget(),
        //
        //                       ResponsiveHelper.isDesktop(context) ? const SizedBox() : const GuestButton(),
        //
        //                       ResponsiveHelper.isDesktop(context) ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        //                         Text('do_not_have_account'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
        //
        //                         InkWell(
        //                           onTap: () {
        //                             if(ResponsiveHelper.isDesktop(context)){
        //                               Get.back();
        //                               Get.dialog(const SignUpScreen());
        //                             }else{
        //                               Get.toNamed(RouteHelper.getSignUpRoute());
        //                             }
        //                           },
        //                           child: Padding(
        //                             padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        //                             child: Text('sign_up'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
        //                           ),
        //                         ),
        //                       ]) :  const SizedBox(),
        //
        //                     ]),
        //                   )
        //                 ],
        //               ),
        //             ),
        //           );
        //       }),
        //     ),
        //   ),
        // )),
      ),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    // String email = _emailController.text.trim();
    String email = "TalabatExpress@gmail.com";
    String number = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    password = '123456';
    String confirmPassword = _confirmPasswordController.text.trim();
    String referCode = _referCodeController.text.trim();

    String numberWithCountryCode = countryCode + number;
    PhoneValid phoneValid =
        await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }
    // else if (email.isEmpty) {
    //   showCustomSnackBar('enter_email_address'.tr);
    // }
    // else if (!GetUtils.isEmail(email)) {
    //   showCustomSnackBar('enter_a_valid_email_address'.tr);
    // }
    else if (number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }
    // else if (password.isEmpty) {
    //   showCustomSnackBar('enter_password'.tr);
    // }else if (password.length < 6) {
    //   showCustomSnackBar('password_should_be'.tr);
    // }else if (password != confirmPassword) {
    //   showCustomSnackBar('confirm_password_does_not_matched'.tr);
    // }
    else {
      SignUpBody signUpBody = SignUpBody(
        fName: firstName,
        lName: lastName,
        email: email,
        phone: numberWithCountryCode,
        password: password,
        refCode: referCode,
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if (Get.find<SplashController>().configModel!.customerVerification!) {
            List<int> encoded = utf8.encode(password);
            String data = base64Encode(encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode,
                status.message, RouteHelper.signUp, data));
          } else {
            Get.find<LocationController>()
                .navigateToLocationScreen(RouteHelper.signUp);
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
