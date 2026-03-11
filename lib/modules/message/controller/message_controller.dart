import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/modules/message/view/account_security_view.dart';
import 'package:mobile_banking_app/modules/message/view/bank_spp_view.dart';

class MessageController extends GetxController {
  final List<Widget> pages = [const BankSppView(), const AccountSecurityView()];

  final List<Map<String, String>> messages = [
    {
      'title': 'Bank of Cambodia',
      'subtitle': 'Your transaction was successful',
      'time': 'Today',
      'image': 'assets/icons/Group 334.png',
    },
    {
      'title': 'Account Security',
      'subtitle': 'Your password has been changed',
      'time': 'Yesterday',
      'image': 'assets/icons/Group 334-1.png',
    },
    {
      'title': 'Alert',
      'subtitle': 'New login detected on your account',
      'time': '11/12',
      'image': 'assets/icons/Group 334-2.png',
    },
    {
      'title': 'Paypal',
      'subtitle': 'You received a payment of \$50.00',
      'time': '01/11',
      'image': 'assets/icons/Group 334-3.png',
    },
    {
      'title': 'Withdrawal',
      'subtitle': 'Withdrawal of \$100.00 successful',
      'time': '21/10',
      'image': 'assets/icons/Group 334-4.png',
    },
  ].obs;
}
