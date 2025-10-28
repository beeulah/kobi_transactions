import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../AppConfig/app_config.dart';



class TransactionService {
  final bool useLocalFallback;

  TransactionService({this.useLocalFallback = true});

  Future<Map<String, dynamic>> fetchTransactions() async {
    // Try API first
    try {
      final resp = await http.get(Uri.parse(AppConfig.transactionsUrl)).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(resp.body);
        return data;
      } else {
        if (useLocalFallback) {
          return _loadFromAsset();
        }
        throw Exception('Failed to load: ${resp.statusCode}');
      }
    } catch (e) {
      // If error and fallback allowed, load local asset
      if (useLocalFallback) {
        return _loadFromAsset();
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _loadFromAsset() async {
    final jsonStr = await rootBundle.loadString(AppConfig.localTransactionsAsset);
    final Map<String, dynamic> data = json.decode(jsonStr);
    return data;
  }

  // Optionally send a patch/post to server - here we simulate success
  Future<bool> refundTransaction(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
