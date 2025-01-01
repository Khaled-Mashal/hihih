import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/order_controller.dart';
import 'package:sixam_mart/controller/payment_method_controller.dart';
import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/order_model.dart';
import 'package:sixam_mart/data/model/response/payment_method_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/my_text_field.dart';
import 'package:sixam_mart/view/base/text_field_shadow.dart';
import 'package:sixam_mart/view/screens/checkout/widget/payment_failed_dialog.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel orderModel;
  final bool isCashOnDelivery;
  final String? addFundUrl;
  final String paymentMethod;
  const PaymentScreen(
      {Key? key,
      required this.orderModel,
      required this.isCashOnDelivery,
      this.addFundUrl,
      required this.paymentMethod})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String selectedUrl;
  double value = 0.0;
  PullToRefreshController? pullToRefreshController;
  // MyInAppBrowser browser;
  String accountNumber = '';
  String OTP = '';
  String senderName = '';
  String transNo = '';
  bool isAccountNumberEmpty = false;
  bool isOTPEmpty = false;

  final bool _isLoading = true;
  // late MyInAppBrowser browser;
  double? _maximumCodOrderAmount;
  @override
  void initState() {
    super.initState();
    selectedUrl =
        '${AppConstants.baseUrl}/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';
    _initData();
  }

  void _initData() async {
    await Get.find<PaymentMethodController>().getPaymentMethodList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (() => _exitApp().then((value) => value!)),
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'payment'.tr,
            onBackPressed: () => _exitApp(),
          ),
          body: GetBuilder<PaymentMethodController>(
              builder: (paymentMethodController) {
            return Center(
              heightFactor: 1,
              child: Container(
                width: Dimensions.webMaxWidth,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Stack(
                  children: [
                    paymentMethodController.showPaymentMethodList
                        ? paymentMethodList(paymentMethodController)
                        : const SizedBox(),
                    paymentMethodController.showInfoInputFields
                        ? infoFields(paymentMethodController)
                        : const SizedBox(),
                    paymentMethodController.showOTPField
                        ? OTPField(paymentMethodController)
                        : const SizedBox()
                  ],
                ),
              ),
            );
          }),
        ));
  }

  Future<bool?> _exitApp() async {
    if (Get.find<PaymentMethodController>().showOTPField) {
      setState(() {
        OTP = '';
        isOTPEmpty = false;
      });
      Get.find<PaymentMethodController>().setShowOTPField(false);
      Get.find<PaymentMethodController>().setShowInfoInputFields(true);
      return false;
    } else if (Get.find<PaymentMethodController>().showInfoInputFields) {
      setState(() {
        accountNumber = '';
        senderName = '';
        transNo = '';
        isAccountNumberEmpty = false;
      });
      Get.find<PaymentMethodController>().setShowPaymentMethodList(true);
      Get.find<PaymentMethodController>().setShowInfoInputFields(false);
      return false;
    } else {
      //1001
      // return Get.dialog(PaymentFailedDialog(orderID: widget.orderModel.id.toString()));
      return Get.dialog(PaymentFailedDialog(
          orderID: widget.orderModel.id.toString(),
          orderAmount: widget.orderModel.orderAmount,
          maxCodOrderAmount: _maximumCodOrderAmount,
          orderType: widget.orderModel.orderType,
          isCashOnDelivery: widget.isCashOnDelivery));
    }
  }

  Widget paymentMethodList(PaymentMethodController paymentMethodController) {
    return paymentMethodController.paymentMethodList != null
        ? paymentMethodController.paymentMethodList!.isNotEmpty
            ? Container(
                child: GridView.builder(
                  controller: ScrollController(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.isDesktop(context)
                        ? 3
                        : ResponsiveHelper.isTab(context)
                            ? 2
                            : 1,
                    childAspectRatio: ResponsiveHelper.isDesktop(context)
                        ? (1 / 0.25)
                        : (1 / 0.205),
                    crossAxisSpacing: Dimensions.paddingSizeSmall,
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                  ),
                  itemCount: paymentMethodController.paymentMethodList!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          paymentMethodController
                              .setSelectedPaymentMethodIndex(index);
                          paymentMethodController.setShowInfoInputFields(true);
                          paymentMethodController
                              .setShowPaymentMethodList(false);
                        },
                        child: Container(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: Dimensions.paddingSizeSmall,
                                ),
                                Container(
                                  height: 55,
                                  width: 55,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusExtraLarge),
                                  ),
                                  child: Row(children: [
                                    Container(
                                      height: 55,
                                      width: 55,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2),
                                          shape: BoxShape.circle),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusExtraLarge),
                                        child: CustomImage(
                                          image:
                                              '${AppConstants.BUSINESS_IMAGE_URL}'
                                              '/${paymentMethodController.paymentMethodList![index].logo}',
                                          height: 55,
                                          width: 55,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeDefault),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                      Text(
                                          paymentMethodController
                                              .paymentMethodList![index].name!,
                                          style: robotoMedium),
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeExtraSmall),
                                      // paymentMethodController.paymentMethodList[index].API == 0
                                      //     ? Text(
                                      //         paymentMethodController.paymentMethodList[index].API == 0 ? paymentMethodController.paymentMethodList[index].accountNumber : '',
                                      //         maxLines: 1,
                                      //         overflow: TextOverflow.ellipsis,
                                      //         style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                      //       )
                                      //     : SizedBox(),
                                    ])),
                              ],
                            )));
                  },
                ),
              )
            : Center(child: Text('no_payment_methods_found'.tr))
        : const Center(child: CircularProgressIndicator());
  }

  Widget infoFields(PaymentMethodController paymentMethodController) {
    PaymentMethodModel paymentMethod = paymentMethodController
        .paymentMethodList![paymentMethodController.selectedPaymentMethod];
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  paymentMethodBanner(paymentMethod),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Center(
                      child: Text(
                    paymentMethod.accountMessage!,
                    style: robotoRegular,
                    textAlign: TextAlign.center,
                  )),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isAccountNumberEmpty
                              ? Colors.red
                              : Colors.transparent),
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: TextFieldShadow(
                      child: paymentMethod.getway == 'Hasib'
                          ? const SizedBox()
                          : paymentMethod.getway == 'MobileMoney'
                              ? const SizedBox()
                              : MyTextField(
                                  hintText: paymentMethod.API == 1
                                      ? 'account_number'.tr
                                      : paymentMethod.getway == 'Jawali'
                                          ? 'account_number'.tr
                                          : 'sender_name'.tr,
                                  inputType: paymentMethod.API == 1
                                      ? TextInputType.number
                                      : paymentMethod.getway == 'Jawali'
                                          ? TextInputType.number
                                          : TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                  inputAction: paymentMethod.API == 1
                                      ? TextInputAction.go
                                      : TextInputAction.next,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.toString().isEmpty) {
                                        isAccountNumberEmpty = true;
                                      } else {
                                        isAccountNumberEmpty = false;
                                        if (paymentMethod.API == 1) {
                                          accountNumber = value.toString();
                                        } else {
                                          senderName = value.toString();
                                        }
                                      }
                                    });
                                  },
                                ),
                    ),
                  ),
                  const SizedBox(
                    height: Dimensions.paddingSizeDefault,
                  ),
                  paymentMethod.API == 0
                      ? Column(
                          children: [
                            TextFieldShadow(
                              child: MyTextField(
                                hintText: 'trans_no_if_exists'.tr,
                                inputType: TextInputType.number,
                                capitalization: TextCapitalization.words,
                                inputAction: TextInputAction.go,
                                onChanged: (value) {
                                  setState(() {
                                    transNo = value.toString();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  !paymentMethodController.isLoading
                      ? CustomButton(
                          buttonText: paymentMethod.API == 1
                              ? 'send_confirmation_code'.tr
                              : 'confirm_order'.tr,
                          onPressed: () async {
                            if (paymentMethod.API == 1) {
                              await paymentMethodController
                                  .sendUserAccountNumber(accountNumber,
                                      widget.orderModel.id.toString())
                                  .then((Response response) async {
                                if (response.statusCode == 200) {
                                  if (response.body['errCode'] == '0') {
                                    showCustomSnackBar(
                                        response.body['msg'].toString(),
                                        isError: false);
                                    paymentMethodController
                                        .setShowInfoInputFields(false);
                                    paymentMethodController
                                        .setShowOTPField(true);
                                  } else {
                                    showCustomSnackBar(
                                        response.body['msg'].toString());
                                  }
                                }
                              });
                            } else {
                              await paymentMethodController
                                  .sendUserAccountNumber(
                                      transNo, widget.orderModel.id.toString(),
                                      senderName: senderName)
                                  .then((Response response) async {
                                if (response.statusCode == 200) {
                                  if (response.body['errCode'] == '0') {
                                    paymentMethodController
                                        .setShowInfoInputFields(false);
                                    paymentMethodController
                                        .setShowPaymentMethodList(true);
                                    showCustomSnackBar(
                                        response.body['msg'].toString(),
                                        isError: false);
                                    Get.offAllNamed(
                                        RouteHelper.getInitialRoute());
                                  } else {
                                    showCustomSnackBar(
                                        response.body['msg'].toString());
                                  }
                                }
                              });
                            }
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget OTPField(PaymentMethodController paymentMethodController) {
    PaymentMethodModel paymentMethod = paymentMethodController
        .paymentMethodList![paymentMethodController.selectedPaymentMethod];
    return Column(
      children: [
        paymentMethodBanner(paymentMethod),
        Center(
            child: Text(
          'enter_confirmation_code'.tr,
          style: robotoRegular,
          textAlign: TextAlign.center,
        )),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Container(
          decoration: BoxDecoration(
            border:
                Border.all(color: isOTPEmpty ? Colors.red : Colors.transparent),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: TextFieldShadow(
            child: MyTextField(
              hintText: 'confirmation_code'.tr,
              inputType: TextInputType.number,
              capitalization: TextCapitalization.words,
              onChanged: (value) {
                setState(() {
                  OTP = value.toString();
                });
              },
            ),
          ),
        ),
        const SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        !paymentMethodController.isLoading
            ? CustomButton(
                buttonText: 'verify'.tr,
                onPressed: () async {
                  await paymentMethodController
                      .sendUserOTP(OTP, widget.orderModel.id.toString())
                      .then((Response response) async {
                    if (response.statusCode == 200) {
                      if (response.body['errCode'] == '0') {
                        paymentMethodController.setShowInfoInputFields(false);
                        paymentMethodController.setShowPaymentMethodList(true);
                        paymentMethodController.setShowOTPField(false);
                        showCustomSnackBar(response.body['msg'].toString(),
                            isError: false);
                        Get.offAllNamed(RouteHelper.getInitialRoute());
                      } else {
                        showCustomSnackBar(response.body['msg'].toString());
                      }
                    } else {
                      ApiChecker.checkApi(response);
                    }
                  });
                },
              )
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget paymentMethodBanner(PaymentMethodModel paymentMethod) {
    return Column(
      children: [
        const SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(children: [
            Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CustomImage(
                  image: '${AppConstants.BUSINESS_IMAGE_URL}'
                      '/${paymentMethod.logo}',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Center(child: Text(paymentMethod.name!, style: robotoBlack)),
      ],
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  final String orderID;
  final String? orderType;
  final double? orderAmount;
  final double? maxCodOrderAmount;
  final bool isCashOnDelivery;
  final String? addFundUrl;
  MyInAppBrowser(
      {required this.orderID,
      required this.orderType,
      required this.orderAmount,
      required this.maxCodOrderAmount,
      required this.isCashOnDelivery,
      this.addFundUrl,
      int? windowId,
      UnmodifiableListView<UserScript>? initialUserScripts})
      : super(windowId: windowId, initialUserScripts: initialUserScripts);

  final bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    // _redirect(url.toString());
    Get.find<OrderController>().paymentRedirect(
        url: url.toString(),
        canRedirect: _canRedirect,
        onClose: () => close(),
        addFundUrl: addFundUrl,
        orderID: orderID);
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    Get.find<OrderController>().paymentRedirect(
        url: url.toString(),
        canRedirect: _canRedirect,
        onClose: () => close(),
        addFundUrl: addFundUrl,
        orderID: orderID);
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    // if(_canRedirect) {
    //   Get.dialog(PaymentFailedDialog(orderID: orderID, orderAmount: orderAmount, maxCodOrderAmount: maxCodOrderAmount, orderType: orderType, isCashOnDelivery: isCashOnDelivery));
    // }
    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
    if (kDebugMode) {
      print(
          "Started at: ${resource.startTime}ms ---> duration: ${resource.duration}ms ${resource.url ?? ''}");
    }
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }
}
// class MyInAppBrowser extends InAppBrowser {
//   final String orderID;
//   final String orderType;
//   MyInAppBrowser({@required this.orderID, @required this.orderType, int windowId, UnmodifiableListView<UserScript> initialUserScripts})
//       : super(windowId: windowId, initialUserScripts: initialUserScripts);

//   bool _canRedirect = true;

//   @override
//   Future onBrowserCreated() async {
//     print("\n\nBrowser Created!\n\n");
//   }

//   @override
//   Future onLoadStart(url) async {
//     print("\n\nStarted: $url\n\n");
//     _redirect(url.toString());
//   }

//   @override
//   Future onLoadStop(url) async {
//     pullToRefreshController?.endRefreshing();
//     print("\n\nStopped: $url\n\n");
//     _redirect(url.toString());
//   }

//   @override
//   void onLoadError(url, code, message) {
//     pullToRefreshController?.endRefreshing();
//     print("Can't load [$url] Error: $message");
//   }

//   @override
//   void onProgressChanged(progress) {
//     if (progress == 100) {
//       pullToRefreshController?.endRefreshing();
//     }
//     print("Progress: $progress");
//   }

//   @override
//   void onExit() {
//     if (_canRedirect) {
//       Get.dialog(PaymentFailedDialog(orderID: orderID));
//     }
//     print("\n\nBrowser closed!\n\n");
//   }

//   @override
//   Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
//     print("\n\nOverride ${navigationAction.request.url}\n\n");
//     return NavigationActionPolicy.ALLOW;
//   }

//   @override
//   void onLoadResource(response) {
//     print("Started at: " + response.startTime.toString() + "ms ---> duration: " + response.duration.toString() + "ms " + (response.url ?? '').toString());
//   }

//   @override
//   void onConsoleMessage(consoleMessage) {
//     print("""
//     console output:
//       message: ${consoleMessage.message}
//       messageLevel: ${consoleMessage.messageLevel.toValue()}
//    """);
//   }

//   void _redirect(String url) {
//     if (_canRedirect) {
//       bool _isSuccess = url.contains('success') && url.contains(AppConstants.BASE_URL);
//       bool _isFailed = url.contains('fail') && url.contains(AppConstants.BASE_URL);
//       bool _isCancel = url.contains('cancel') && url.contains(AppConstants.BASE_URL);
//       if (_isSuccess || _isFailed || _isCancel) {
//         _canRedirect = false;
//         close();
//       }
//       if (_isSuccess) {
//         Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID));
//       } else if (_isFailed || _isCancel) {
//         Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID));
//       }
//     }
//   }
// }
