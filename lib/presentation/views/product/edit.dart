import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_app/data/data.dart';
import 'package:test_app/domain/domain.dart';
import 'package:test_app/presentation/components/custom_snackbar.dart';
import 'package:test_app/presentation/components/product/form.dart';
import 'package:test_app/presentation/view_model/base_view_model.dart';
import 'package:test_app/presentation/view_model/product/edit.dart';

class EditProduct extends HookWidget {
  const EditProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int?;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final viewModelProduct = useEditProductViewModel(
        updateProduct:
            UpdateProductImpl(ProductRepositoryImpl(ProductDataSourceImpl())),
        getProduct:
            FindProductImpl(ProductRepositoryImpl(ProductDataSourceImpl())));

    final codeController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final priceController = useTextEditingController();
    final productController = useTextEditingController();
    final isActive = useState(false);
    final categoryId = useState<int?>(null);

    useEffect(() {
      viewModelProduct.getProduct(id!);
      return () {};
    }, []);

    useEffect(() {
      codeController.text = viewModelProduct.data.code;
      descriptionController.text = viewModelProduct.data.description;
      priceController.text = viewModelProduct.data.price;
      productController.text = viewModelProduct.data.product;
      categoryId.value = viewModelProduct.data.categoryId;
      isActive.value = viewModelProduct.data.status;
      return () {};
    }, [viewModelProduct.data.id]);

    void updateProduct() {
      FocusScope.of(context).requestFocus(FocusNode());
      if (!formKey.currentState!.validate()) {
        CustomSnackbar.show(context,
            text: 'Formulario invalido', isSuccess: false);
      }
      if (formKey.currentState!.validate()) {
        viewModelProduct.updateProduct(
            code: codeController.text,
            description: descriptionController.text,
            status: isActive.value,
            categoryId: categoryId.value ?? 0,
            price: priceController.text,
            product: productController.text);

        CustomSnackbar.show(context,
            text: 'Producto actualizado', isSuccess: true);
        Navigator.pop(context, false);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: viewModelProduct.error.isNotEmpty
                ? buildError(viewModelProduct)
                : ProductForm(
                    formKey: formKey,
                    isEdit: true,
                    submitFn: updateProduct,
                    productController: productController,
                    codeController: codeController,
                    descriptionController: descriptionController,
                    priceController: priceController,
                    categoryId: categoryId,
                    isActive: isActive,
                    id: id,
                  )),
      ),
    );
  }
}
