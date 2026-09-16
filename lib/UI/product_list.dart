import 'package:flutter/material.dart';
import 'package:product_app/API/api.dart';
import 'package:product_app/UI/product_detail.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ScrollController _scrollController = ScrollController();

  final List<dynamic> _products = [];

  static const int _limit = 20;

  int _skip = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _loadProducts();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadProducts();
    }
  }

  Future<void> _loadProducts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final newProducts = await getProducts(limit: _limit, skip: _skip);
      setState(() {
        _products.addAll(newProducts);

        _skip += newProducts.length;

        if (newProducts.length < _limit) {
          _hasMore = false;
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Product List')),
      body: (_hasError && _products.isEmpty)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Unable to load products',
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: _loadProducts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _products.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Loading indicator
                if (index == _products.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final product = _products[index];

                return ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Image.network(
                    product['thumbnail'],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    product['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '\$${product['price']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetail(productId: product['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
