import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';
import 'services.dart';

class ProductsService implements BaseService<Product> {
  final String _baseUrl =
      'flutter-varios-6557c-default-rtdb.europe-west1.firebasedatabase.app';
  late StorageService _storageService;

  ProductsService() {
    _storageService = StorageService();
  }

  @override
  Future<List<Product>> getAll() async {
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url);
    var dataDecoded = json.decode(resp.body);
    if (dataDecoded == null) return [];

    final Map<String, dynamic> productMap = dataDecoded;
    return [
      ...productMap.entries.map((e) {
        final p = Product.fromMap(e.value);
        p.id = e.key;
        return p;
      }).toList()
    ];
  }

  @override
  Future<Product> getById(String id) async {
    final url = Uri.https(_baseUrl, 'products/$id.json');
    final resp = await http.get(url);
    return Product.fromJson(resp.body);
  }

  @override
  Future<Product?> update(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    var resp = await http.put(url, body: product.toJson());
    if (resp.statusCode == 200) {
      return product;
    }
    return null;
  }

  @override
  Future<Product?> create(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toJson());
    if (resp.statusCode == 200) {
      product.id = json.decode(resp.body)['name'];
      return product;
    }
    return null;
  }

  @override
  Future<bool> delete(String id) async {
    final url = Uri.https(_baseUrl, 'products/$id.json');
    final resp = await http.delete(url, body: id);
    return resp.statusCode == 200;
  }
}
