import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/domain/domain.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductRepository mockProductRepository;
  late UpdateProduct useCase;

  setUp(() {
    mockProductRepository = MockProductRepository();
    useCase = UpdateProductImpl(mockProductRepository);
  });

  test('should call update method of product repository', () async {
    const id = 1;
    Either<Failure, Unit> repoResponse = const Right(unit);
    when(() => mockProductRepository.updateProduct(id,
            description: 'update description'))
        .thenAnswer((_) async => repoResponse);

    final result = await useCase.execute(id, description: 'update description');

    expect(result, equals(repoResponse));
    verify(() => mockProductRepository.updateProduct(id,
        description: 'update description'));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
