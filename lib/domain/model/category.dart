import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Category extends Equatable {
  final int? id;
  final String name;
  final String type;

  const Category({this.id, required this.name, required this.type});

  dynamic toJson() => {
        'id': id,
        'name': name,
        'type': type,
      };

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  List<Object?> get props => [id, name, type];
}
