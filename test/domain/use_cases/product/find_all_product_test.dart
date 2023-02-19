import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/domain/model/product.dart';
import 'package:test_app/domain/repositories/interfaces/product_repository.dart';
import 'package:test_app/domain/use_cases/product/find_all_products.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository mockProductRepository;
  late FindAllProducts useCase;

  setUp(() {
    mockProductRepository = MockProductRepository();
    useCase = FindAllProductsImpl(mockProductRepository);
  });

  test('should find all products from product repository', () async {
    Either<Failure, List<Product>> repositoryResult =
        const Right<Failure, List<Product>>([]);

    when(() => mockProductRepository.findAllProducts())
        .thenAnswer((_) async => repositoryResult);

    final result = await useCase.execute();

    expect(result, equals(repositoryResult));
    verify(() => mockProductRepository.findAllProducts());
    verifyNoMoreInteractions(mockProductRepository);
  });
}
