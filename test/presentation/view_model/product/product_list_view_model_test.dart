import 'package:dartz/dartz.dart';
import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/domain/domain.dart';

import 'package:test_app/presentation/view_model/product/list.dart';

class MockFindAllProducts extends Mock implements FindAllProducts {}

class MockDeleteProduct extends Mock implements DeleteProduct {}

void main() {
  late FindAllProducts mockFindAllProducts;
  late DeleteProduct mockDeleteProduct;

  setUp(() {
    mockFindAllProducts = MockFindAllProducts();
    mockDeleteProduct = MockDeleteProduct();
  });

  testWidgets('should return products data', (widgetTester) async {
    const resultUseCase = Right<Failure, List<Product>>([
      Product(
          id: 1,
          code: 'code',
          status: true,
          price: '20',
          product: 'product',
          description: 'description',
          categoryId: 1),
      Product(
          id: 2,
          code: 'code',
          status: true,
          price: '20',
          product: 'product',
          description: 'description',
          categoryId: 2)
    ]);

    when(() => mockFindAllProducts.execute())
        .thenAnswer((_) async => resultUseCase);
    when(() => mockDeleteProduct.execute(1))
        .thenAnswer((_) async => const Right(unit));
    final result = await buildHook((_) => useProductListViewModel(
        findAllProducts: mockFindAllProducts,
        deleteProductUseCase: mockDeleteProduct));

    await act(() => result.current.getProducts());
    expect(result.current.data.length, 2);
    verify(() => mockFindAllProducts.execute());

    await act(() => result.current.deleteProduct(1));
    verify(() => mockDeleteProduct.execute(1));
  });

  testWidgets('should return error message if find products fail',
      (WidgetTester tester) async {
    Either<Failure, List<Product>> useCaseResult = Left(ServerFailure());
    when(() => mockFindAllProducts.execute())
        .thenAnswer((_) async => useCaseResult);
    final result = await buildHook((_) => useProductListViewModel(
        findAllProducts: mockFindAllProducts,
        deleteProductUseCase: mockDeleteProduct));

    await act(() => result.current.getProducts());

    verify(() => mockFindAllProducts.execute());
    expect(result.current.error, 'Ocurrió un error al buscar los productos');
  });

  testWidgets('should return error message if delete product fails',
      (tester) async {
    //arrange
    when(() => mockDeleteProduct.execute(1))
        .thenAnswer((_) async => Left(ServerFailure()));
    final result = await buildHook((_) => useProductListViewModel(
        findAllProducts: mockFindAllProducts,
        deleteProductUseCase: mockDeleteProduct));

    //act
    await act(() => result.current.deleteProduct(1));

    //assert Fetch
    expect(result.current.error, 'Ocurrió un error al borrar el producto');
  });
}
