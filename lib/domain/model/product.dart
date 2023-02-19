import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Product extends Equatable {
  final int? id;
  final String code;
  final bool status;
  final String price;
  final String product;
  final String description;
  final int categoryId;

  const Product(
      {this.id,
      required this.code,
      required this.status,
      required this.price,
      required this.product,
      required this.description,
      required this.categoryId});

  dynamic toJson() => {
        'id': id,
        'code': code,
        'status': status,
        'price': price,
        'product': product,
        'description': description,
        'categoryId': categoryId,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  List<Object?> get props =>
      [id, code, status, price, product, description, categoryId];
}
