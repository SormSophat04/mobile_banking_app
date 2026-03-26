import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/network/models/bill_model.dart';
import 'package:mobile_banking_app/core/network/models/bill_payment_response_model.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class PayBillController extends GetxController {
  final ApiClient _api = Get.put(ApiClient());
  
  final selectedBill = Rxn<BillModel>();
  final billPaymentResponse = Rxn<BillPaymentResponseModel>();
  bool isLoading = false;

  final List<Map<String, dynamic>> bills = [
    {
      'title': 'Electric Bill',
      'subtitle': 'Pay electric bill this month',
      'icon': AppAssets.electricBill,
      'route': AppRoutes.PAY_SEARCH_CODE,
      'status': 'ELECTRIC',
    },
    {
      'title': 'Water Bill',
      'subtitle': 'Pay water bill this month',
      'icon': AppAssets.watherBill,
      'route': AppRoutes.PAY_SEARCH_CODE,
      'status': 'WATER',
    },
    {
      'title': 'Mobile Bill',
      'subtitle': 'Pay mobile bill this month',
      'icon': AppAssets.mobileBill,
      'route': AppRoutes.PAY_SEARCH_CODE,
      'status': 'MOBILE',
    },
    {
      'title': 'Internet Bill',
      'subtitle': 'Pay internet bill this month',
      'icon': AppAssets.internetBill,
      'route': AppRoutes.PAY_SEARCH_CODE,
      'status': 'INTERNET',
    },
  ];

  Future<void> fetchBillDetails(String type, String code) async {
    isLoading = true;
    update();
    try {
      final res = await _api.get('bills', query: {'billType': type, 'billCode': code});
      if (res.isOk) {
        selectedBill.value = BillModel.fromJson(res.body);
        Get.toNamed(AppRoutes.PAY_RECIEPT);
      } else {
        Get.snackbar('Error', 'Bill not found or error occurred');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> payBill(String fromAccountNumber) async {
    if (selectedBill.value == null) return;
    
    isLoading = true;
    update();
    
    try {
      final body = {
        "billId": selectedBill.value!.billId,
        "fromAccountNumber": fromAccountNumber,
        "amount": selectedBill.value!.totalAmount,
        "idempotencyKey": DateTime.now().microsecondsSinceEpoch.toString(),
      };
      
      final res = await _api.post('bill-payments', body);
      if (res.isOk) {
        billPaymentResponse.value = BillPaymentResponseModel.fromJson(res.body);
        Get.offNamed(AppRoutes.PAY_SUCCESS);
      } else {
        Get.snackbar('Error', 'Payment failed: ${res.bodyString}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong during payment');
    } finally {
      isLoading = false;
      update();
    }
  }
}
