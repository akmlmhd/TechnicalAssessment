import 'dart:async';

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

  List<dynamic> _products = [];

  static const int _limit = 20;

  int _skip = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

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

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isEmpty) {
        _resetProducts();
      } else {
        _searchProducts(value.trim());
      }
    });
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

  Future<void> _searchProducts(String keyword) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final results = await searchProducts(keyword);

      setState(() {
        _products = results;
        _hasMore = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetProducts() async {
    setState(() {
      _products.clear();
      _skip = 0;
      _hasMore = true;
    });

    await _loadProducts();
  }

  Future<void> _refreshProducts() async {
    if (_searchController.text.trim().isNotEmpty) {
      await _searchProducts(_searchController.text.trim());
      return;
    }
    await _resetProducts();
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _resetProducts();
                                _loadProducts();
                                setState(() {});
                              },
                            )
                          : null,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshProducts,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];

                        return ListTile(
                          leading: Image.network(
                            product['thumbnail'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }

                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },

                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                          title: Text(product['title']),
                          subtitle: Text('\$${product['price']}'),
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
                  ),
                ),
              ],
            ),
    );
  }
}
