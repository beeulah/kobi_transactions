import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/transaction_model.dart';
import '../Models/Transaction_model.dart';
import '../providers/transaction_provider.dart';

class TransactionDetailScreen extends ConsumerStatefulWidget {
  final TransactionModel transaction;
  const TransactionDetailScreen({Key? key, required this.transaction}) : super(key: key);

  @override
  ConsumerState<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends ConsumerState<TransactionDetailScreen> {
  bool isProcessing = false;


  Color ultraLightRed = const Color(0xFFFFF8F9);

  @override
  Widget build(BuildContext context) {
    final tx = widget.transaction;
    final notifier = ref.read(transactionNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: ultraLightRed,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Transaction Detail'),
        leading:


        BackButton(onPressed: () => Navigator.of(context).pop(false)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade100,
                backgroundImage:
                AssetImage('assets/images/netflixIcon.jpg'),
              ),
              const SizedBox(height: 12),
              Text(tx.merchant, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(tx.category, style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 18),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('Amount'),
                        Text('${tx.currency.code}${tx.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('Payment Method'),
                        Text(tx.method),
                      ]),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('Status'),
                        Text(tx.status),
                      ]),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('Date'),
                        Text(tx.formattedDate),
                      ]),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: Navigator.of(context).canPop() ? () => Navigator.of(context).pop(false) : null,
                      child: const Text('Back'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, foregroundColor: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (tx.status == 'Refunded' || isProcessing)
                          ? null
                          : () async {
                        setState(() => isProcessing = true);
                        final success = await notifier.refund(tx.id);
                        setState(() => isProcessing = false);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Refund successful')));
                          Navigator.of(context).pop(true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Refund failed')));
                        }
                      },
                      child: isProcessing ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Refund'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
