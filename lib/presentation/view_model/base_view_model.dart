import 'package:flutter/material.dart';

class BaseViewModel {
  String error;
  BaseViewModel({required this.error});
}

Widget buildError(BaseViewModel vm) {
  return Center(
    child: Text(
      vm.error,
      style: TextStyle(color: Colors.red[400], fontWeight: FontWeight.w600),
    ),
  );
}
