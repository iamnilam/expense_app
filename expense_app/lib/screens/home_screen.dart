import 'dart:math';

import 'package:expense_app/app_constants/content_constants.dart';
import 'package:expense_app/expense_bloc/expense_bloc.dart';
import 'package:expense_app/models/expense_model.dart';
import 'package:expense_app/provider/theme_proiver.dart';
import 'package:expense_app/screens/add_expense_secreen.dart';
import 'package:expense_app/screens/start_apge.dart';
import 'package:expense_app/widgets/date_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double mWidth = 0.0;
  double mHeight = 0.0;
  MediaQueryData? mq;
  num lastBalance = 0.0;
  final List<Color> colorRandom = [
    // Colors.lightBlue.shade100,
    Colors.red.shade100,

    Colors.orangeAccent.shade100,
    // Colors.yellow.shade100
  ];

  List<ExpenseModel> allExpenses = [];

  final List<Color> colorForCard = [
    Colors.yellow.shade100,
    Colors.lightGreen.shade100,
  ];
  void updateBalance(List<ExpenseModel> mData) {
    var lastTransactionId = -1;
    for (ExpenseModel exp in mData) {
      if (exp.expId > lastTransactionId) {
        lastTransactionId = exp.expId;
      }
    }
    print(lastTransactionId);
    var lastExpenseBal = mData
        .firstWhere((element) => element.expId == lastTransactionId)
        .expBal;
    lastBalance = lastExpenseBal;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ExpenseBloc>(context).add(FetchAllExpenseEvent());
  }

  @override
  Widget build(BuildContext context) {
    // var mq = MediaQuery.of(context);
    // var mWidth = mq.size.width;
    // var mHeight = mq.size.height;
    getWidthHeight();
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.blueGrey,
        title: const Text(
          "Expense Home Page",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: isDark ? Colors.black : Colors.white,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  //color: Colors.blue,
                  ),
              child: Text('Expense Menu'),
            ),
            SwitchListTile(
                title: Text("Theme Colors Changers"),
                value: context.watch<ThemeProvider>().themeValue,
                onChanged: (value) {
                  context.read<ThemeProvider>().themeValue = value;
                  Navigator.pop(context);
                }),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: const Text('Choose Theme Colors'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.graphic_eq),
              title: const Text('Expense Total Amount'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (_, state) {
          if (state is ExpenseLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ExpenseErrorState) {
            return const Center(
              child: Text("Data Not Found"),
            );
          }

          if (state is ExpenseLoadedState) {
            allExpenses = state.mData;
            if (state.mData.isNotEmpty) {
              updateBalance(state.mData);
              // filterMonthWiseExpense(state.mData);

              var dateWiseExpense = filderDayWiseExpense(state.mData);
              return mq!.orientation == Orientation.landscape
                  ? landscapeLay(dateWiseExpense, isDark)
                  : portraitLay(dateWiseExpense, isDark);
            } else {
              return Center(
                child: Text("NO Expense Yet!!!!\n Start adding todays."),
              );
            }
          }
          return Container(
            color: Colors.deepPurpleAccent.shade100,
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton(
                backgroundColor: isDark ? Colors.white : Colors.blueGrey,
                child: Icon(
                  Icons.stacked_bar_chart,
                  color: isDark ? Colors.blueGrey : Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StatsPage(mData: allExpenses)));
                }),
            FloatingActionButton(
                backgroundColor: isDark ? Colors.white : Colors.blueGrey,
                child: Icon(
                  Icons.add,
                  color: isDark ? Colors.blueGrey : Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddExpenseScreen(balance: lastBalance)));
                }),
          ],
        ),
      ),
    );
  }

  Widget portraitLay(List<DateWiseExpenseModel> dateWiseExpense, bool isDark) {
    return Column(
      children: [
        Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Card(
            color: isDark ? Colors.deepPurpleAccent.shade100 : Colors.lightBlue.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your Balance till now",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                    Icon(Icons.currency_rupee),
                    Text(
                      "$lastBalance",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold,color: isDark ? Colors.white : Colors.black),
                    )
                  ],
                ),
              ),
            ),
          ),
        )),
        Expanded(flex: 5, child: mainLayOut(dateWiseExpense, isDark)),
      ],
    );
  }

  void getWidthHeight() {
    mq = MediaQuery.of(context);
    mWidth = mq!.size.width;
    mHeight = mq!.size.height;
  }

  Widget landscapeLay(List<DateWiseExpenseModel> dateWiseExpense, bool isDark) {
    return Row(children: [
      Expanded(
          flex: 2,
          child: Card(
            color: Colors.lightBlue.shade100,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Your Balance till now",style: TextStyle(color: isDark ? Colors.white : Colors.black),),
                    Icon(Icons.currency_rupee),
                    Text(
                      "$lastBalance",
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold,color: isDark ? Colors.white : Colors.black),
                    )
                  ],
                ),
              ),
            ),
          )),
      Expanded(
        flex: 3,
        child: LayoutBuilder(builder: (_, constraints) {
          return mainLayOut(dateWiseExpense, isDark, isLandscape: false);
        }),
      )
    ]);
  }

  Widget mainLayOut(List<DateWiseExpenseModel> dateWiseExpense, bool isDark, {isLandscape = false}) {
    return ListView.builder(
        itemCount: dateWiseExpense.length,
        itemBuilder: (context, parentIndex) {
          var eachItem = dateWiseExpense[parentIndex];
          var randomCardColor =
              colorForCard[Random().nextInt(colorForCard.length)];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Card(
              color: randomCardColor,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${eachItem.date}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${eachItem.totalAmt}',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: eachItem.allTransactions.length,
                        itemBuilder: (_, childIndex) {
                          var eachTrans = eachItem.allTransactions[childIndex];
                          final randomColor =
                              colorRandom[Random().nextInt(colorRandom.length)];
                          return Card(
                            color: isDark ? Colors.grey : randomColor,
                            child: ListTile(
                              leading: Image.asset(AppConstants
                                  .mCategories[eachTrans.expCatType]
                                  .catImgPath),
                              title: Text("${eachTrans.expTitle}",style: TextStyle(color: isDark ? Colors.white : Colors.black),),
                              subtitle: Text("${eachTrans.expDesc}",style: TextStyle(color: isDark ? Colors.white : Colors.black),),
                              trailing: Column(
                                children: [
                                  Text(eachTrans.expAmt.toString(),style: TextStyle(color: isDark ? Colors.white : Colors.black),),

                                  ///balance will be added here
                                  Text(eachTrans.expBal.toString(),style: TextStyle(color: isDark ? Colors.white : Colors.black),),
                                  //balance will be added here
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }

  List<DateWiseExpenseModel> filderDayWiseExpense(
      List<ExpenseModel> allExpenses) {
    // dateWiseExpense.clear();
    List<DateWiseExpenseModel> dateWiseExpense = [];

    var listUniqueDates = [];
    for (ExpenseModel eachExp in allExpenses) {
      var mDate = DateTimeUtils.getFormattedDateFromMilli(
          int.parse(eachExp.expTimeStamp));
      if (!listUniqueDates.contains(mDate)) {
        listUniqueDates.add(mDate);
      }
    }
    print(listUniqueDates);

    for (String date in listUniqueDates) {
      List<ExpenseModel> eachDateExp = [];
      var totalAmt = 0.0;

      for (ExpenseModel eachExp in allExpenses) {
        // var eachDate = DateTime.fromMillisecondsSinceEpoch(
        //     int.parse(eachExp.expTimeStamp));
        var mDate = DateTimeUtils.getFormattedDateFromMilli(
            int.parse(eachExp.expTimeStamp));
        //dateFormat.format(eachDate);
        if (date == mDate) {
          eachDateExp.add(eachExp);

          if (eachExp.expType == 0) {
            totalAmt -= eachExp.expAmt;
          } else {
            totalAmt += eachExp.expAmt;
          }
        }
      }

      // var todayDate = DateTime.now();
      var formattedTodayDate =
          DateTimeUtils.getFormattedFromDateTime(DateTime.now());

      if (formattedTodayDate == date) {
        date = "Todays";
      }

      // var yesterdayDate = DateTime.now().subtract(Duration(days: 1));
      var formattedYesterdayDate = DateTimeUtils.getFormattedFromDateTime(
          DateTime.now().subtract(Duration(days: 1)));

      if (formattedYesterdayDate == date) {
        date = "Yesterday";
      }

      dateWiseExpense.add(DateWiseExpenseModel(
          date: date,
          totalAmt: totalAmt.toString(),
          allTransactions: eachDateExp));
    }
    return dateWiseExpense;
    print(dateWiseExpense.toString());
  }

  // List<MonthWiseExpenseModel> filterMonthWiseExpense(List<ExpenseModel> allExpenses) {
  //   List<MonthWiseExpenseModel> monthWiseExpense = [];
  //
  //   var listUniqueMonths = [];
  //   for (ExpenseModel eachExp in allExpenses) {
  //     var mMonths = DateTimeUtils.getFormattedMonthFromMilli(
  //         int.parse(eachExp.expTimeStamp));
  //
  //     if (!listUniqueMonths.contains(mMonths)) {
  //       listUniqueMonths.add(mMonths);
  //     }
  //   }
  //
  //   print(listUniqueMonths);
  //
  //   for (String month in listUniqueMonths) {
  //     List<ExpenseModel> thisMonthExpenses = [];
  //     num thisMonthaBal = 0.0;
  //
  //     for (ExpenseModel eachExp in allExpenses) {
  //       var mMonth = DateTimeUtils.getFormattedMonthFromMilli(
  //           int.parse(eachExp.expTimeStamp));
  //
  //       if (month == mMonth) {
  //         thisMonthExpenses.add(eachExp);
  //
  //         if (eachExp.expType == 0) {
  //           thisMonthaBal += eachExp.expAmt;
  //         }
  //       }
  //     }
  //     monthWiseExpense.add(MonthWiseExpenseModel(
  //         month: month,
  //         totalAmt: thisMonthaBal.toString(),
  //         allTransactions: thisMonthExpenses));
  //   }
  //
  //   return monthWiseExpense;
  // }
}
