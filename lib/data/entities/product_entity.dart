import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int? id;
  final String code;
  final bool state;
  final String price;
  final String product;
  final String description;
  final int categoryId;

  const ProductEntity(
      {this.id,
      required this.code,
      required this.state,
      required this.price,
      required this.product,
      required this.description,
      required this.categoryId});

  @override
  List<Object?> get props =>
      [id, code, state, price, product, description, categoryId];
}
