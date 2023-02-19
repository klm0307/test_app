import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_app/data/data.dart';
import 'package:test_app/domain/domain.dart';
import 'package:test_app/presentation/view_model/base_view_model.dart';
import 'package:test_app/presentation/view_model/product/detail.dart';

class DetailProduct extends HookWidget {
  const DetailProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int?;

    final viewModelProduct = useProductDetailViewModel(
        findProduct:
            FindProductImpl(ProductRepositoryImpl(ProductDataSourceImpl())));

    useEffect(() {
      viewModelProduct.getProduct(id!);
      return () {};
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle Producto'),
      ),
      body: viewModelProduct.error.isNotEmpty
          ? buildError(viewModelProduct)
          : SingleChildScrollView(
              child: Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          viewModelProduct.data.product,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Descripción:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'Código:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'Precio:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'Categoría:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'Estado:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(viewModelProduct.data.description),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    viewModelProduct.data.code,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(viewModelProduct.data.price),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text('${viewModelProduct.data.categoryId}'),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(viewModelProduct.data.status
                                      ? 'activo'
                                      : 'inactivo')
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
