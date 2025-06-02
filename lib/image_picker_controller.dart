import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' as img_picker;

class ImagePickerController extends GetxController {
  RxString imagePath = ''.obs;

  Future<void> pickImage() async {
    final picker = img_picker.ImagePicker();
    final pickedImage = await picker.pickImage(source: img_picker.ImageSource.gallery);
    if (pickedImage != null) {
      imagePath.value = pickedImage.path.toString();
    }
  }
}
