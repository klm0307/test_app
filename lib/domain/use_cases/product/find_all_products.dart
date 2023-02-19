import 'package:dartz/dartz.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/model/product.dart';
import 'package:test_app/domain/repositories/interfaces/product_repository.dart';

abstract class FindAllProducts {
  Future<Either<Failure, List<Product>>> execute();
}

class FindAllProductsImpl implements FindAllProducts {
  final ProductRepository productRepository;

  FindAllProductsImpl(this.productRepository);

  @override
  Future<Either<Failure, List<Product>>> execute() async {
    var result = await productRepository.findAllProducts();

    return result;
  }
}
