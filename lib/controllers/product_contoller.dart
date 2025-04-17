import 'package:fluffyn/models/product_model.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';



class ProductController extends GetxController {
  // your code
  var productList = <Product>[].obs;

@override
void onInit() {
  fetchProductList();
  super.onInit();
}

void fetchProductList() async {
  try {
    var products = await ApiService.fetchProducts();
    productList.assignAll(products);
  } catch (e) {
    Get.snackbar('Error', e.toString());
  }
}
}

