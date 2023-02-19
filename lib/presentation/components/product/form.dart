import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_app/data/data.dart';
import 'package:test_app/domain/domain.dart';
import 'package:test_app/presentation/view_model/base_view_model.dart';
import 'package:test_app/presentation/view_model/category/list.dart';

class ProductForm extends HookWidget {
  final GlobalKey<FormState> formKey;
  final bool isEdit;
  final Function submitFn;
  final TextEditingController productController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final ValueNotifier<int?> categoryId;
  final ValueNotifier<bool> isActive;
  final int? id;

  const ProductForm({
    super.key,
    required this.formKey,
    required this.isEdit,
    required this.submitFn,
    required this.productController,
    required this.codeController,
    required this.descriptionController,
    required this.priceController,
    required this.isActive,
    required this.categoryId,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final viewModelCategory = useCategoryListViewModel(
        findAllCategories: FindAllCategoriesImpl(
            CategoryRepositoryImpl(CategoryDataSourceImpl())));

    useEffect(() {
      viewModelCategory.getData();
      return () {};
    }, []);

    return viewModelCategory.error.isNotEmpty
        ? buildError(viewModelCategory)
        : Form(
            key: formKey,
            child: Column(
              children: [
                if (isEdit)
                  TextFormField(
                    initialValue: '$id',
                    enabled: false,
                  ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(hintText: 'Producto'),
                  controller: productController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(hintText: 'Código'),
                    controller: codeController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]'))
                    ]),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(hintText: 'Descripción'),
                    controller: descriptionController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]'))
                    ]),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Precio'),
                  inputFormatters: [CurrencyTextInputFormatter(symbol: '')],
                  controller: priceController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  value: categoryId.value,
                  items: viewModelCategory.data
                      .map((e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name),
                          ))
                      .toList(),
                  hint: const Text('Categorías'),
                  onChanged: (value) {
                    categoryId.value = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SwitchListTile(
                  title: const Text('Estado'),
                  onChanged: (bool value) {
                    isActive.value = value;
                  },
                  value: isActive.value,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    submitFn();
                  },
                  child: const SizedBox(
                      width: double.infinity,
                      child: Center(child: Text('Guardar'))),
                )
              ],
            ),
          );
  }
}
