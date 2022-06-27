import 'dart:convert';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:shamo/models/product_model.dart';

class ProductService {
  String baseUrl = 'http://shamo-api.rmhabibb.my.id/api';

  Future<List<ProductModel>> getProducts() async {
    var url = '$baseUrl/products';

    var headers = {'Content-Type': 'application/json'};

    var respone = await http.get(url, headers: headers);
    if (respone.statusCode == 200) {
      List data = jsonDecode(respone.body)['data']['data'];

      List<ProductModel> products = [];

      for (var item in data) {
        products.add(ProductModel.fromJson(item));
      }

      return products;
    } else {
      throw Exception('Gagal mengambil data product');
    }
  }
}
