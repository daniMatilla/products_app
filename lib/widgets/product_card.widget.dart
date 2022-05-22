import 'package:flutter/material.dart';
import 'package:products_app/ui/ui.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import 'widgets.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(bottom: 16),
        width: double.infinity,
        decoration: _decoration(),
        child: Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: [
            ImageWidget(url: product.picture),
            _Information(product: product),
            LayoutBuilder(builder: (_, constrains) {
              return Icon(
                !product.available ? Icons.not_interested_rounded : null,
                color: Colors.white.withOpacity(.3),
                size: constrains.maxHeight,
              );
            }),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                padding: const EdgeInsets.all(16),
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await productProvider.working(
                    Future.delayed(
                      const Duration(seconds: 1),
                      () => productProvider.deleteProduct(product),
                    ),
                  );

                  Ui.snackBar(context: context, message: 'Producto borrado');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 5),
          blurRadius: 5,
        ),
      ],
    );
  }
}

class _Information extends StatelessWidget {
  const _Information({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(130, 53, 97, 93),
            Color.fromARGB(40, 53, 97, 93),
            Color.fromARGB(130, 53, 97, 93),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, .5, 1],
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${product.price}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    product.id!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
