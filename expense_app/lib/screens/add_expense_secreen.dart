import 'package:expense_app/app_constants/content_constants.dart';
import 'package:expense_app/expense_bloc/expense_bloc.dart';
import 'package:expense_app/screens/home_screen.dart';
import 'package:expense_app/widgets/customButton.dart';
import 'package:expense_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../models/expense_model.dart';

class AddExpenseScreen extends StatefulWidget {
  num balance;
   AddExpenseScreen({super.key, required this.balance});


  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  var titleController = TextEditingController();

  var desController = TextEditingController();

  var amtController = TextEditingController();

  var transactionType = ["Debit", "Creadit"];

  var selectedTransactionType = "Debit";

  var selectedCatIndex = -1;

  DateTime expenseDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021, 1, 25),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      setState(() {
        expenseDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(

        leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Icon(Icons.arrow_left)),
        backgroundColor: isDark ? Colors.black : Colors.blueGrey,
        title: Text("Add Expense",style: TextStyle(color: isDark ? Colors.white : Colors.white),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 21,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CstmTextField(
                      label: "Expense",
                      controller: titleController,
                      iconData: Icons.abc),
                  CstmTextField(
                      controller: desController,
                      label: "Description",
                      iconData: Icons.abc),
                  CstmTextField(
                      controller: amtController,
                      label: "Amount",
                      iconData: Icons.abc),
                  Container(
                    height: 35,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButton(
                        dropdownColor: Colors.black,
                        icon: Icon(
                          Icons.arrow_drop_down_circle,
                          color: Colors.white,
                        ),
                        value: selectedTransactionType,
                        items: transactionType
                            .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type,
                                  style: TextStyle(color: Colors.white),
                                )))
                            .toList(),
                        onChanged: (value) {
                          selectedTransactionType = value!;
                          setState(() {});
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CstmButton(
                      name: "Choose Expense",
                      mWidget: selectedCatIndex != -1
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppConstants.mCategories![selectedCatIndex]
                                      .catImgPath,
                                  height: 25,
                                  width: 25,
                                ),
                                Text(
                                  " - ${AppConstants.mCategories[selectedCatIndex].catTitle.toString()}",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )
                          : null,
                      textColor:  isDark ? Colors.white : Colors.white,
                      btnColor: isDark ? Colors.blueGrey : Colors.blueGrey ,
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12))),
                            builder: (context) {
                              return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4),
                                  itemCount: AppConstants.mCategories.length,
                                  itemBuilder: (context, index) {
                                    var eachcat =
                                        AppConstants.mCategories[index];
                                    return InkWell(
                                      onTap: () {
                                        selectedCatIndex = index;
                                       // eachcat.catId;
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            color: Colors
                                                .deepPurpleAccent.shade100,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Image.asset(
                                            eachcat.catImgPath,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            });
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  CstmButton(
                      name: DateFormat.yMMMMd().format(expenseDate),
                      textColor:  isDark ? Colors.white : Colors.white,
                      btnColor: isDark ? Colors.blueGrey : Colors.blueGrey ,
                      onTap: () {
                        _selectDate(context);
                        setState(() {});
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  CstmButton(
                    name: "Add Expense",
                    textColor:  isDark ? Colors.white : Colors.white,
                    btnColor: isDark ? Colors.blueGrey : Colors.blueGrey ,
                    onTap: () {
                      print(amtController.text.toString());
                      var mBalance = widget.balance;
                      if(selectedTransactionType=="Debit"){
                        mBalance -= int.parse(amtController.text.toString());
                      }else{
                        mBalance += int.parse(amtController.text.toString());
                      }
                      var newExpense = ExpenseModel(
                          expId: 0,
                          uId: 0,
                          expTitle: titleController.text.toString(),
                          expDesc: desController.text.toString(),
                          expTimeStamp:
                              expenseDate.millisecondsSinceEpoch.toString(),
                          expAmt: int.parse(amtController.text.toString()),
                          expBal: mBalance,
                          expType: selectedTransactionType == "Debit" ? 0 : 1,
                          expCatType: selectedCatIndex);
                      BlocProvider.of<ExpenseBloc>(context)
                          .add(AddExpenseEvent(newExpense: newExpense));
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
