import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user != null) {
      _nameController.text = userProvider.user!.name;
      _emailController.text = userProvider.user!.email;
      _phoneController.text = userProvider.user!.phone ?? '';
      _addressController.text = userProvider.user!.address ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              if (userProvider.isLoggedIn) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      setState(() {
                        _isEditing = true;
                      });
                    } else if (value == 'logout') {
                      _showLogoutDialog(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Redaktə et'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Çıxış'),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!userProvider.isLoggedIn) {
            return _buildLoginForm();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Header
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: userProvider.user!.avatarUrl != null
                                ? CachedNetworkImageProvider(userProvider.user!.avatarUrl!)
                                : null,
                            child: userProvider.user!.avatarUrl == null
                                ? Icon(Icons.person, size: 50, color: Colors.white)
                                : null,
                          ),
                          SizedBox(height: 16),
                          Text(
                            userProvider.user!.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            userProvider.user!.email,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Profile Information
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Şəxsi məlumatlar',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!_isEditing)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = true;
                                    });
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                            ],
                          ),
                          SizedBox(height: 16),
                          
                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Ad Soyad',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            enabled: _isEditing,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ad və soyad daxil edin';
                              }
                              return null;
                            },
                          ),
                          
                          SizedBox(height: 16),
                          
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                            enabled: false, // Email cannot be changed
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          
                          SizedBox(height: 16),
                          
                          // Phone Field
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Telefon nömrəsi',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                            ),
                            enabled: _isEditing,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Telefon nömrəsi daxil edin';
                              }
                              return null;
                            },
                          ),
                          
                          SizedBox(height: 16),
                          
                          // Address Field
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Ünvan',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            enabled: _isEditing,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ünvan daxil edin';
                              }
                              return null;
                            },
                          ),
                          
                          if (_isEditing) ...[
                            SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = false;
                                        _loadUserData(); // Reset to original values
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: Text('Ləğv et'),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _saveProfile(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: Text('Yadda saxla'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Cart Summary
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Səbət məlumatları',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Məhsul sayı:'),
                                  Text(
                                    '${cartProvider.itemCount}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Cəmi məbləğ:'),
                                  Text(
                                    '₼${cartProvider.totalAmount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              if (cartProvider.itemCount > 0) ...[
                                SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/cart');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text('Səbətə bax'),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                                     ),
                   
                   SizedBox(height: 24),
                   
                   // My Orders Section
                   Card(
                     child: Padding(
                       padding: EdgeInsets.all(16),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             'Sifarişlərim',
                             style: Theme.of(context).textTheme.titleLarge?.copyWith(
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           SizedBox(height: 16),
                           _buildOrdersList(),
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           );
         },
       ),
     );
   }

  Widget _buildLoginForm() {
    final loginFormKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24),
            Text(
              'Giriş edin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32),
            
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email daxil edin';
                }
                return null;
              },
            ),
            
            SizedBox(height: 16),
            
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Şifrə',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Şifrə daxil edin';
                }
                return null;
              },
            ),
            
            SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return ElevatedButton(
                    onPressed: userProvider.isLoading
                        ? null
                        : () async {
                            if (loginFormKey.currentState!.validate()) {
                              final success = await userProvider.login(
                                emailController.text,
                                passwordController.text,
                              );
                              if (!success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(userProvider.error),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: userProvider.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Giriş et',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
            ),
            
            SizedBox(height: 16),
            
            Text(
              'Test üçün: test@example.com / password',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateProfile(
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
      );
      
      setState(() {
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil yeniləndi'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Çıxış'),
        content: Text('Həqiqətən çıxmaq istəyirsiniz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Xeyr'),
          ),
          ElevatedButton(
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.logout();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Bəli'),
          ),
        ],
      ),
    );
  }
  
    Widget _buildOrdersList() {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (orderProvider.orders.isEmpty) {
          return Center(
            child: Column(
              children: [
                Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'Hələ sifarişiniz yoxdur',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }
        
        return Column(
          children: orderProvider.orders.map((order) => Card(
            margin: EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.id,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: order.status == 'Çatdırılır' 
                              ? Colors.orange.withValues(alpha: 0.2)
                              : Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(
                            color: order.status == 'Çatdırılır' 
                                ? Colors.orange[800]
                                : Colors.green[800],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tarix: ${_formatDate(order.date)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  if (order.status == 'Çatdırılır') ...[
                    SizedBox(height: 4),
                    Text(
                      'Çatdırılma: ${_formatDate(order.deliveryDate)} (${_calculateDaysRemaining(order.deliveryDate)} gün qalıb)',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  SizedBox(height: 8),
                  Text(
                    'Məhsullar: ${order.items.map((item) => item.product.title).join(', ')}',
                    style: TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cəmi:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₼${order.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )).toList(),
        );
      },
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
  
  int _calculateDaysRemaining(DateTime deliveryDate) {
    final now = DateTime.now();
    final difference = deliveryDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }
  

} 