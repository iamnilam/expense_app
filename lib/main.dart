import 'package:expense_app/db/app_db.dart';
import 'package:expense_app/expense_bloc/expense_bloc.dart';
import 'package:expense_app/provider/theme_proiver.dart';
import 'package:expense_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: BlocProvider<ExpenseBloc>(
      create: (context) => ExpenseBloc(db: AppDataBase.instance),
      child: MyApp(),
    ),
  )
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   // context.read<ThemeProvider>().updateThemeOnStart();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: context.watch<ThemeProvider>().themeValue
          ? ThemeMode.dark
          : ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
