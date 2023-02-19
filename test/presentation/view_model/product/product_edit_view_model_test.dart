import 'package:dartz/dartz.dart';
import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/domain/domain.dart';
import 'package:test_app/presentation/view_model/product/edit.dart';

class MockFindProduct extends Mock implements FindProduct {}

class MockUpdateProduct extends Mock implements UpdateProduct {}

void main() {
  late FindProduct mockFindProductUseCase;
  late UpdateProduct mockUpdateProductUseCase;

  setUp(() {
    mockFindProductUseCase = MockFindProduct();
    mockUpdateProductUseCase = MockUpdateProduct();
  });

  testWidgets('should call find products', (tester) async {
    const expected = Product(
        id: 1,
        code: 'code',
        status: false,
        price: 'price',
        product: 'product',
        description: 'description',
        categoryId: 1);

    Either<Failure, Product> useCaseResult = const Right(expected);
    when(() => mockFindProductUseCase.execute(expected.id!))
        .thenAnswer((_) async => useCaseResult);
    when(
      () => mockUpdateProductUseCase.execute(
        expected.id!,
        description: 'update description',
      ),
    ).thenAnswer((_) async => const Right(unit));

    final result = await buildHook((_) => useEditProductViewModel(
        getProduct: mockFindProductUseCase,
        updateProduct: mockUpdateProductUseCase));

    await act(() => result.current.getProduct(expected.id!));
    verify(() => mockFindProductUseCase.execute(expected.id!));
    expect(result.current.data, expected);

    await act(
        () => result.current.updateProduct(description: 'update description'));
    verify(() => mockUpdateProductUseCase.execute(
          expected.id!,
          description: 'update description',
        ));
  });

  testWidgets('should return error if find product fail', (tester) async {
    when(() => mockFindProductUseCase.execute(1))
        .thenAnswer((_) async => Left(ServerFailure()));
    final result = await buildHook((_) => useEditProductViewModel(
        getProduct: mockFindProductUseCase,
        updateProduct: mockUpdateProductUseCase));

    await act(() => result.current.getProduct(1));

    expect(result.current.error,
        'Ocurrió un error al buscar el producto con id: 1');
  });

  testWidgets('should return error if update product fails', (tester) async {
    const expected = Product(
        id: 1,
        code: 'code',
        status: false,
        price: 'price',
        product: 'product',
        description: 'description',
        categoryId: 1);
    Either<Failure, Product> useCaseResult = const Right(expected);
    when(() => mockFindProductUseCase.execute(expected.id!))
        .thenAnswer((_) async => useCaseResult);

    when(() => mockUpdateProductUseCase.execute(expected.id!,
            description: 'update description'))
        .thenAnswer((_) async => Left(ServerFailure()));
    final result = await buildHook((_) => useEditProductViewModel(
        getProduct: mockFindProductUseCase,
        updateProduct: mockUpdateProductUseCase));

    await act(() => result.current.getProduct(1));
    await act(
        () => result.current.updateProduct(description: 'update description'));

    expect(result.current.error, 'Ocurrió un error al actualizar el producto');
  });
}
