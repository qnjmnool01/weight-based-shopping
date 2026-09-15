import 'package:flutter/material.dart';

void main() {
  runApp(const WeightBasedApp());
}

class WeightBasedApp extends StatelessWidget {
  const WeightBasedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weight-Based Shopping',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(),
    );
  }
}

// =====================================================
// PRODUCT MODEL
// =====================================================

class Product {
  final String name;
  final double pricePerKg;
  final double weight;
  final IconData icon;

  Product({
    required this.name,
    required this.pricePerKg,
    required this.weight,
    required this.icon,
  });
}

// =====================================================
// MAIN SCREEN
// =====================================================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Product> products = [
    Product(
      name: 'Rice',
      pricePerKg: 80,
      weight: 0.300,
      icon: Icons.grain,
    ),
    Product(
      name: 'Pasta',
      pricePerKg: 70,
      weight: 0.252,
      icon: Icons.lunch_dining,
    ),
    Product(
      name: 'Coffee Beans',
      pricePerKg: 450,
      weight: 0.200,
      icon: Icons.coffee,
    ),
    Product(
      name: 'Oats',
      pricePerKg: 90,
      weight: 0.250,
      icon: Icons.breakfast_dining,
    ),
    Product(
      name: 'Sugar',
      pricePerKg: 60,
      weight: 0.300,
      icon: Icons.icecream,
    ),
    Product(
      name: 'Chickpeas',
      pricePerKg: 120,
      weight: 0.200,
      icon: Icons.circle,
    ),
  ];

  final List<Product> selectedProducts = [];

  double get totalWeight {
    double total = 0;

    for (var product in selectedProducts) {
      total += product.weight;
    }

    return total;
  }

  double get totalAmount {
    double total = 0;

    for (var product in selectedProducts) {
      total += product.weight * product.pricePerKg;
    }

    return total;
  }

  void addProduct(Product product) {
    setState(() {
      selectedProducts.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void removeProduct(Product product) {
    setState(() {
      selectedProducts.remove(product);
    });
  }

  void goToCheckout() {
    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a product first.'),
        ),
      );
      return;
    }

    setState(() {
      currentIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        totalWeight: totalWeight,
        onStartShopping: () {
          setState(() {
            currentIndex = 1;
          });
        },
      ),

      ProductSelectionScreen(
        products: products,
        selectedProducts: selectedProducts,
        onAddProduct: addProduct,
        onRemoveProduct: removeProduct,
        totalWeight: totalWeight,
      ),

      CheckoutScreen(
        selectedProducts: selectedProducts,
        totalWeight: totalWeight,
        totalAmount: totalAmount,
        onRemoveProduct: removeProduct,
        onCheckout: () {
          setState(() {
            currentIndex = 3;
          });
        },
      ),

      ReceiptScreen(
        selectedProducts: selectedProducts,
        totalWeight: totalWeight,
        totalAmount: totalAmount,
        onNewPurchase: () {
          setState(() {
            selectedProducts.clear();
            currentIndex = 0;
          });
        },
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: screens[currentIndex],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex > 3 ? 0 : currentIndex,
        onDestinationSelected: (index) {
          if (index <= 2) {
            setState(() {
              currentIndex = index;
            });
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Receipt',
          ),
        ],
      ),
    );
  }
}

// =====================================================
// HOME SCREEN
// =====================================================

class HomeScreen extends StatelessWidget {
  final double totalWeight;
  final VoidCallback onStartShopping;

  const HomeScreen({
    super.key,
    required this.totalWeight,
    required this.onStartShopping,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Top bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.menu),
              Icon(Icons.notifications_none),
            ],
          ),

          const SizedBox(height: 35),

          const Text(
            'Welcome! 👋',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Weight-Based\nShopping System',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Select products, fill your container\nby weight, and pay.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          // Container illustration
          Container(
            width: double.infinity,
            height: 230,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _containerIcon(Icons.grain),
                    _containerIcon(Icons.coffee),
                    _containerIcon(Icons.breakfast_dining),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${totalWeight.toStringAsFixed(3)} kg',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Start shopping button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: onStartShopping,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Shopping  →',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Information card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.scale,
                  color: Colors.green,
                  size: 30,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your products are priced according to their weight.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 55,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 35,
        color: Colors.brown,
      ),
    );
  }
}

// =====================================================
// PRODUCT SELECTION
// =====================================================

class ProductSelectionScreen extends StatelessWidget {
  final List<Product> products;
  final List<Product> selectedProducts;
  final Function(Product) onAddProduct;
  final Function(Product) onRemoveProduct;
  final double totalWeight;

  const ProductSelectionScreen({
    super.key,
    required this.products,
    required this.selectedProducts,
    required this.onAddProduct,
    required this.onRemoveProduct,
    required this.totalWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  'Select Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Badge(
                label: Text('${selectedProducts.length}'),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                ),
              ),
            ],
          ),
        ),

        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Product list
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            product.icon,
                            size: 55,
                            color: Colors.brown,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        '₱${product.pricePerKg.toStringAsFixed(2)} / kg',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            onAddProduct(product);
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// =====================================================
// CHECKOUT SCREEN
// =====================================================

class CheckoutScreen extends StatelessWidget {
  final List<Product> selectedProducts;
  final double totalWeight;
  final double totalAmount;
  final Function(Product) onRemoveProduct;
  final VoidCallback onCheckout;

  const CheckoutScreen({
    super.key,
    required this.selectedProducts,
    required this.totalWeight,
    required this.totalAmount,
    required this.onRemoveProduct,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: const [
              Icon(Icons.arrow_back),
              SizedBox(width: 15),
              Text(
                'Checkout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [

              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: selectedProducts.map((product) {

                      final price =
                          product.weight * product.pricePerKg;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade50,
                          child: Icon(
                            product.icon,
                            color: Colors.green,
                          ),
                        ),
                        title: Text(product.name),
                        subtitle: Text(
                          '${product.weight.toStringAsFixed(3)} kg',
                        ),
                        trailing: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              '₱${price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                onRemoveProduct(product);
                              },
                              child: const Text(
                                'Remove',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Weight'),
                          Text(
                            '${totalWeight.toStringAsFixed(3)} kg',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const Divider(height: 25),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₱${totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Simulated weight display
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.scale,
                      size: 40,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Current Measured Weight',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${totalWeight.toStringAsFixed(3)} kg',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: selectedProducts.isEmpty
                      ? null
                      : onCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Generate Receipt',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================
// RECEIPT SCREEN
// =====================================================

class ReceiptScreen extends StatelessWidget {
  final List<Product> selectedProducts;
  final double totalWeight;
  final double totalAmount;
  final VoidCallback onNewPurchase;

  const ReceiptScreen({
    super.key,
    required this.selectedProducts,
    required this.totalWeight,
    required this.totalAmount,
    required this.onNewPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [

          const SizedBox(height: 20),

          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 45,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Thank you!',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),

          const Text(
            'Your purchase is complete.',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 25),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  const Text(
                    'RECEIPT',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Divider(height: 30),

                  ...selectedProducts.map((product) {

                    final price =
                        product.weight * product.pricePerKg;

                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 7),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${product.name}\n'
                              '${product.weight.toStringAsFixed(3)} kg',
                            ),
                          ),
                          Text(
                            '₱${price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const Divider(height: 30),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Weight'),
                      Text(
                        '${totalWeight.toStringAsFixed(3)} kg',
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₱${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // QR placeholder
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.qr_code_2,
                size: 130,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Receipt QR Code',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton(
              onPressed: onNewPurchase,
              child: const Text(
                'New Purchase',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}