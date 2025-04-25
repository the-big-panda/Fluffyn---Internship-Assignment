import 'package:fluffyn/models/product_model.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'package:get_storage/get_storage.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;
  final box = GetStorage();

  void addLocalProduct(Product product) {
    productList.add(product);

    // Save updated list to local storage
    List<Map<String, dynamic>> mapped =
        productList.map((p) => p.toJson()).toList();
    box.write('products', mapped);
  }

  @override
  void onInit() {
    super.onInit();
    loadLocalProducts();
    fetchProductList();
  }

  void loadLocalProducts() {
    final stored = box.read<List>('products');
    if (stored != null) {
      final local = stored
          .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      productList.addAll(local);
    }
  }

  Future<void> fetchProductList() async {
  try {
    var apiProducts = await ApiService.fetchProducts();
    var ids = productList.map((p) => p.id).toSet();
    var newItems = apiProducts.where((p) => !ids.contains(p.id)).toList();
    productList.addAll(newItems);
  } catch (e) {
    Get.snackbar('Error', e.toString());
  }
}

  
  // Added a method that can be used by the RefreshIndicator
  Future<void> fetchProducts() async {
    return fetchProductList();
  }
}