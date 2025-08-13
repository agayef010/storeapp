import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'providers/order_provider.dart';
import 'pages/home_page.dart';
import 'pages/cart_page.dart';
import 'pages/profile_page.dart';

void main() {
  
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
             providers: [
         ChangeNotifierProvider(create: (_) => ProductProvider()),
         ChangeNotifierProvider(create: (_) => CartProvider()),
         ChangeNotifierProvider(create: (_) => UserProvider()),
         ChangeNotifierProvider(create: (_) => OrderProvider()),
       ],
             child: MaterialApp(
         title: 'Market',
         debugShowCheckedModeBanner: false,
                 theme: ThemeData(
           primarySwatch: Colors.purple,
           primaryColor: Colors.purple,
           colorScheme: ColorScheme.fromSeed(
             seedColor: Colors.purple,
             brightness: Brightness.light,
           ),
           useMaterial3: true,
           appBarTheme: AppBarTheme(
             backgroundColor: Colors.purple,
             foregroundColor: Colors.white,
             elevation: 0,
           ),
           elevatedButtonTheme: ElevatedButtonThemeData(
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.purple,
               foregroundColor: Colors.white,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
               ),
             ),
           ),
                                               cardTheme: CardThemeData(
             elevation: 2,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(12),
             ),
           ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MainScreen(),
          '/cart': (context) => CartPage(),
          '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    HomePage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Səhifə',
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    if (cartProvider.itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
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
            label: 'Səbət',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
