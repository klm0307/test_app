import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/model/product.dart';
import 'package:test_app/domain/use_cases/product/find_product.dart';
import 'package:test_app/domain/use_cases/product/update_product.dart';
import 'package:test_app/presentation/view_model/base_view_model.dart';

class EditProductViewModel extends BaseViewModel {
  Product data;
  Function(int id) getProduct;
  Function(
      {String? code,
      String? description,
      bool? status,
      int? categoryId,
      String? price,
      String? product}) updateProduct;
  EditProductViewModel({
    required this.data,
    required this.getProduct,
    required this.updateProduct,
    required String error,
  }) : super(error: error);
}

EditProductViewModel useEditProductViewModel({
  required FindProduct getProduct,
  required UpdateProduct updateProduct,
}) {
  final currentProduct = useState<Product>(const Product(
      id: 0,
      code: '',
      description: '',
      status: false,
      categoryId: 0,
      price: '',
      product: ''));
  final error = useState<String>('');

  void getProductFn(int id) async {
    var result = await getProduct.execute(id);
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Ocurrió un error al buscar el producto con id: $id';
      }
    }, (data) {
      currentProduct.value = data;
    });
  }

  void updateProductFn(
      {String? code,
      String? description,
      bool? status,
      int? categoryId,
      String? price,
      String? product}) async {
    var result = await updateProduct.execute(currentProduct.value.id!,
        code: code != currentProduct.value.code ? code : null,
        description: description != currentProduct.value.description
            ? description
            : null,
        status: status != currentProduct.value.status ? status : null,
        categoryId:
            categoryId != currentProduct.value.categoryId ? categoryId : null,
        price: price != currentProduct.value.price ? price : null,
        product: product != currentProduct.value.product ? product : null);
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Ocurrió un error al actualizar el producto';
      }
    }, (data) {});
  }

  return EditProductViewModel(
      getProduct: getProductFn,
      updateProduct: updateProductFn,
      data: currentProduct.value,
      error: error.value);
}
