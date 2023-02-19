import 'package:test_app/data/entities/category_entity.dart';

abstract class CategoryDataSource {
  Future<List<CategoryEntity>> find();
}
