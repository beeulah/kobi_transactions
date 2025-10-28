import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../Models/Transaction_model.dart';
// import '../models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel tx;
  final VoidCallback? onTap;

  const TransactionCard({Key? key, required this.tx, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amountText = (tx.amount < 0 ? '-' : '+') +
        (tx.currency.code == 'USD' ? '\$' : tx.currency.code) +
        tx.amount.abs().toStringAsFixed(2);
    // final amountText = (tx.amount < 0 ? '-' : '+') + tx.currency + tx.amount.abs().toStringAsFixed(2);
    final amountStyle = TextStyle(
      color: tx.amount < 0 ? Colors.orange.shade700 : Colors.green.shade700,
      fontWeight: FontWeight.bold,
    );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade100,
                backgroundImage:
                AssetImage('assets/images/netflixIcon.jpg'),
              ),



              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx.merchant, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(tx.formattedDate, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Text(amountText, style: amountStyle),
                  const SizedBox(height: 6),
                  Text(tx.status, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              )
            ],
          ),
        ),
      ),
    )
    // fade-in animation
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.02, end: 0, duration: 400.ms);
  }
}
