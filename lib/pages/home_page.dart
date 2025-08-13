import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                  if (cartProvider.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartProvider.itemCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
                           body: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Məhsul axtar...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
          
                     // Category Filter
           FutureBuilder<List<Product>>(
             future: Provider.of<ProductProvider>(context, listen: false).products.isEmpty 
                 ? Provider.of<ProductProvider>(context, listen: false).loadProducts().then((_) => Provider.of<ProductProvider>(context, listen: false).products)
                 : Future.value(Provider.of<ProductProvider>(context, listen: false).products),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }
              
              final products = snapshot.data!;
              final categories = products.map((product) => product.category).toSet().toList();
              categories.sort();
              
                             return Container(
                 height: 50,
                 child: ListView.builder(
                   scrollDirection: Axis.horizontal,
                   padding: EdgeInsets.symmetric(horizontal: 16),
                   itemCount: categories.length + 1,
                   itemBuilder: (context, index) {
                     final category = index == 0 ? '' : categories[index - 1];
                     final isSelected = _selectedCategory == category;
                     
                     return Padding(
                       padding: EdgeInsets.only(right: 8),
                       child: FilterChip(
                         label: Text(index == 0 ? 'Hamısı' : category),
                         selected: isSelected,
                         onSelected: (selected) {
                           setState(() {
                             _selectedCategory = selected ? category : '';
                           });
                         },
                         backgroundColor: Colors.grey[200],
                         selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                         labelStyle: TextStyle(
                           color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                         ),
                       ),
                     );
                   },
                 ),
               );
            },
          ),
          
          SizedBox(height: 16),
          
                     // Products Grid
           Expanded(
             child: FutureBuilder<List<Product>>(
               future: Provider.of<ProductProvider>(context, listen: false).products.isEmpty 
                   ? Provider.of<ProductProvider>(context, listen: false).loadProducts().then((_) => Provider.of<ProductProvider>(context, listen: false).products)
                   : Future.value(Provider.of<ProductProvider>(context, listen: false).products),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Məhsullar yüklənərkən xəta baş verdi',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text('Yenidən cəhd et'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Məhsul tapılmadı',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                final products = snapshot.data!;
                var filteredProducts = products;
                
                // Apply category filter
                if (_selectedCategory.isNotEmpty) {
                  filteredProducts = filteredProducts.where((product) => product.category == _selectedCategory).toList();
                }
                
                // Apply search filter
                if (_searchController.text.isNotEmpty) {
                  filteredProducts = filteredProducts.where((product) =>
                      product.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                      product.description.toLowerCase().contains(_searchController.text.toLowerCase())
                  ).toList();
                }
                
                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(product: product),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
                     ),
         ],
       ),
    );
  }
} 