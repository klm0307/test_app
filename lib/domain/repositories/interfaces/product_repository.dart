import 'package:dartz/dartz.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/model/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> findAllProducts();

  Future<Either<Failure, Product>> findProduct(int id);

  Future<Either<Failure, Unit>> createProduct(Product data);

  Future<Either<Failure, Unit>> updateProduct(
    int id, {
    String? code,
    bool? status,
    String? price,
    String? product,
    String? description,
    int? categoryId,
  });

  Future<Either<Failure, Unit>> deleteProduct(int id);
}
