import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getProducts({
  int limit = 20,
  int skip = 0,
}) async {
  final url = Uri.parse(
    'https://dummyjson.com/products',
  ).replace(
    queryParameters: {
      'limit': limit.toString(),
      'skip': skip.toString(),
    },
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return data['products'];
  }

  throw Exception('Failed to load products');
}