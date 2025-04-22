import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluffyn/models/product_model.dart';
import 'package:fluffyn/controllers/product_contoller.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final ProductController productController = Get.find();
  final categories = [
    "Electronics",
    "Clothing",
    "Accessories",
    "Home",
    "Books",
    "Other"
  ];
  String selectedCategory = "Other";

  File? selectedImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();

    // Show dialog to choose camera or gallery
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Image Source",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _imageSourceOption(
                      icon: Icons.camera_alt,
                      title: "Camera",
                      onTap: () async {
                        Navigator.pop(context);
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.camera);
                        _processPickedImage(pickedFile);
                      },
                    ),
                    _imageSourceOption(
                      icon: Icons.photo_library,
                      title: "Gallery",
                      onTap: () async {
                        Navigator.pop(context);
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        _processPickedImage(pickedFile);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imageSourceOption(
      {required IconData icon,
      required String title,
      required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          SizedBox(height: 10),
          Text(title),
        ],
      ),
    );
  }

  void _processPickedImage(XFile? pickedFile) {
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  bool _validateInputs() {
    if (titleController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a title",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1));
      return false;
    }
    if (priceController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a price",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1));
      return false;
    }
    if (selectedImage == null) {
      Get.snackbar("Error", "Please select an image",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1));
      return false;
    }
    return true;
  }

  void _submitProduct() async {
    if (!_validateInputs()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final product = Product(
        id: DateTime.now().millisecondsSinceEpoch,
        title: titleController.text.trim(),
        price: double.tryParse(priceController.text) ?? 0.0,
        description: descController.text.trim(),
        image: selectedImage!.path, // Local path
        category: selectedCategory,
        rating: Rating(rate: 0.0, count: 0),
      );

      // Simulate network delay for better UX
      await Future.delayed(Duration(milliseconds: 800));
      productController.addLocalProduct(product);

      Get.back();
      Get.snackbar(
        "Success",
        "Product added successfully",
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green.shade800,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to add product: ${e.toString()}",
          backgroundColor: Colors.red.withOpacity(0.1));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue.shade700),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Image",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2),
                            color: Colors.grey.shade100,
                          ),
                          child: selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 60,
                                      color: Colors.blue.shade300,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Tap to add product image",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 30),
                      _buildInputField(
                        controller: titleController,
                        label: "Product Title",
                        hint: "Enter product name",
                        icon: Icons.title,
                      ),
                      _buildInputField(
                        controller: priceController,
                        label: "Price",
                        hint: "Enter product price",
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                      ),
                      _buildCategoryDropdown(),
                      _buildInputField(
                        controller: descController,
                        label: "Description",
                        hint: "Enter product description",
                        icon: Icons.description,
                        maxLines: 5,
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _submitProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "ADD PRODUCT",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(icon, color: Colors.blue.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Category",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.category, color: Colors.blue.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                filled: true,
                fillColor: Colors.white,
              ),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade400),
            ),
          ),
        ],
      ),
    );
  }
}
