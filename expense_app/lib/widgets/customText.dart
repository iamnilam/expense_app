import 'package:flutter/material.dart';

class CstmTextField extends StatelessWidget {
  const CstmTextField(
      {super.key,
      required this.label,
      required this.iconData,
      this.keyboardType = TextInputType.text,
      this.controller});

  final String label;
  final IconData iconData;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: isDark ? Colors.blueGrey : Colors.white,),
        decoration: InputDecoration(
          labelStyle: TextStyle(color: isDark ? Colors.blueGrey : Colors.white,),
          filled: true,
          fillColor: isDark ? Colors.white : Colors.blueGrey,
         // btnColor: isDark ? Colors.blueGrey : Colors.white ,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white),
          ),
          hintText: label,
          hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.blueGrey : Colors.white,
            //btnColor: isDark ? Colors.blueGrey : Colors.white ,
          ),
          suffixIcon: Icon(
            iconData,
            size: 30,
            color: isDark ? Colors.blueGrey : Colors.white,
          ),
        ),
      ),
    );
  }
}
