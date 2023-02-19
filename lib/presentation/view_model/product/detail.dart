import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_app/core/error/failure.dart';
import 'package:test_app/domain/domain.dart';
import 'package:test_app/presentation/view_model/base_view_model.dart';

class ProductDetailViewModel extends BaseViewModel {
  Product data;
  Function(int id) getProduct;

  ProductDetailViewModel({
    required this.data,
    required this.getProduct,
    required String error,
  }) : super(error: error);
}

ProductDetailViewModel useProductDetailViewModel({
  required FindProduct findProduct,
}) {
  final product = useState<Product>(const Product(
      description: '',
      code: '',
      status: false,
      categoryId: 0,
      price: '',
      product: ''));
  final error = useState<String>("");

  void getProductFn(int id) async {
    error.value = "";
    var result = await findProduct.execute(id);
    result.fold((failure) {
      if (failure == ServerFailure()) {
        error.value = 'Ocurrió un error al buscar el producto con id: $id';
      }
    }, (data) {
      product.value = data;
    });
  }

  return ProductDetailViewModel(
    data: product.value,
    getProduct: getProductFn,
    error: error.value,
  );
}
