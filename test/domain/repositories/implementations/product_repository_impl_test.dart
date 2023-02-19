import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/data/data_sources/interfaces/product_datasource.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/data/entities/product_entity.dart';
import 'package:test_app/domain/domain.dart';

class MockProductDataSource extends Mock implements ProductDataSource {}

void main() {
  late ProductDataSource mockDataSource;
  late ProductRepository productRepository;
  const ProductEntity entity = ProductEntity(
      id: 1,
      code: '1',
      state: true,
      price: '100',
      product: 'TEST',
      description: 'Only item for testing',
      categoryId: 1);

  const Product product = Product(
      id: 1,
      code: '1',
      price: '100',
      product: 'TEST',
      description: 'Only item for testing',
      categoryId: 1,
      status: true);

  setUp(() {
    mockDataSource = MockProductDataSource();
    productRepository = ProductRepositoryImpl(mockDataSource);
  });

  group('#findAllProducts', () {
    test('should return all products', () async {
      List<ProductEntity> response = [entity];

      List<Product> expected = [product];

      when(() => mockDataSource.find()).thenAnswer((_) async => response);

      final result = await productRepository.findAllProducts();

      List<Product> resultList = List<Product>.empty();

      result.fold((l) => null, (r) => resultList = expected);

      expect(resultList, equals(expected));
    });

    test('should return failure on data source error', () async {
      Either<Failure, List<Product>> expected = Left(ServerFailure());
      when(() => mockDataSource.find()).thenThrow(ServerFailure());
      final result = await productRepository.findAllProducts();
      expect(result, equals(expected));
    });
  });

  group('#findProduct', () {
    test('should return one product by id', () async {
      const id = 1;
      Either<Failure, Product> expected = const Right(product);

      when(() => mockDataSource.findOne(id)).thenAnswer((_) async => entity);

      final result = await productRepository.findProduct(id);

      expect(result, equals(expected));
    });

    test('should return failure on data source error', () async {
      const id = 1;
      Either<Failure, Product> expected = Left(ServerFailure());

      when(() => mockDataSource.findOne(id)).thenThrow(ServerFailure());

      final result = await productRepository.findProduct(id);

      expect(result, equals(expected));
    });
  });

  group('#createProduct', () {
    test('should call create product method', () async {
      Either<Failure, Unit> expected = const Right<Failure, Unit>(unit);

      when(() => mockDataSource.create(ProductEntity(
          code: entity.code,
          state: entity.state,
          price: entity.price,
          product: entity.product,
          description: entity.description,
          categoryId: entity.categoryId))).thenAnswer((_) async => unit);

      final result = await productRepository.createProduct(product);

      expect(result, equals(expected));
    });

    test('should return failure on data source error', () async {
      Either<Failure, Unit> expected = Left(ServerFailure());
      when(() => mockDataSource.create(ProductEntity(
          code: entity.code,
          state: entity.state,
          price: entity.price,
          product: entity.product,
          description: entity.description,
          categoryId: entity.categoryId))).thenThrow(ServerFailure());

      final result = await productRepository.createProduct(product);

      expect(result, equals(expected));
    });
  });

  group('#updateProduct', () {
    test('should call update product method', () async {
      const id = 1;
      Either<Failure, Unit> expected = const Right<Failure, Unit>(unit);

      when(() => mockDataSource.update(id,
              description: 'Updated description of product testing'))
          .thenAnswer((_) async => unit);

      final result = await productRepository.updateProduct(id,
          description: 'Updated description of product testing');

      expect(result, equals(expected));
      verify(() => mockDataSource.update(id,
          description: 'Updated description of product testing'));
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return failure on data source error', () async {
      const id = 1;
      Either<Failure, Unit> expected = Left(ServerFailure());
      when(() => mockDataSource.update(id,
              description: 'Updated description of product testing'))
          .thenThrow(ServerFailure());

      final result = await productRepository.updateProduct(id,
          description: 'Updated description of product testing');

      expect(result, equals(expected));
    });
  });

  group('#deleteProduct', () {
    test('should call delete product method', () async {
      const id = 1;
      Either<Failure, Unit> expected = const Right<Failure, Unit>(unit);
      when(() => mockDataSource.delete(id)).thenAnswer((_) async => unit);

      final result = await productRepository.deleteProduct(id);

      expect(result, equals(expected));
    });

    test('should return failure on data source error', () async {
      const id = 1;
      when(() => mockDataSource.delete(id)).thenThrow(ServerFailure());

      final result = await productRepository.deleteProduct(id);

      expect(result, equals(Left(ServerFailure())));
    });
  });
}
