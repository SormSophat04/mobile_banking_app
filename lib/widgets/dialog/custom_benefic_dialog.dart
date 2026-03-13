import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBeneficDialog extends StatefulWidget {
  const CustomBeneficDialog({super.key});

  @override
  State<CustomBeneficDialog> createState() => _CustomBeneficDialogState();
}

class _CustomBeneficDialogState extends State<CustomBeneficDialog> {
  // List of banks matching the image
  final List<String> banks = [
    'Fifth Third',
    'Bank of the West',
    'Wells Fago',
    'JP Morgan Chae',
    'US bank',
    'HSBS bank',
    'Citybank',
    'Ame Express',
  ];

  // Default selected bank
  String? selectedBank = 'US bank';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 24.0,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 16.0),
        constraints: const BoxConstraints(
          maxHeight: 600,
        ), // Prevents overflow on small screens
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Choose beneficiary bank',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24.0),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 16),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Bank List
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: banks.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                itemBuilder: (context, index) {
                  final bank = banks[index];
                  final isSelected = bank == selectedBank;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedBank = bank;
                      });
                      Get.back(result: bank);
                      // Optional: Close dialog and return selected bank
                      // Navigator.pop(context, bank);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            bank,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: isSelected
                                  ? Colors.black87
                                  : Colors.black45,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: Color(0xFF1A237E), // Dark blue checkmark
                              size: 22.0,
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
