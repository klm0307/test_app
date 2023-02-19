import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_app/data/data.dart';
import 'package:test_app/domain/domain.dart';
import 'package:test_app/presentation/components/custom_dismissible_background.dart';
import 'package:test_app/presentation/components/custom_snackbar.dart';
import 'package:test_app/presentation/view_model/base_view_model.dart';
import 'package:test_app/presentation/view_model/product/list.dart';

class ProductList extends HookWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModelProduct = useProductListViewModel(
        findAllProducts:
            FindAllProductsImpl(ProductRepositoryImpl(ProductDataSourceImpl())),
        deleteProductUseCase:
            DeleteProductImpl(ProductRepositoryImpl(ProductDataSourceImpl())));

    useEffect(() {
      viewModelProduct.getProducts();
      return () {};
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, 'create-product').then((value) {
            viewModelProduct.getProducts();
          });
        },
      ),
      body: viewModelProduct.error.isNotEmpty
          ? buildError(viewModelProduct)
          : RefreshIndicator(
              onRefresh: () {
                return viewModelProduct.getProducts();
              },
              child: ListView.builder(
                  itemCount: viewModelProduct.data.length,
                  itemBuilder: (context, index) {
                    final item = viewModelProduct.data[index];
                    return Dismissible(
                        key: Key(item.product),
                        background: CustomDismissibleBackground(
                          color: Colors.red.shade400,
                          icon: Icons.delete,
                          isLeft: false,
                          text: 'Eliminar',
                        ),
                        secondaryBackground: CustomDismissibleBackground(
                          color: Colors.amber.shade800,
                          icon: Icons.edit,
                          isLeft: true,
                          text: 'Editar',
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            final bool res = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Eliminar Producto'),
                                    content: Text(
                                      '¿Esta seguro que desea eliminar el producto ${item.description}?',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: const Text(
                                          'Cancelar',
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                      ),
                                      ElevatedButton(
                                        child: const Text(
                                          'Eliminar',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          if (item.id != null) {
                                            viewModelProduct
                                                .deleteProduct(item.id!);
                                            CustomSnackbar.show(context,
                                                text: 'Producto eliminado',
                                                isSuccess: true);
                                            Navigator.pop(context, true);
                                          }
                                          if (item.id == null) {
                                            Navigator.pop(context, false);
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                });
                            return res;
                          }

                          if (direction == DismissDirection.endToStart) {
                            Navigator.pushNamed(context, 'edit-product',
                                    arguments: item.id)
                                .then((value) {
                              viewModelProduct.getProducts();
                            });
                          }
                        },
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, 'detail-product',
                                    arguments: item.id)
                                .then((value) {
                              viewModelProduct.getProducts();
                            });
                          },
                          leading: const Icon(Icons.inventory_outlined),
                          title: Text(item.product),
                          subtitle: Text(item.description),
                        ));
                  }),
            ),
    );
  }
}
