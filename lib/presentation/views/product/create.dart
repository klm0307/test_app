import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_app/data/data.dart';
import 'package:test_app/domain/domain.dart';
import 'package:test_app/presentation/components/custom_snackbar.dart';
import 'package:test_app/presentation/components/product/form.dart';
import 'package:test_app/presentation/view_model/base_view_model.dart';
import 'package:test_app/presentation/view_model/product/create.dart';

class CreateProduct extends HookWidget {
  const CreateProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final viewModelProduct = useCreateProductViewModel(
      createProduct:
          CreateProductImpl(ProductRepositoryImpl(ProductDataSourceImpl())),
    );

    final codeController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final priceController = useTextEditingController();
    final productController = useTextEditingController();
    final isActive = useState(true);
    final categoryId = useState<int?>(null);

    void createProduct() {
      FocusScope.of(context).requestFocus(FocusNode());

      if (!formKey.currentState!.validate()) {
        CustomSnackbar.show(context,
            text: 'Formulario invalido', isSuccess: false);
      }
      if (formKey.currentState!.validate()) {
        viewModelProduct.createProduct(
            code: codeController.text,
            description: descriptionController.text,
            status: true,
            categoryId: categoryId.value ?? 0,
            price: priceController.text,
            product: productController.text);

        CustomSnackbar.show(context,
            text: 'Producto guardado', isSuccess: true);
        Navigator.pop(context);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Crear Producto'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: viewModelProduct.error.isNotEmpty
                ? buildError(viewModelProduct)
                : ProductForm(
                    formKey: formKey,
                    isEdit: false,
                    submitFn: createProduct,
                    productController: productController,
                    codeController: codeController,
                    descriptionController: descriptionController,
                    priceController: priceController,
                    categoryId: categoryId,
                    isActive: isActive),
          ),
        ));
  }
}
