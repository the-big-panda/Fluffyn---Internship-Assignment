import 'package:fluffyn/screens/cartpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluffyn/controllers/profile_controller.dart';

class UserProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.find();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My Profile",
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
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Colors.black87),
            onPressed: () {
              // Add settings functionality
              Get.snackbar("Settings", "Settings coming soon",
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),
        ],
      ),
      body: Obx(() {
        nameController.text = controller.name.value;
        emailController.text = controller.email.value;
        bioController.text = controller.bio.value;

        return Stack(
          children: [
            // Background Design
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.15,
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

            SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header Section
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      children: [
                        // Profile Image with Border
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              )
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/username.jpg',
                                height: 135,
                                width: 135,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Profile Info Text
                        Text(
                          nameController.text,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          emailController.text,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Content Section
                  Container(
                    padding: EdgeInsets.all(24),
                    margin: EdgeInsets.symmetric(horizontal: 20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Personal Information"),
                        SizedBox(height: 20),

                        // Name Field
                        _buildTextField(
                          controller: nameController,
                          label: "Full Name",
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 15),

                        // Email Field
                        _buildTextField(
                          controller: emailController,
                          label: "Email Address",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 15),

                        // Bio Field
                        _buildTextField(
                          controller: bioController,
                          label: "About Me",
                          icon: Icons.edit_note,
                          maxLines: 3,
                        ),
                        SizedBox(height: 30),

                        // Save Button
                        Container(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.updateProfile(
                                newName: nameController.text.trim(),
                                newEmail: emailController.text.trim(),
                                newBio: bioController.text.trim(),
                              );

                              Get.snackbar(
                                "Success",
                                "Profile updated successfully!",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green.withOpacity(0.1),
                                colorText: Colors.green.shade800,
                                margin: EdgeInsets.all(10),
                                borderRadius: 10,
                                icon: Icon(Icons.check_circle,
                                    color: Colors.green),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(255, 86, 86, 0.8),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              "SAVE CHANGES",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Additional options
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 8),
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
                    child: Column(
                      children: [
                        _buildOptionItem(
                          title: "My Orders",
                          icon: Icons.shopping_bag_outlined,
                          onTap: () {
                            Get.snackbar("Orders", "My Orders coming soon");
                          },
                        ),
                        Divider(
                            height: 1, thickness: 1, indent: 70, endIndent: 20),
                        _buildOptionItem(
                          title: "Wishlist",
                          icon: Icons.favorite_border,
                          onTap: () {
                            Get.snackbar("Wishlist", "Wishlist coming soon");
                          },
                        ),
                        Divider(
                            height: 1, thickness: 1, indent: 70, endIndent: 20),
                        _buildOptionItem(
                          title: "Help & Support",
                          icon: Icons.help_outline,
                          onTap: () {
                            Get.snackbar(
                                "Support", "Help & Support coming soon");
                          },
                        ),
                        Divider(
                            height: 1, thickness: 1, indent: 70, endIndent: 20),
                        _buildOptionItem(
                          title: "My Cart",
                          icon: Icons.help_outline,
                          onTap: () {
                            Get.to(() => CartPage());
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: InputBorder.none,
          hintText: label,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Color.fromRGBO(255, 86, 86, 0.7),
          ),
        ),
      ),
    );
  }

  // Helper method for section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  // Helper method for option items
  Widget _buildOptionItem({
    required String title,
    required IconData icon,
    required Function onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 86, 86, 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Color.fromRGBO(255, 86, 86, 0.8),
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () => onTap(),
    );
  }
}
