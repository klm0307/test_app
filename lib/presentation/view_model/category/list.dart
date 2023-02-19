import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/model/category.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_app/domain/use_cases/category/find_all_category.dart';
import 'package:test_app/presentation/view_model/base_view_model.dart';

class CategoryListViewModel extends BaseViewModel {
  List<Category> data;
  Function getData;
  CategoryListViewModel(
      {required this.data, required this.getData, required String error})
      : super(error: error);
}

CategoryListViewModel useCategoryListViewModel(
    {required FindAllCategories findAllCategories}) {
  final categories = useState<List<Category>>([]);
  final error = useState<String>("");

  void getDataFn() async {
    var result = await findAllCategories.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Ocurrió un error al buscar las categorías';
      }
    }, (data) {
      categories.value = data;
    });
  }

  return CategoryListViewModel(
      data: categories.value, error: error.value, getData: getDataFn);
}
