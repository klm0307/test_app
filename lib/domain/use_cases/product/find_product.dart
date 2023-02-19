import 'package:dartz/dartz.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/model/product.dart';
import 'package:test_app/domain/repositories/interfaces/product_repository.dart';

abstract class FindProduct {
  Future<Either<Failure, Product>> execute(int id);
}

class FindProductImpl implements FindProduct {
  final ProductRepository productRepository;
  FindProductImpl(this.productRepository);

  @override
  Future<Either<Failure, Product>> execute(int id) async {
    var result = await productRepository.findProduct(id);
    return result;
  }
}
