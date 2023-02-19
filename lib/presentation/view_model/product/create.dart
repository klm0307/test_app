import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/model/product.dart';
import 'package:test_app/domain/use_cases/product/create_product.dart';
import 'package:test_app/presentation/view_model/base_view_model.dart';

class CreateProductViewModel extends BaseViewModel {
  Product data;

  Function(
      {required String code,
      required String description,
      required bool status,
      required int categoryId,
      required String price,
      required String product}) createProduct;

  CreateProductViewModel(
      {required this.data, required this.createProduct, required String error})
      : super(error: error);
}

CreateProductViewModel useCreateProductViewModel(
    {required CreateProduct createProduct}) {
  final currentProduct = useState<Product>(const Product(
      code: "",
      status: false,
      price: "",
      product: "",
      description: "",
      categoryId: 0));

  final error = useState('');

  void createProductFn(
      {required String code,
      required String description,
      required bool status,
      required int categoryId,
      required String price,
      required String product}) async {
    var result = await createProduct.execute(Product(
      code: code,
      description: description,
      status: status,
      categoryId: categoryId,
      price: price,
      product: product,
    ));

    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Ocurrió un error al crear el producto';
      }
    }, (data) {});
  }

  return CreateProductViewModel(
      data: currentProduct.value,
      createProduct: createProductFn,
      error: error.value);
}
