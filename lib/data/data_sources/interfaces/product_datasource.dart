import 'package:test_app/data/entities/product_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProductDataSource {
  Future<List<ProductEntity>> find();
  Future<ProductEntity> findOne(int id);
  Future<Unit> create(ProductEntity data);
  Future<Unit> update(
    int id, {
    String? code,
    bool? status,
    String? price,
    String? product,
    String? description,
    int? categoryId,
  });
  Future<Unit> delete(int id);
}
