part of 'expense_bloc.dart';

@immutable
sealed class ExpenseState {}

final class ExpenseInitialState extends ExpenseState {}

class ExpenseLoadingState extends ExpenseState {}

class ExpenseLoadedState extends ExpenseState {
  List<ExpenseModel> mData;
  ExpenseLoadedState({required this.mData});
}

class ExpenseErrorState extends ExpenseState {
  String errorMsg;
  ExpenseErrorState({required this.errorMsg});
}
