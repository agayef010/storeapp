import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Məhsul Detalları'),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 300,
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.error, size: 64),
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Category
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text(
                        product.rating.rate.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '(${product.rating.count} rəy)',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Price
                  Text(
                    '₼${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Description
                  Text(
                    'Təsvir',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                  ),
                  
                                     SizedBox(height: 32),
                   
                   // Similar Products Section
                   Text(
                     'Maraqlandığınız məhsullar',
                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   SizedBox(height: 16),
                   Consumer<ProductProvider>(
                     builder: (context, productProvider, child) {
                       final similarProducts = productProvider.products
                           .where((p) => p.category == product.category && p.id != product.id)
                           .take(4)
                           .toList();
                       
                       if (similarProducts.isEmpty) {
                         return SizedBox.shrink();
                       }
                       
                       return Container(
                         height: 200,
                         child: ListView.builder(
                           scrollDirection: Axis.horizontal,
                           itemCount: similarProducts.length,
                           itemBuilder: (context, index) {
                             final similarProduct = similarProducts[index];
                             return Container(
                               width: 150,
                               margin: EdgeInsets.only(right: 12),
                               child: Card(
                                 child: InkWell(
                                   onTap: () {
                                     Navigator.pushReplacement(
                                       context,
                                       MaterialPageRoute(
                                         builder: (context) => ProductDetailPage(product: similarProduct),
                                       ),
                                     );
                                   },
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       ClipRRect(
                                         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                         child: CachedNetworkImage(
                                           imageUrl: similarProduct.image,
                                           height: 100,
                                           width: double.infinity,
                                           fit: BoxFit.cover,
                                           placeholder: (context, url) => Container(
                                             height: 100,
                                             color: Colors.grey[200],
                                             child: Center(child: CircularProgressIndicator()),
                                           ),
                                           errorWidget: (context, url, error) => Container(
                                             height: 100,
                                             color: Colors.grey[200],
                                             child: Icon(Icons.error),
                                           ),
                                         ),
                                       ),
                                       Padding(
                                         padding: EdgeInsets.all(8),
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                               similarProduct.title,
                                               maxLines: 2,
                                               overflow: TextOverflow.ellipsis,
                                               style: TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 12,
                                               ),
                                             ),
                                             SizedBox(height: 4),
                                             Text(
                                               '₼${similarProduct.price.toStringAsFixed(2)}',
                                               style: TextStyle(
                                                 color: Theme.of(context).primaryColor,
                                                 fontWeight: FontWeight.bold,
                                                                    ),
                   ),
                   
                   // Review Section
                   SizedBox(height: 24),
                   Text(
                     'Rəy bildirin',
                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   SizedBox(height: 16),
                                       _buildReviewSection(context),
                 ],
               ),
             ),
           ],
         ),
       ),
                               ),
                             );
                           },
                         ),
                       );
                     },
                   ),
                 ],
               ),
             ),
           ],
         ),
       ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, _) {
            final isInCart = cartProvider.isInCart(product.id);
            final quantity = cartProvider.getQuantity(product.id);
            
            return Row(
              children: [
                if (isInCart) ...[
                  IconButton(
                    onPressed: () {
                      cartProvider.updateQuantity(product.id, quantity - 1);
                    },
                    icon: Icon(Icons.remove),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    quantity.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      cartProvider.updateQuantity(product.id, quantity + 1);
                    },
                    icon: Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(width: 16),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (isInCart) {
                        cartProvider.removeItem(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Məhsul səbətdən çıxarıldı'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        cartProvider.addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Məhsul səbətə əlavə edildi'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInCart ? Colors.red : Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isInCart ? 'Səbətdən çıxar' : 'Səbətə əlavə et',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildReviewSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text(
                  'Qiymətləndirin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    // Rating logic would go here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Rəyiniz üçün təşəkkür edirik!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 30,
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Rəyinizi yazın...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Rəyiniz göndərildi!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text('Rəy göndər'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 