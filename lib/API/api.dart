import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> getProducts({int limit = 20, int skip = 0}) async {
  final url = Uri.parse('https://dummyjson.com/products').replace(
    queryParameters: {'limit': limit.toString(), 'skip': skip.toString()},
  );

  try {
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['products'];
    }

    throw Exception('Failed to load products');
  } catch (e) {
    throw Exception('Connection timeout or network error');
  }
}

Future<Map<String, dynamic>> getProductDetail(int productId) async {
  final url = Uri.parse('https://dummyjson.com/products/$productId');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception('Failed to load product detail');
}
