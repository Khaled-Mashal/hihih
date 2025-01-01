import 'package:get/get.dart';
import 'package:sixam_mart/data/api/api_checker.dart';
// import 'package:saffari_customer_app/data/api/api_checker.dart';
// import 'package:saffari_customer_app/data/model/response/payment_method_model.dart';
// import 'package:saffari_customer_app/data/repository/payment_method_repo.dart';
import 'package:sixam_mart/data/model/response/payment_method_model.dart';
import 'package:sixam_mart/data/repository/payment_method_repo.dart';

class PaymentMethodController extends GetxController implements GetxService {
  late PaymentMethodRepo paymentMethodRepo;
  PaymentMethodController({required this.paymentMethodRepo});

  List<PaymentMethodModel>? _paymentMethodList;
  int _selectedPaymentMethod = -1;
  bool _showPaymentMethodList = true;
  bool _showInfoInputFields = false;
  bool _showOTPField = false;
  bool _isLoading = false;

  List<PaymentMethodModel>? get paymentMethodList => _paymentMethodList;
  int get selectedPaymentMethod => _selectedPaymentMethod;
  bool get showPaymentMethodList => _showPaymentMethodList;
  bool get showInfoInputFields => _showInfoInputFields;
  bool get showOTPField => _showOTPField;
  bool get isLoading => _isLoading;

  Future<void> getPaymentMethodList({bool selfReload = false}) async {
    selfReload ? _isLoading = false : true;
    update();
    Response response = await paymentMethodRepo.getPaymentMethodList();
    if (response.statusCode == 200) {
      _paymentMethodList = [];
      response.body.forEach((method) => _paymentMethodList!.add(PaymentMethodModel.fromJson(method)));
          // print("paymmmmm2: ${_paymentMethodList!.length}");
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  
    if (!selfReload) {
      await paymentMethodRepo.updatePaymentMethodList();
      await getPaymentMethodList(selfReload: true);
    }
  }

  Future<Response> sendUserAccountNumber(String accountNumber, String orderID, {String ?senderName }) async {
    _isLoading = true;
    update();
    final Map<String, dynamic> data = new Map<String, dynamic>();
    PaymentMethodModel paymentMethod = _paymentMethodList![_selectedPaymentMethod];
    if (paymentMethod.API == 1) {
      data['num_acount'] = accountNumber;
      data['order_id'] = orderID;
    }

    else {
      data['trans_no'] = accountNumber;
      data['sender_name'] = senderName;
      data['order_id'] = orderID;
    }
    Response response = await paymentMethodRepo.sendUserAccountNumber(paymentMethod.API_URL!, data);
    _isLoading = false;
    update();
    return response;
  }

  Future<Response> sendUserOTP(String otp, String orderID) async {
    _isLoading = true;
    update();
    final Map<String, dynamic> data = new Map<String, dynamic>();
    PaymentMethodModel paymentMethod = _paymentMethodList![_selectedPaymentMethod];
    data['otp'] = otp;
    data['order_id'] = orderID;
    Response response = await paymentMethodRepo.sendUserOTP(paymentMethod.VERIFY_CODE_URL!, data);
    _isLoading = false;
    update();
    return response;
  }

  void setSelectedPaymentMethodIndex(int index) {
    _selectedPaymentMethod = index;
    update();
  }

  void setShowPaymentMethodList(bool value) {
    _showPaymentMethodList = value;
    update();
  }

  void setShowInfoInputFields(bool value) {
    _showInfoInputFields = value;
    update();
  }

  void setShowOTPField(bool value) {
    _showOTPField = value;
    update();
  }
}
