import 'package:flutter/material.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:test_app/data/data_sources/interfaces/category_datasource.dart';
import 'package:test_app/data/entities/category_entity.dart';
import 'package:test_app/domain/model/category.dart';
import 'package:test_app/domain/repositories/interfaces/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryDataSource categoryDataSource;
  CategoryRepositoryImpl(this.categoryDataSource);

  @override
  Future<Either<Failure, List<Category>>> findAllCategories() async {
    try {
      List<CategoryEntity> result = await categoryDataSource.find();
      return Right(result
          .map((e) => Category(id: e.id, name: e.name, type: e.type))
          .toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
