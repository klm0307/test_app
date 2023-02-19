import 'package:dartz/dartz.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/model/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> findAllCategories();
}
