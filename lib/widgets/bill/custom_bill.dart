import 'package:flutter/material.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';

/// The Reusable Bill Receipt Card
class BillReceiptCard extends StatelessWidget {
  final String name;
  final String address;
  final String phoneNumber;
  final String code;
  final String fromDate;
  final String toDate;
  final double electricFee;
  final double tax;
  final double total;

  /// Pass your screen's background color here so the cutouts blend in perfectly
  final Color backgroundColor;

  const BillReceiptCard({
    super.key,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.code,
    required this.fromDate,
    required this.toDate,
    required this.electricFee,
    required this.tax,
    required this.total,
    this.backgroundColor = const Color(
      0xFFF3F4F6,
    ), // Default light gray scaffold color
  });

  @override
  Widget build(BuildContext context) {
    const Color labelColor = Color(0xFFA1A1AA); // Light gray for labels
    const Color valueColor = Color(0xFF27272A); // Dark gray for values
    const Color primaryBlue = Color(0xFF3B2C96); // Deep blue for fees
    const Color primaryRed = Color(0xFFF43F5E); // Pinkish red for total

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TOP SECTION
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: AppShadows.card,
          ),
          padding: const EdgeInsets.only(
            top: 32,
            left: 32,
            right: 32,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All the Bills',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF3F3F46),
                ),
              ),
              const SizedBox(height: 32),

              _InfoRow(
                label: 'Name',
                value: name,
                labelColor: labelColor,
                valueColor: valueColor,
              ),
              const SizedBox(height: 24),
              _InfoRow(
                label: 'Address',
                value: address,
                labelColor: labelColor,
                valueColor: valueColor,
              ),
              const SizedBox(height: 24),
              _InfoRow(
                label: 'Phone number',
                value: phoneNumber,
                labelColor: labelColor,
                valueColor: valueColor,
              ),
              const SizedBox(height: 24),
              _InfoRow(
                label: 'Code',
                value: code,
                labelColor: labelColor,
                valueColor: valueColor,
              ),
              const SizedBox(height: 24),
              _InfoRow(
                label: 'From',
                value: fromDate,
                labelColor: labelColor,
                valueColor: valueColor,
              ),
              const SizedBox(height: 24),
              _InfoRow(
                label: 'To',
                value: toDate,
                labelColor: labelColor,
                valueColor: valueColor,
              ),

              const SizedBox(height: 32),

              _InfoRow(
                label: 'Electric fee',
                value: '\$${electricFee.toInt()}',
                labelColor: labelColor,
                valueColor: primaryBlue,
                valueSize: 22,
                labelSize: 22,
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade200, thickness: 1.5, height: 1),
              const SizedBox(height: 16),

              _InfoRow(
                label: 'Tax',
                value: '\$${tax.toInt()}',
                labelColor: labelColor,
                valueColor: primaryBlue,
                valueSize: 22,
                labelSize: 22,
              ),
            ],
          ),
        ),

        // CUTOUT SEPARATOR (Ticket effect)
        Container(
          color: Colors.white,
          child: TicketDivider(cutoutColor: backgroundColor),
        ),

        // BOTTOM SECTION
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(
            top: 16,
            left: 32,
            right: 32,
            bottom: 32,
          ),
          child: _InfoRow(
            label: 'TOTAL',
            value: '\$${total.toInt()}',
            labelColor: labelColor,
            valueColor: primaryRed,
            valueSize: 36,
            labelSize: 20,
            labelWeight: FontWeight.w800,
            valueWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

/// Helper Widget for Key-Value Rows
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final double labelSize;
  final double valueSize;
  final FontWeight labelWeight;
  final FontWeight valueWeight;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    this.labelSize = 18,
    this.valueSize = 18,
    this.labelWeight = FontWeight.w600,
    this.valueWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: labelSize,
            fontWeight: labelWeight,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontSize: valueSize,
              fontWeight: valueWeight,
              height: 1.3, // Improves spacing for multiline text like Address
            ),
          ),
        ),
      ],
    );
  }
}

/// The Custom Ticket Divider with cutouts and dashed line
class TicketDivider extends StatelessWidget {
  final Color cutoutColor;
  final double height;
  final double cutoutRadius;

  const TicketDivider({
    super.key,
    required this.cutoutColor,
    this.height = 24.0,
    this.cutoutRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Cutout
        SizedBox(
          height: height,
          width: cutoutRadius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cutoutColor,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(cutoutRadius),
              ),
            ),
          ),
        ),

        // Dashed Line
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final boxWidth = constraints.constrainWidth();
                const dashWidth = 6.0;
                const dashHeight = 1.5;
                final dashCount = (boxWidth / (2 * dashWidth)).floor();

                return Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dashCount, (_) {
                    return SizedBox(
                      width: dashWidth,
                      height: dashHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),

        // Right Cutout
        SizedBox(
          height: height,
          width: cutoutRadius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cutoutColor,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(cutoutRadius),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
