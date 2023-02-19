import 'package:dartz/dartz.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/model/category.dart';
import 'package:test_app/domain/repositories/interfaces/category_repository.dart';

abstract class FindAllCategories {
  Future<Either<Failure, List<Category>>> execute();
}

class FindAllCategoriesImpl implements FindAllCategories {
  final CategoryRepository categoryRepository;

  FindAllCategoriesImpl(this.categoryRepository);

  @override
  Future<Either<Failure, List<Category>>> execute() async {
    var result = await categoryRepository.findAllCategories();
    return result;
  }
}
