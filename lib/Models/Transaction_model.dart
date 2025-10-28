import 'package:intl/intl.dart';




/// Represents the currency of an amount
class Currency {
  final String code; // e.g., "USD"

  Currency({required this.code});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(code: json['code'] ?? 'USD');
  }

  Map<String, dynamic> toJson() {
    return {'code': code};
  }
}

/// Represents a single transaction
class TransactionModel {
  final int id;
  final String merchant;
  final String category;
  final String logo;
  final Currency currency; // <-- add this
  double amount;
  DateTime date;
  final String method;
  String status;

  TransactionModel({
    required this.id,
    required this.merchant,
    required this.category,
    required this.logo,
    required this.currency, // <-- initialize
    required this.amount,
    required this.date,
    required this.method,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      merchant: json['merchant'] ?? '',
      category: json['category'] ?? '',
      logo: json['logo'] ?? '',
      currency: Currency.fromJson({'code': json['currency'] ?? 'USD'}), // parse currency
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      method: json['method'] ?? '',
      status: json['status'] ?? 'Completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchant': merchant,
      'category': category,
      'logo': logo,
      'currency': currency.toJson(),
      'amount': amount,
      'date': date.toIso8601String(),
      'method': method,
      'status': status,
    };
  }

  String get formattedDate {
    return DateFormat.yMMMd().add_jm().format(date);
  }
}



// class TransactionModel {
//   final int id;
//   final String merchant;
//   final String category;
//   final String logo;
//   double amount;
//   DateTime date;
//   final String method;
//   String status;
//
//   TransactionModel({
//     required this.id,
//     required this.merchant,
//     required this.category,
//     required this.logo,
//     required this.amount,
//     required this.date,
//     required this.method,
//     required this.status,
//   });
//
//   factory TransactionModel.fromJson(Map<String, dynamic> json) {
//     return TransactionModel(
//       id: json['id'],
//       merchant: json['merchant'] ?? '',
//       category: json['category'] ?? '',
//       logo: json['logo'] ?? '',
//       amount: (json['amount'] as num).toDouble(),
//       date: DateTime.parse(json['date']),
//       method: json['method'] ?? '',
//       status: json['status'] ?? 'Completed',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'merchant': merchant,
//       'category': category,
//       'logo': logo,
//       'amount': amount,
//       'date': date.toIso8601String(),
//       'method': method,
//       'status': status,
//     };
//   }
//
//   String get formattedDate {
//     return DateFormat.yMMMd().add_jm().format(date);
//   }
// }



