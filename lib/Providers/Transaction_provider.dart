import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
// import '../models/transaction_model.dart';
import '../Models/Transaction_model.dart';
import '../services/transaction_service.dart';
import 'dart:math';

final transactionServiceProvider = Provider<TransactionService>((ref) {
  return TransactionService(useLocalFallback: true);
});

// Filter enum for tab
enum TransactionFilter { all, thisMonth, lastMonth }

class TransactionState {
  final bool loading;
  final String? error;
  final double totalPayment;
  final List<TransactionModel> transactions;
  final TransactionFilter filter;

  TransactionState({
    required this.loading,
    this.error,
    required this.totalPayment,
    required this.transactions,
    required this.filter,
  });

  TransactionState copyWith({
    bool? loading,
    String? error,
    double? totalPayment,
    List<TransactionModel>? transactions,
    TransactionFilter? filter,
  }) {
    return TransactionState(
      loading: loading ?? this.loading,
      error: error,
      totalPayment: totalPayment ?? this.totalPayment,
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
    );
  }
}

final transactionNotifierProvider = StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  final service = ref.watch(transactionServiceProvider);
  return TransactionNotifier(service);
});

class TransactionNotifier extends StateNotifier<TransactionState> {
  final TransactionService service;

  TransactionNotifier(this.service)
      : super(TransactionState(loading: false, totalPayment: 0.0, transactions: [], filter: TransactionFilter.all));

  Future<void> loadTransactions() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final data = await service.fetchTransactions();
      final total = (data['totalPayment'] as num?)?.toDouble() ?? 0.0;
      final list = (data['transactions'] as List<dynamic>?)
          ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [];
      // sort by date desc
      list.sort((a, b) => b.date.compareTo(a.date));
      state = state.copyWith(loading: false, totalPayment: total, transactions: list, error: null);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void setFilter(TransactionFilter f) {
    state = state.copyWith(filter: f);
  }

  // Filtering logic exposed to UI
  List<TransactionModel> filteredTransactions() {
    final now = DateTime.now();
    if (state.filter == TransactionFilter.all) return state.transactions;
    return state.transactions.where((t) {
      if (state.filter == TransactionFilter.thisMonth) {
        return t.date.year == now.year && t.date.month == now.month;
      } else {
        final lastMonth = DateTime(now.year, now.month - 1);
        return t.date.year == lastMonth.year && t.date.month == lastMonth.month;
      }
    }).toList();
  }

  // simple filter by min/max amount and/or date range
  List<TransactionModel> applyFilter({double? minAmount, double? maxAmount, DateTime? start, DateTime? end}) {
    final list = filteredTransactions();
    return list.where((t) {
      final amt = t.amount;
      if (minAmount != null && amt < minAmount) return false;
      if (maxAmount != null && amt > maxAmount) return false;
      if (start != null && t.date.isBefore(start)) return false;
      if (end != null && t.date.isAfter(end)) return false;
      return true;
    }).toList();
  }

  // Refund action (local state change)
  Future<bool> refund(int id) async {
    final succeeded = await service.refundTransaction(id);
    if (succeeded) {
      final updated = state.transactions.map((t) {
        if (t.id == id) {
          t.status = 'Refunded';
        }
        return t;
      }).toList();
      state = state.copyWith(transactions: updated);
      return true;
    }
    return false;
  }
}
