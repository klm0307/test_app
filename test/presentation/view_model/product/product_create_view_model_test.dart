import 'package:dartz/dartz.dart';
import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/domain/model/product.dart';
import 'package:test_app/domain/use_cases/product/create_product.dart';
import 'package:test_app/presentation/view_model/product/create.dart';

class MockCreateProduct extends Mock implements CreateProduct {}

void main() {
  late CreateProduct mockCreateProduct;
  setUp(() {
    mockCreateProduct = MockCreateProduct();
  });

  testWidgets("should call saveCustomerData", (tester) async {
    //arrange

    const product = Product(
        code: 'code',
        status: true,
        price: 'price',
        product: 'product',
        description: 'description',
        categoryId: 1);
    Either<Failure, Unit> useCaseResult = const Right(unit);
    when(() => mockCreateProduct.execute(product))
        .thenAnswer((_) async => useCaseResult);
    final result = await buildHook(
        (_) => useCreateProductViewModel(createProduct: mockCreateProduct));

    //act
    await act(() => result.current.createProduct(
        code: product.code,
        status: product.status,
        price: product.price,
        product: product.product,
        description: product.description,
        categoryId: product.categoryId));

    //assert
    verify(() => mockCreateProduct.execute(product));
    verifyNoMoreInteractions(mockCreateProduct);
  });

  testWidgets("should set Error message if saveCustomerData fails",
      (tester) async {
    const product = Product(
        code: 'code',
        status: true,
        price: 'price',
        product: 'product',
        description: 'description',
        categoryId: 1);
    when(() => mockCreateProduct.execute(product))
        .thenAnswer((_) async => Left(ServerFailure()));
    final result = await buildHook(
        (_) => useCreateProductViewModel(createProduct: mockCreateProduct));

    await act(() => result.current.createProduct(
        code: product.code,
        status: product.status,
        price: product.price,
        product: product.product,
        description: product.description,
        categoryId: product.categoryId));

    verify(() => mockCreateProduct.execute(product));
    expect(result.current.error, 'Ocurrió un error al crear el producto');
  });
}
