import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/domain/domain.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository mockProductRepository;
  late FindProduct useCase;

  setUp(() {
    mockProductRepository = MockProductRepository();
    useCase = FindProductImpl(mockProductRepository);
  });
  test('should return a product from the product repository by id', () async {
    const id = 1;
    Either<Failure, Product> repoResponse = const Right(Product(
        code: 'code',
        status: false,
        price: 'price',
        product: 'product',
        description: 'description',
        categoryId: 1));
    when(() => mockProductRepository.findProduct(id))
        .thenAnswer((_) async => repoResponse);

    final result = await useCase.execute(id);

    expect(result, equals(repoResponse));
    verify(() => mockProductRepository.findProduct(id));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
