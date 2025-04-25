import 'package:fluffyn/screens/add_product_page.dart';
import 'package:fluffyn/screens/user_profile_screen.dart';
import 'package:fluffyn/wigdets/product_card.dart'; // Fixed typo in original: wigdets -> widgets
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluffyn/controllers/product_contoller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart'; // Added for consistency with profile page

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductController productController = Get.put(ProductController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Our Products",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => UserProfileScreen());
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 86, 86, 0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/user-svgrepo-com.svg',
                height: 24,
                width: 24,
                color: Color.fromRGBO(255, 86, 86, 0.8),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Design - matching the profile page
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 230, 242, 255),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Obx(() {
            if (productController.productList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(255, 86, 86, 0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Loading products...",
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  await productController.fetchProductList();
                },
                color: Color.fromRGBO(255, 86, 86, 0.8),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: productController.productList.length,
                    itemBuilder: (context, index) {
                      final product = productController.productList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Hero(
                              tag: 'product-${product.id}',
                              child: ProductCard(product: product),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          }),

          // Section Title
          // Positioned(
          //   top: 15,
          //   left: 24,
          //   child: Text(
          //     "All Products",
          //     style: GoogleFonts.poppins(
          //       fontSize: 18,
          //       fontWeight: FontWeight.w600,
          //       color: Colors.black87,
          //     ),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: Container(
        height: 55,
        child: FloatingActionButton.extended(
          onPressed: () {
            Get.to(() => AddProductPage());
          },
          backgroundColor: Color.fromRGBO(255, 86, 86, 0.8),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          icon: const Icon(Icons.add),
          label: Text(
            'ADD PRODUCT',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
