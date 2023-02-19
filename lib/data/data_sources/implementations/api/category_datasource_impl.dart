import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_app/data/data_sources/interfaces/category_datasource.dart';
import 'package:test_app/data/entities/category_entity.dart';
import 'package:dio/dio.dart';

class CategoryDataSourceImpl implements CategoryDataSource {
  @override
  Future<List<CategoryEntity>> find() async {
    var response = await Dio().get(
      '${dotenv.env['API_URL']}/categorias',
      options: Options(headers: {'content-type': 'application/json'}),
    );
    List<CategoryEntity> list = [];
    response.data.forEach((category) {
      list.add(CategoryEntity(
          id: category['id'],
          name: category['nombre'],
          type: category['tipo']));
    });

    return list;
  }
}
