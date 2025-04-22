import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final box = GetStorage();

  // Reactive variables
  var name = ''.obs;
  var email = ''.obs;
  var bio = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load data from local storage or use default values
    name.value = box.read('name') ?? 'Virat Kohli';
    email.value = box.read('email') ?? 'virat.kohli@dummyemail.com';
    bio.value = box.read('bio') ?? 'Passionate cricketer and tech enthusiast.';
  }

  void updateProfile(
      {required String newName,
      required String newEmail,
      required String newBio}) {
    name.value = newName;
    email.value = newEmail;
    bio.value = newBio;

    // Save to storage
    box.write('name', newName);
    box.write('email', newEmail);
    box.write('bio', newBio);
  }
}
