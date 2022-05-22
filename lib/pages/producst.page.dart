import 'package:flutter/material.dart';
import 'package:products_app/models/product.model.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';
import 'pages.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  static String get routeName => '$ProductsPage';

  @override
  Widget build(BuildContext context) {
    final _producsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            onPressed: () {
              final newProduct =
                  Product(available: true, name: '', price: 0.00);
              _producsProvider.productSelected = newProduct;
              Navigator.pushNamed(context, ProducDetailPage.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
          child: Stack(
            children: [
              if (_producsProvider.products.isEmpty)
                const Center(
                  child: Text('Nada por aquí'),
                ),
              ListView.builder(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                itemCount: _producsProvider.products.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProducDetailPage.routeName);
                    _producsProvider.productSelected =
                        _producsProvider.products[index].copy();
                  },
                  child: ProductCard(
                    product: _producsProvider.products[index],
                  ),
                ),
              ),
            ],
          ),
          onRefresh: () {
            return Future.delayed(
              const Duration(seconds: 1),
              () {
                _producsProvider.getProducts();
              },
            );
          }),
    );
  }
}
