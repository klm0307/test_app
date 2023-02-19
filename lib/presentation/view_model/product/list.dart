import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/model/product.dart';
import 'package:test_app/domain/use_cases/product/delete_product.dart';
import 'package:test_app/domain/use_cases/product/find_all_products.dart';
import 'package:test_app/presentation/view_model/base_view_model.dart';

class ProductListViewModel extends BaseViewModel {
  List<Product> data;

  Function getProducts;
  Function(int id) deleteProduct;
  ProductListViewModel(
      {required this.data,
      required this.getProducts,
      required String error,
      required this.deleteProduct})
      : super(error: error);
}

ProductListViewModel useProductListViewModel({
  required FindAllProducts findAllProducts,
  required DeleteProduct deleteProductUseCase,
}) {
  final products = useState<List<Product>>([]);
  final error = useState<String>("");

  void getProductsFn() async {
    var result = await findAllProducts.execute();
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Ocurrió un error al buscar los productos';
      }
    }, (data) {
      products.value = data;
    });
  }

  void deleteProductFn(int id) async {
    error.value = "";
    var result = await deleteProductUseCase.execute(id);
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Ocurrió un error al borrar el producto';
      }
    }, (data) {
      // customer.value = data;
    });
  }

  return ProductListViewModel(
      data: products.value,
      error: error.value,
      getProducts: getProductsFn,
      deleteProduct: deleteProductFn);
}
