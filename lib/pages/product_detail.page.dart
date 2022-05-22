import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../ui/ui.dart';
import '../widgets/widgets.dart';

class ProducDetailPage extends StatelessWidget {
  const ProducDetailPage({Key? key}) : super(key: key);

  static String get routeName => '$ProducDetailPage';

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final product = productProvider.productSelected;
    final isEditing = product.id != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0,
        child: FloatingActionButton(
          onPressed: productProvider.isBusy
              ? null
              : () async {
                  if (!productProvider.isValid()) return;

                  await productProvider.working(
                    Future.delayed(
                      const Duration(seconds: 1),
                      () => productProvider.createOrUpdateProduct(product),
                    ),
                  );

                  Ui.snackBar(
                    context: context,
                    message: isEditing ? 'Producto editado' : 'Producto creado',
                  );
                },
          child: Icon(isEditing ? Icons.save_alt_rounded : Icons.add),
          backgroundColor:
              productProvider.isBusy ? Colors.grey[300] : Colors.teal,
          elevation: productProvider.isBusy ? 0 : 5,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Header(image: product.picture),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 5),
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: const _Form(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key, this.image}) : super(key: key);

  final String? image;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: ImageWidget(url: image),
              ),
              Container(
                width: double.infinity,
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
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              onPressed: () {
                productProvider.takeProductImage();
              },
              iconSize: 35,
              icon: const Icon(
                Icons.add_a_photo_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final productProvider = Provider.of<ProductsProvider>(context);
    final product = productProvider.productSelected;

    return Form(
      key: productProvider.key,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              keyboardType: TextInputType.text,
              initialValue: product.name,
              onChanged: (value) {
                product.name = value;
              },
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Campo obligatorio';
                return null;
              },
              decoration: Ui.inputDecoration(
                labelText: 'name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * .5,
                  child: TextFormField(
                    textAlign: TextAlign.end,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autocorrect: false,
                    inputFormatters: [
                      FilteringTextInputFormatter(
                        RegExp(r'^\d+\.?\d{0,2}'),
                        allow: true,
                      )
                    ],
                    keyboardType: TextInputType.number,
                    initialValue: '${product.price}',
                    onChanged: (value) {
                      var price = double.tryParse(value);
                      product.price = price ?? 0;
                    },
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Campo obligatorio';
                      return null;
                    },
                    decoration: Ui.inputDecoration(
                      labelText: 'price',
                      suffixText: '€',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16),
                  width: size.width * .4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Disponible:'),
                      Switch(
                        activeColor: Colors.teal,
                        onChanged: productProvider.updateAviability,
                        value: product.available,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
