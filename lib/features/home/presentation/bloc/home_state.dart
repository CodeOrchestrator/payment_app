import 'package:payment/features/home/data/models/transaction_model.dart';
import 'package:payment/features/home/enums/submit_status.dart';
import 'package:payment/features/home/enums/transaction_filter.dart';
import 'package:payment/features/home/enums/transaction_type.dart';

class HomeState {
  final List<TransactionModel> transactions;
  final TransactionFilter filter;
  final SubmitStatus submitStatus;
  final String? errorMessage;

  const HomeState({
    this.transactions = const [],
    this.filter = TransactionFilter.all,
    this.submitStatus = SubmitStatus.empty,
    this.errorMessage,
  });

  double get balance {
    double total = 0;
    for (final transaction in transactions) {
      total += transaction.type == TransactionType.income
          ? transaction.amount
          : -transaction.amount;
    }
    return total;
  }
  

  double get income {
    double income = 0;

    for (final transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        income += transaction.amount;
      }
    }

    return income;
  }

  double get expance {
    double expance = 0;

    for (final transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        expance += transaction.amount;
      }
    }

    return expance;
  }

  List<TransactionModel> get filtered {
    switch (filter) {
      case TransactionFilter.income:
        return transactions
            .where((transaction) => transaction.type == TransactionType.income)
            .toList();
      case TransactionFilter.expense:
        return transactions
            .where((transaction) => transaction.type == TransactionType.expense)
            .toList();
      case TransactionFilter.all:
        return transactions;
    }
  }

  HomeState copyWith({
    List<TransactionModel>? transactions,
    TransactionFilter? filter,
    SubmitStatus? submitStatus,
    String? errorMessage,
  }) {
    return HomeState(
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
