import 'package:dartz/dartz.dart';
import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/domain/model/product.dart';
import 'package:test_app/domain/use_cases/product/find_product.dart';
import 'package:test_app/presentation/view_model/product/detail.dart';

class MockFindProduct extends Mock implements FindProduct {}

void main() {
  late FindProduct mockFindProduct;

  setUp(() {
    mockFindProduct = MockFindProduct();
  });

  testWidgets('should call find products', (tester) async {
    const expected = Product(
        id: 1,
        code: 'code',
        status: true,
        price: '20',
        product: 'product',
        description: 'description',
        categoryId: 1);
    Either<Failure, Product> useCaseResult = const Right(expected);
    when(() => mockFindProduct.execute(expected.id!))
        .thenAnswer((_) async => useCaseResult);

    final result = await buildHook(
        (_) => useProductDetailViewModel(findProduct: mockFindProduct));

    await act(() => result.current.getProduct(expected.id!));
    expect(result.current.data, expected);
    verify(() => mockFindProduct.execute(expected.id!));
  });

  testWidgets('should return error message if find products fail',
      (tester) async {
    //arrange
    when(() => mockFindProduct.execute(1))
        .thenAnswer((_) async => Left(ServerFailure()));

    final result = await buildHook(
        (_) => useProductDetailViewModel(findProduct: mockFindProduct));

    //act
    await act(() => result.current.getProduct(1));

    //assert Fetch
    expect(result.current.error,
        'Ocurrió un error al buscar el producto con id: 1');
  });
}
