import 'dart:convert';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:shamo/models/cart_model.dart';

class TransactionService {
  String baseUrl = 'http://shamo-api.rmhabibb.my.id/api';

  Future<bool> checkout(
      String token, List<CartModel> carts, double totalPrice) async {
    var url = '$baseUrl/checkout';
    var header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode(
      {
        'address': 'Indonesia',
        'items': carts
            .map(
              (cart) => {
                'id': cart.product.id,
                'quantity': cart.quantity,
              },
            )
            .toList(),
        'status': "PENDING",
        'total_price': totalPrice,
        'shipping_price': 0,
      },
    );

    var respone = await http.post(
      url,
      headers: header,
      body: body,
    );

    if (respone.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal Checkout!!');
    }
  }
}
