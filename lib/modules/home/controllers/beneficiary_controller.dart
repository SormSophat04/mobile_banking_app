import 'package:get/get.dart';

class BeneficiaryController extends GetxController {
  final RxList<Map<String, String>> beneficiaries = <Map<String, String>>[
    {'name': 'John Doe', 'accountNumber': '056475234'},
    {'name': 'Jane Smith', 'accountNumber': '098765432'},
  ].obs;

  final List<Map<String, String>> beneficiaryTypes = [
    {'title': 'Transfer via card number', 'icon': 'assets/icons/34.png'},
    {'title': 'Transfer to the same bank', 'icon': 'assets/icons/09.png'},
    {'title': 'Transfer to another bank', 'icon': 'assets/icons/33.png'},
  ].obs;

  void addBeneficiary(String name, String accountNumber) {
    beneficiaries.add({'name': name, 'accountNumber': accountNumber});
  }

  void removeBeneficiary(int index) {
    beneficiaries.removeAt(index);
  }
}
