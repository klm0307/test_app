import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/data/data.dart';
import 'package:test_app/data/data_sources/interfaces/category_datasource.dart';
import 'package:test_app/domain/domain.dart';

class MockCategoryDataSource extends Mock implements CategoryDataSource {}

void main() {
  late CategoryDataSource mockDataSource;
  late CategoryRepository categoryRepository;
  const CategoryEntity entity = CategoryEntity(id: 1, name: '', type: '');

  const Category product = Category(id: 1, name: '', type: '');

  setUp(() {
    mockDataSource = MockCategoryDataSource();
    categoryRepository = CategoryRepositoryImpl(mockDataSource);
  });

  group('#findAllCategories', () {
    test('should return all categories', () async {
      List<CategoryEntity> response = [entity];

      List<Category> expected = [product];

      when(() => mockDataSource.find()).thenAnswer((_) async => response);

      final result = await categoryRepository.findAllCategories();

      List<Category> resultList = List<Category>.empty();

      result.fold((l) => null, (r) => resultList = expected);

      expect(resultList, equals(expected));
    });

    test('should return failure on data source error', () async {
      Either<Failure, List<Product>> expected = Left(ServerFailure());
      when(() => mockDataSource.find()).thenThrow(ServerFailure());
      final result = await categoryRepository.findAllCategories();
      expect(result, equals(expected));
    });
  });
}
