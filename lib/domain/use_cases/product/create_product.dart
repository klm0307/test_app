import 'package:dartz/dartz.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/model/product.dart';
import 'package:test_app/domain/repositories/interfaces/product_repository.dart';

abstract class CreateProduct {
  Future<Either<Failure, Unit>> execute(Product product);
}

class CreateProductImpl implements CreateProduct {
  final ProductRepository productRepository;

  CreateProductImpl(this.productRepository);

  @override
  Future<Either<Failure, Unit>> execute(Product product) async {
    return await productRepository.createProduct(product);
  }
}
