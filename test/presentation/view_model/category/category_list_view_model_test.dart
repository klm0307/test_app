import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/core.dart';
import 'package:test_app/domain/domain.dart';
import 'package:flutter_hooks_test/flutter_hooks_test.dart';
import 'package:test_app/presentation/view_model/category/list.dart';

class MockFindAllCategories extends Mock implements FindAllCategories {}

void main() {
  late FindAllCategories mockFindAllCategories;

  setUp(() {
    mockFindAllCategories = MockFindAllCategories();
  });

  testWidgets('should return categories data', (widgetTester) async {
    const resultUseCase = Right<Failure, List<Category>>([
      Category(id: 1, name: 'name', type: 'type'),
      Category(id: 2, name: 'name 2', type: 'type 2')
    ]);

    when(() => mockFindAllCategories.execute())
        .thenAnswer((_) async => resultUseCase);
    final result = await buildHook((_) =>
        useCategoryListViewModel(findAllCategories: mockFindAllCategories));

    await act(() => result.current.getData());

    verify(() => mockFindAllCategories.execute());
    expect(result.current.data.length, 2);
  });

  testWidgets('should return error message', (WidgetTester tester) async {
    Either<Failure, List<Category>> useCaseResult = Left(ServerFailure());
    when(() => mockFindAllCategories.execute())
        .thenAnswer((_) async => useCaseResult);
    final result = await buildHook((_) =>
        useCategoryListViewModel(findAllCategories: mockFindAllCategories));

    await act(() => result.current.getData());

    verify(() => mockFindAllCategories.execute());
    expect(result.current.error, 'Ocurrió un error al buscar las categorías');
  });
}
