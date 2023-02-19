import 'package:dartz/dartz.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/repositories/interfaces/product_repository.dart';

abstract class DeleteProduct {
  Future<Either<Failure, Unit>> execute(int id);
}

class DeleteProductImpl implements DeleteProduct {
  final ProductRepository productRepository;

  DeleteProductImpl(this.productRepository);

  @override
  Future<Either<Failure, Unit>> execute(int id) async {
    return await productRepository.deleteProduct(id);
  }
}
