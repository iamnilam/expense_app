import 'package:bloc/bloc.dart';
import 'package:expense_app/db/app_db.dart';
import 'package:expense_app/models/expense_model.dart';
import 'package:meta/meta.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  AppDataBase db;
  ExpenseBloc({required this.db}) : super(ExpenseInitialState()) {
    on<AddExpenseEvent>((event, emit) async {
      // TODO: implement event handler
      emit(ExpenseLoadingState());
      var check = await db.addExpense(event.newExpense);
      if (check) {
        var mExp = await db.fetchAllExpense();
        emit(ExpenseLoadedState(mData: mExp));
      } else {
        emit(ExpenseErrorState(
            errorMsg: "Expense not show on this model not added"));
      }
    });
    on<FetchAllExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());
      var mExp = await db.fetchAllExpense();
      emit(ExpenseLoadedState(mData: mExp));
    });
  }
}
