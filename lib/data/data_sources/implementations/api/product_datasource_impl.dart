import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_app/data/data_sources/interfaces/product_datasource.dart';
import 'package:test_app/data/entities/product_entity.dart';

class ProductDataSourceImpl implements ProductDataSource {
  @override
  Future<Unit> create(ProductEntity data) async {
    await Dio().post('${dotenv.env['API_URL']}/productos',
        options: Options(headers: {'content-type': 'application/json'}),
        data: jsonEncode({
          'codigo': data.code,
          'descripcion': data.description,
          'estado': data.state,
          'idCategoria': data.categoryId,
          'precio': data.price,
          'producto': data.product
        }));
    return unit;
  }

  @override
  Future<Unit> delete(int id) async {
    await Dio().delete(
      '${dotenv.env['API_URL']}/productos/$id',
      options: Options(headers: {'content-type': 'application/json'}),
    );
    return unit;
  }

  @override
  Future<List<ProductEntity>> find() async {
    var response = await Dio().get(
      '${dotenv.env['API_URL']}/productos',
      options: Options(headers: {'content-type': 'application/json'}),
    );
    List<ProductEntity> list = [];

    response.data.forEach((product) {
      list.add(ProductEntity(
          id: product['id'],
          code: product['codigo'],
          description: product['descripcion'],
          state: product['estado'],
          categoryId: product['idCategoria'],
          price: product['precio'],
          product: product['producto']));
    });

    return list;
  }

  @override
  Future<ProductEntity> findOne(int id) async {
    var response = await Dio().get(
      '${dotenv.env['API_URL']}/productos/$id',
      options: Options(headers: {'content-type': 'application/json'}),
    );
    ProductEntity product = ProductEntity(
        id: response.data['id'],
        code: response.data['codigo'],
        description: response.data['descripcion'],
        state: response.data['estado'],
        categoryId: response.data['idCategoria'],
        price: response.data['precio'],
        product: response.data['producto']);
    return product;
  }

  @override
  Future<Unit> update(int id,
      {String? code,
      bool? status,
      String? price,
      String? product,
      String? description,
      int? categoryId}) async {
    dynamic toUpdate = {};

    if (code != null) {
      toUpdate['codigo'] = code;
    }

    if (status != null) {
      toUpdate['estado'] = status;
    }

    if (price != null) {
      toUpdate['precio'] = price;
    }

    if (product != null) {
      toUpdate['producto'] = product;
    }

    if (description != null) {
      toUpdate['descripcion'] = description;
    }

    if (categoryId != null) {
      toUpdate['idCategoria'] = categoryId;
    }

    await Dio().patch('${dotenv.env['API_URL']}/productos/$id',
        options: Options(headers: {'content-type': 'application/json'}),
        data: toUpdate);

    return unit;
  }
}
