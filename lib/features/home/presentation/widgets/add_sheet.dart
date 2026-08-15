import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment/core/formatters/input_formatter.dart';
import 'package:payment/core/tokens/app_colors.dart';
import 'package:payment/features/home/data/models/transaction_model.dart';
import 'package:payment/features/home/enums/submit_status.dart';
import 'package:payment/features/home/enums/transaction_type.dart';
import 'package:payment/features/home/presentation/bloc/home_bloc.dart';
import 'package:payment/features/home/presentation/bloc/home_event.dart';
import 'package:payment/features/home/presentation/bloc/home_state.dart';

class AddSheet extends StatefulWidget {
  final TransactionModel? transaction;

  const AddSheet({super.key, this.transaction});

  @override
  State<AddSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  final _whoController = TextEditingController();

  late TransactionType _type;
  late String id;

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      id = widget.transaction!.id;
    }

    _amountController.text = widget.transaction?.amount.toString() ?? '';

    _whoController.text = widget.transaction?.who ?? '';

    _descController.text = widget.transaction?.desc ?? '';

    _type = widget.transaction?.type ?? TransactionType.income;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    _whoController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.replaceAll(' ', ''));

    if (widget.transaction != null) {
      context.read<HomeBloc>().add(
        EditTransaction(
          id: id,
          type: _type,
          amount: amount,
          who: _whoController.text,
          desc: _descController.text,
        ),
      );
      return;
    }

    context.read<HomeBloc>().add(
      AddTransaction(
        type: _type,
        amount: amount,
        desc: _descController.text.trim(),
        who: _whoController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.submitStatus == SubmitStatus.success) {
          Navigator.of(context).pop(context);
        }

        if (state.submitStatus == SubmitStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Xatolik yuz berdi')),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Yangi operatsiya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      title: 'Kirim',
                      type: TransactionType.income,
                      icon: Icons.arrow_downward,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeButton(
                      title: 'Chiqim',
                      type: TransactionType.expense,
                      icon: Icons.arrow_upward,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [MoneyInputFormatter()],

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Summani kiriting';
                      }

                      final amount = double.tryParse(
                        value.replaceAll(' ', '').replaceAll(',', '.'),
                      );

                      if (amount == null || amount <= 0) {
                        return 'To‘g‘ri summa kiriting';
                      }

                      if (widget.transaction != null) {
                        final editAmount = amount - widget.transaction!.amount;

                        if (_type == TransactionType.expense &&
                            editAmount > state.balance) {
                          return "sizda buncha balans yo'q";
                        }

                        return null;
                      }

                      if (_type == TransactionType.expense &&
                          amount > state.balance) {
                        return 'sizda buncha balans yoq';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Qiymat',
                      prefixIcon: Icon(Icons.payments_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _whoController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return _type == TransactionType.income ? 'kimdan' : "kimga";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintText: _type == TransactionType.income
                      ? 'Kimdan'
                      : 'Kimga',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  hintText: 'Izoh',
                  prefixIcon: Icon(Icons.edit_note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: _save,
                  child: const Text(
                    'Saqlash',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String title,
    required TransactionType type,
    required IconData icon,
  }) {
    final selected = _type == type;
    final color = type == TransactionType.income
        ? AppColors.green
        : AppColors.red;

    return InkWell(
      onTap: () => setState(() => _type = type),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? color : Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? color : AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: selected ? color : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
