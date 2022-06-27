import 'dart:convert';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:shamo/models/user_model.dart';

class AuthService {
  String baseUrl = 'http://shamo-api.rmhabibb.my.id/api';

  Future<UserModel> register({
    String name,
    String username,
    String email,
    String password,
  }) async {
    var url = '$baseUrl/register';
    var header = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    });

    var respone = await http.post(url, headers: header, body: body);

    if (respone.statusCode == 200) {
      var data = jsonDecode(respone.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.token = 'Beare ' + data['access_token'];
      return user;
    } else {
      throw Exception('Gagal Register');
    }
  }

  Future<UserModel> login({
    String email,
    String password,
  }) async {
    var url = '$baseUrl/login';
    var header = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    var respone = await http.post(url, headers: header, body: body);

    if (respone.statusCode == 200) {
      var data = jsonDecode(respone.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.token = 'Bearer ' + data['access_token'];
      return user;
    } else {
      throw Exception('Gagal Login');
    }
  }
}
