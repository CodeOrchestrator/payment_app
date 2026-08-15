import 'package:payment/features/home/enums/transaction_type.dart';

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final String? desc;
  final String who;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.who,
    this.desc,
    required this.date,
  });
}
