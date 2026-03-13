import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSimpleDialog extends StatefulWidget {
  const CustomSimpleDialog({super.key});

  @override
  State<CustomSimpleDialog> createState() => _CustomSimpleDialogState();
}

class _CustomSimpleDialogState extends State<CustomSimpleDialog> {
  // List of currencies matching the image
  final List<String> currencies = [
    'VND ( Viet Nam Dong )',
    'HK\$ ( Hong Kong Dollar )',
    'USD ( Dollar )',
    'NT\$ ( Taiwan Dollar )',
    'J\$ ( Jamaika Dollar )',
  ];

  // Default selected currency
  String? selectedCurrency = 'USD ( Dollar )';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 24.0,
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Close Button and Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    'Select the currency',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Currency List
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = currency == selectedCurrency;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedCurrency = currency;
                      });
                      Get.back(result: currency);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 18.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currency,
                            style: TextStyle(
                              fontSize: 16.0,
                              // Using a purple/indigo color for selected state
                              color: isSelected
                                  ? const Color(0xFF3F1DB5)
                                  : Colors.black45,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: Color(0xFF3F1DB5),
                              size: 20.0,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
