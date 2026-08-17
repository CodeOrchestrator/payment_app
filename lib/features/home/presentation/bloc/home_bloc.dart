import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment/features/home/data/models/transaction_model.dart';
import 'package:payment/features/home/enums/submit_status.dart';
import 'package:payment/features/home/enums/transaction_type.dart';
import 'package:payment/features/home/presentation/bloc/home_event.dart';
import 'package:payment/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<AddTransaction>((event, emit) {
      if (event.amount <= 0) {
        emit(
          state.copyWith(
            submitStatus: SubmitStatus.failure,
            errorMessage: "0 dan katta son kiriting",
          ),
        );

        return;
      }

      if (event.type == TransactionType.expense &&
          event.amount > state.balance + 0.01) {
        emit(
          state.copyWith(
            submitStatus: SubmitStatus.failure,
            errorMessage: "sizda buncha balans yo'q",
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          transactions: [
            ...state.transactions,
            TransactionModel(
              id: UniqueKey().toString(),
              type: event.type,
              amount: event.amount,
              who: event.who,
              desc: event.desc,
              date: DateTime.now(),
            ),
          ],
          submitStatus: SubmitStatus.success,
        ),
      );
    });

    on<EditTransaction>((event, emit) {
      final transactions = state.transactions.map((transaction) {
        if (transaction.id == event.id) {
          return TransactionModel(
            id: event.id,
            type: event.type,
            amount: event.amount,
            who: event.who,
            date: DateTime.now(),
            desc: event.desc ?? transaction.desc,
          );
        }
        return transaction;
      }).toList();

      emit(
        state.copyWith(
          transactions: transactions,
          submitStatus: SubmitStatus.success,
        ),
      );
    });

    on<DeleteTransaction>((event, emit) {
      final transactions = state.transactions
          .where((e) => e.id != event.id)
          .toList();
      emit(
        state.copyWith(
          transactions: transactions,
          submitStatus: SubmitStatus.success,
        ),
      );
    });

    on<FilterChanged>((event, emit) {
      emit(
        state.copyWith(filter: event.filter, submitStatus: SubmitStatus.empty),
      );
    });
  }
}
