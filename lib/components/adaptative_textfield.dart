import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class AdaptativeTextField extends StatelessWidget {

  final label;
  final onSubmited;
  final controller;
  final keyboardType;

  AdaptativeTextField ({
    this.label,
    this.onSubmited,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS?
      CupertinoTextField(
        controller: controller,
        keyboardType: keyboardType,
        onSubmitted: onSubmited,
        placeholderStyle: label,   
      
    )
    : TextField(
      controller: controller,
      keyboardType: keyboardType,
      onSubmitted: onSubmited,
      decoration: InputDecoration(
        labelText: label),
    );
  }
}