import 'dart:math';

import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:d_chart/ordinal/pie.dart';
import 'package:expense_app/app_constants/content_constants.dart';
import 'package:expense_app/models/categories_model.dart';
import 'package:expense_app/models/expense_model.dart';
import 'package:flutter/material.dart';


class StatsPage extends StatefulWidget {
  List<ExpenseModel> mData;

  StatsPage({required this.mData});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<CatWiseExpenseModel> catWiseData = [];
  List<OrdinalGroup> listOrdinalGrp = [];
  List<OrdinalData> listOrdinalData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterCatWiseData();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness==Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 10 / 8,
              child: DChartBarO(
                allowSliding: true,
                animate: true,
                fillColor: (_, __, index){
                  if(index!%2==0){
                    return Colors.blueGrey;
                  } else {
                    return Colors.blueGrey;
                  }

                },
                groupList: listOrdinalGrp,
              ),
            ),
          ),
          Expanded(
            child:
            AspectRatio(
            // aspectRatio: 16 / 9,
            // child: DChartPieO(
            //   data: listOrdinalData,
            //   configRenderPie: const ConfigRenderPie(
            //     strokeWidthPx: 20,
            //     arcWidth: 20,
            //   ),
            // ),
              aspectRatio: 16 / 9,
              child: DChartPieO(
                data: listOrdinalData,
                configRenderPie: const ConfigRenderPie(
                  arcWidth: 30,
                ),
              ),
          ),
          ),

          Expanded(
            child: ListView.builder(
                itemCount: catWiseData.length,
                itemBuilder: (_, parentIndex) {
                  var eachItem = catWiseData[parentIndex];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                  '${eachItem.catName}',
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
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                child: Card(
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
                                ),
                              );
                            })
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void filterCatWiseData() {
    for (CategoryModel eachCat in AppConstants.mCategories) {
      var catName = eachCat.catTitle;
      var eachCatAmt = 0.0;
      List<ExpenseModel> catTrans = [];

      for (ExpenseModel eachExp in widget.mData) {
        if ((eachExp.expCatType+1) == eachCat.catId) {
          catTrans.add(eachExp);

          if (eachExp.expType == 0) {
            ///debit
            eachCatAmt -= eachExp.expAmt;
          } else {
            ///credit
            eachCatAmt += eachExp.expAmt;
          }
        }
      }

      if(catTrans.isNotEmpty) {
        catWiseData.add(CatWiseExpenseModel(
            catName: catName,
            totalAmt: eachCatAmt.toString(),
            allTransactions: catTrans));

        listOrdinalData.add(OrdinalData(
            domain: catName,
            measure: eachCatAmt.isNegative ? eachCatAmt*-1 : eachCatAmt,
            color: Colors.blueGrey
        ));
      }
    }
    listOrdinalGrp.add(OrdinalGroup(id: "1", data: listOrdinalData));
  }
}