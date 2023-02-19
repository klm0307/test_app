import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/domain/domain.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository mockProductRepository;
  late DeleteProduct useCase;

  setUp(() {
    mockProductRepository = MockProductRepository();
    useCase = DeleteProductImpl(mockProductRepository);
  });

  test('should call the delete product method from repository', () async {
    const repositoryResult = Right<Failure, Unit>(unit);
    const id = 1;

    when(() => mockProductRepository.deleteProduct(id))
        .thenAnswer((_) async => repositoryResult);

    final result = await useCase.execute(1);

    expect(result, equals(repositoryResult));
    verify(() => mockProductRepository.deleteProduct(id));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
