import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:payment/core/formatters/formatter.dart';
import 'package:payment/core/tokens/app_colors.dart';
import 'package:payment/features/home/data/models/transaction_model.dart';
import 'package:payment/features/home/enums/transaction_filter.dart';
import 'package:payment/features/home/enums/transaction_type.dart';
import 'package:payment/features/home/presentation/bloc/home_bloc.dart';
import 'package:payment/features/home/presentation/bloc/home_event.dart';
import 'package:payment/features/home/presentation/bloc/home_state.dart';
import 'package:payment/features/home/presentation/widgets/add_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void openAddSheet(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      builder: (_) => BlocProvider.value(value: bloc, child: const AddSheet()),
    );
  }

  void openEditSheet(BuildContext context, TransactionModel transaction) {
    final bloc = context.read<HomeBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      builder: (_) => BlocProvider.value(
        value: bloc,
        child: AddSheet(transaction: transaction),
      ),
    );
  }

  void deleteDialog(BuildContext context, String id) {
    final bloc = context.read<HomeBloc>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: AlertDialog(
          title: Text("tranzaktsyani o'chirish"),
          content: Text("rostdan ham tranzaktsyani o'chirmoqchimisz?"),
          actions: [
            TextButton(onPressed: () => context.pop(), child: Text("cancel")),
            TextButton(
              onPressed: () {
                bloc.add(DeleteTransaction(id: id));
                context.pop();
              },
              child: Text("o'chirish", style: TextStyle(color: AppColors.red)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mening Hisobim",
          style: TextStyle(fontWeight: FontWeight(700)),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final list = state.filtered;
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.textPrimary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(03),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'balans',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${formatMoney(state.balance)} so'm",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft.withAlpha(60),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "+${formatMoney(state.balance)} so'm bu oy",
                            style: TextStyle(color: AppColors.primarySoft),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight(700),
                                  ),
                                  children: [
                                    TextSpan(text: "KIRIM\n"),
                                    TextSpan(
                                      text:
                                          " +${formatMoney(state.income)} so'm",
                                      style: TextStyle(
                                        fontSize: 18,
                                        height: 1.4,
                                        color: AppColors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight(700),
                                  ),
                                  children: [
                                    TextSpan(text: "CHIQIM\n"),
                                    TextSpan(
                                      text:
                                          " -${formatMoney(state.expance)} so'm",
                                      style: TextStyle(
                                        fontSize: 18,
                                        height: 1.4,
                                        color: AppColors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (state.transactions.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildFilterToggle(context, state.filter),
                  ],

                  const SizedBox(height: 16),
                  Expanded(
                    child: list.isNotEmpty
                        ? ListView.builder(
                            itemCount: list.length,

                            itemBuilder: (context, index) {
                              final item = list[index];
                              final isIncome =
                                  item.type == TransactionType.income;
                              final color = isIncome
                                  ? AppColors.green
                                  : AppColors.red;
                              return Padding(
                                padding: EdgeInsetsGeometry.only(bottom: 14),
                                child: Slidable(
                                  endActionPane: ActionPane(
                                    extentRatio: 0.3,
                                    motion: const DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) =>
                                            openEditSheet(context, item),
                                        icon: Icons.edit,
                                      ),
                                      SlidableAction(
                                        onPressed: (context) =>
                                            deleteDialog(context, item.id),
                                        icon: Icons.delete,
                                        foregroundColor: AppColors.red,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(60),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: color.withAlpha(60),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            isIncome
                                                ? Icons.arrow_downward
                                                : Icons.arrow_upward,
                                            color: color,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                isIncome
                                                    ? "${item.who} dan"
                                                    : "${item.who} ga",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),

                                              if (item.desc != null &&
                                                  item.desc!
                                                      .trim()
                                                      .isNotEmpty) ...[
                                                const SizedBox(height: 2),
                                                Text(
                                                  item.desc!,
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],

                                              const SizedBox(height: 2),
                                              Text(
                                                '${item.date.day.toString().padLeft(2, '0')}.${item.date.month.toString().padLeft(2, '0')}.${item.date.year} ${item.date.hour.toString().padLeft(2, '0')}:${item.date.minute.toString().padLeft(2, '0')}',
                                                style: const TextStyle(
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${isIncome ? '+' : '-'}${formatMoney(item.amount)} so\'m',

                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(child: Text("hozircha kirim chiqim yo'q")),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => openAddSheet(context),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

Widget _buildFilterToggle(BuildContext context, TransactionFilter current) {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.primarySoft.withAlpha(60), // umumiy background
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        _filterButton(context, "Barchasi", TransactionFilter.all, current),
        _filterButton(context, "Kirim", TransactionFilter.income, current),
        _filterButton(context, "Chiqim", TransactionFilter.expense, current),
      ],
    ),
  );
}

Widget _filterButton(
  BuildContext context,
  String label,
  TransactionFilter value,
  TransactionFilter current,
) {
  final bool isSelected = value == current;

  return Expanded(
    child: GestureDetector(
      onTap: () {
        // eventingiz nomiga qarab shu yerni to'g'irlang
        context.read<HomeBloc>().add(FilterChanged(value));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    ),
  );
}
