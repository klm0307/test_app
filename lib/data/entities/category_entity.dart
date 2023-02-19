import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int? id;
  final String name;
  final String type;

  const CategoryEntity({this.id, required this.name, required this.type});

  @override
  List<Object?> get props => [id, name, type];
}
