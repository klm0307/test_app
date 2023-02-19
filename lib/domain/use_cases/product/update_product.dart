import 'package:dartz/dartz.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/repositories/interfaces/product_repository.dart';

abstract class UpdateProduct {
  Future<Either<Failure, Unit>> execute(
    int id, {
    String? code,
    bool? status,
    String? price,
    String? product,
    String? description,
    int? categoryId,
  });
}

class UpdateProductImpl implements UpdateProduct {
  final ProductRepository productRepository;

  UpdateProductImpl(this.productRepository);

  @override
  Future<Either<Failure, Unit>> execute(
    int id, {
    String? code,
    bool? status,
    String? price,
    String? product,
    String? description,
    int? categoryId,
  }) async {
    return await productRepository.updateProduct(id,
        code: code,
        status: status,
        price: price,
        product: product,
        description: description,
        categoryId: categoryId);
  }
}
