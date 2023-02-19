import 'package:flutter/material.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:test_app/data/data_sources/interfaces/product_datasource.dart';
import 'package:test_app/data/entities/product_entity.dart';
import 'package:test_app/domain/model/product.dart';
import 'package:test_app/domain/repositories/interfaces/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductDataSource productDataSource;
  ProductRepositoryImpl(this.productDataSource);

  @override
  Future<Either<Failure, Unit>> createProduct(Product data) async {
    try {
      final result = await productDataSource.create(ProductEntity(
          code: data.code,
          state: data.status,
          price: data.price,
          product: data.product,
          description: data.description,
          categoryId: data.categoryId));

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(int id) async {
    try {
      final result = await productDataSource.delete(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> findAllProducts() async {
    try {
      List<ProductEntity> result = await productDataSource.find();

      return Right(result
          .map((e) => Product(
              id: e.id,
              code: e.code,
              status: e.state,
              price: e.price,
              product: e.product,
              description: e.description,
              categoryId: e.categoryId))
          .toList());
    } catch (e) {
      debugPrint(e.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> findProduct(int id) async {
    try {
      final result = await productDataSource.findOne(id);
      return Right(Product(
          id: result.id,
          code: result.code,
          description: result.description,
          status: result.state,
          categoryId: result.categoryId,
          price: result.price,
          product: result.product));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(int id,
      {String? code,
      bool? status,
      String? price,
      String? product,
      String? description,
      int? categoryId}) async {
    try {
      final result = await productDataSource.update(id,
          code: code,
          status: status,
          price: price,
          product: product,
          description: description,
          categoryId: categoryId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
