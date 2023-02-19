import 'package:flutter/material.dart';
import 'package:test_app/core/models/menu_options.dart';
import 'package:test_app/presentation/views/product/create.dart';
import 'package:test_app/presentation/views/product/detail.dart';
import 'package:test_app/presentation/views/product/edit.dart';
import 'package:test_app/presentation/views/product/list.dart';

class AppRoutes {
  static const initialRoute = 'home';

  static final menuOptions = <MenuOption>[
    MenuOption(
        icon: Icons.abc,
        name: 'Crear Producto',
        route: 'create-product',
        screen: const CreateProduct()),
    MenuOption(
        route: 'edit-product',
        icon: Icons.abc,
        name: 'Editar Producto',
        screen: const EditProduct()),
    MenuOption(
        route: 'detail-product',
        icon: Icons.abc,
        name: 'Detalle Producto',
        screen: const DetailProduct())
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll({'home': (BuildContext context) => const ProductList()});

    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
            child: Column(
          children: [
            const Text('Pagina no encontrada'),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'home');
                },
                child: const Text('Volver a inicio'))
          ],
        )),
      ),
    );
  }
}
