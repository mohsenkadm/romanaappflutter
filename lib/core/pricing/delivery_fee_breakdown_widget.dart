import 'package:flutter/material.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/core/pricing/pricing_service.dart';

/// Report0002: show delivery total only — hide ECA/LZA/zone breakdown.
class DeliveryFeeBreakdownWidget extends StatelessWidget {
  final QuoteResult quote;

  const DeliveryFeeBreakdownWidget({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).secondaryHeaderColor,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            OrderStatusHelper.formatIqd(quote.total),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            'رسوم التوصيل',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Report0002: order details — delivery total only.
class OrderPricingBreakdownWidget extends StatelessWidget {
  final String? fromZone;
  final String? toZone;
  final num? zoneFee;
  final num? ecaFee;
  final num? routeDistanceKm;
  final num totalDelivery;
  final String? pricingSource;

  const OrderPricingBreakdownWidget({
    super.key,
    this.fromZone,
    this.toZone,
    this.zoneFee,
    this.ecaFee,
    this.routeDistanceKm,
    required this.totalDelivery,
    this.pricingSource,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).secondaryHeaderColor,
      ),
      child: Text(
        'رسوم التوصيل: ${OrderStatusHelper.formatIqd(totalDelivery)}',
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
