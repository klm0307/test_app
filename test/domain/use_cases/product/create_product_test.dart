import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/domain/domain.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository mockProductRepository;
  late CreateProduct useCase;

  setUp(() {
    mockProductRepository = MockProductRepository();
    useCase = CreateProductImpl(mockProductRepository);
  });

  test('should call the create customer from repository', () async {
    const repositoryResult = Right<Failure, Unit>(unit);
    const data = Product(
        code: 'code',
        status: true,
        price: 'price',
        product: 'product',
        description: 'description',
        categoryId: 1);
    when(() => mockProductRepository.createProduct(data))
        .thenAnswer((_) async => repositoryResult);

    final result = await useCase.execute(data);

    expect(result, equals(repositoryResult));
    verify(() => mockProductRepository.createProduct(data));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
