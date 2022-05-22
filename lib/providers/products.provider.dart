import 'package:firebase_storage/firebase_storage.dart';

import '../models/models.dart';
import '../services/services.dart';
import 'form.provider.dart';

class ProductsProvider extends FormProvider {
  late ProductsService _productService;
  late StorageService _storageService;

  ProductsProvider() {
    _productService = ProductsService();
    _storageService = StorageService();

    getProducts();
  }

  List<Product> products = [];
  late Product productSelected;

  updateAviability(bool value) {
    productSelected.available = value;
    notifyListeners();
  }

  takeProductImage() {
    _storageService.takePhoto(
      onProgress: (progress) => print(progress),
      onSucces: (url) {
        productSelected.picture = url;
        notifyListeners();
      },
    );
  }

  createOrUpdateProduct(Product product) async {
    if (product.id != null) {
      final updateProduct = await _productService.update(product);
      var index = products.indexWhere((element) => element.id == product.id);
      if (updateProduct != null) {
        products[index] = updateProduct;
      }
    } else {
      final newProduct = await _productService.create(product);
      if (newProduct != null) {
        products.insert(0, product);
      }
    }
  }

  getProducts() async {
    products = await _productService.getAll();
    notifyListeners();
  }

  Future<bool> deleteImageStorage(String image) async {
    return await _storageService.deletePhoto(image);
  }

  Future deleteProductFirestore(Product product) async {
    bool productDeleted = await _productService.delete(product.id!);
    if (productDeleted) {
      products.removeWhere((element) => element.id == product.id);
    }
  }

  deleteProduct(Product product) async {
    if (product.picture != null) {
      final deleted = await deleteImageStorage(product.picture!);
      if (deleted) {
        await deleteProductFirestore(product);
      }
    } else {
      await deleteProductFirestore(product);
    }
  }
}
