import 'package:payment/features/home/enums/transaction_filter.dart';
import 'package:payment/features/home/enums/transaction_type.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class AddTransaction extends HomeEvent {
  final TransactionType type;
  final double amount;
  final String who;
  final String? desc;

  const AddTransaction({
    required this.type,
    required this.amount,
    required this.who,
    this.desc,
  });
}

class EditTransaction extends HomeEvent {
  final String id;
  final TransactionType type;
  final double amount;
  final String who;
  final String? desc;

  const EditTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.who,
    this.desc,
  });
}

class DeleteTransaction extends HomeEvent{
  final String id;

  const DeleteTransaction({required this.id});
}

class FilterChanged extends HomeEvent {
  final TransactionFilter filter;

  const FilterChanged(this.filter);
}
