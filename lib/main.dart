import 'package:flutter/material.dart';
import 'package:flutter_practice_project/image_picker_controller.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String name = "";
  String job = "";
  String email = "";
  String phone = "";

  final nameController = TextEditingController();
  final jobController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final imagepickerController = Get.put(ImagePickerController());
  final ScreenshotController screenshotController = ScreenshotController();

  void showInputForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.orange,
        title: Text('Add Your Data'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await imagepickerController.pickImage();
                },
                icon: Icon(Icons.image),
                label: Text("Pick Image"),
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.white54),
              ),
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name")),
              TextField(
                  controller: jobController,
                  decoration: InputDecoration(labelText: "Job")),
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email")),
              TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: "Phone")),
              SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  setState(() {
                    name = nameController.text;
                    job = jobController.text;
                    email = emailController.text;
                    phone = phoneController.text;

                    nameController.clear();
                    jobController.clear();
                    phoneController.clear();
                    emailController.clear();
                  });

                  Navigator.pop(context);
                  Get.snackbar(
                    name,
                    "Your card is ready",
                    icon: Icon(Icons.add),
                    duration: Duration(seconds: 3),
                    snackStyle: SnackStyle.FLOATING,
                    backgroundColor: Colors.white54,
                    borderRadius: 10,
                  );
                },
                child: Text(
                  'Save Data',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Screenshot(
                controller: screenshotController,
                child: Container(
                  color: Colors.orange,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => CircleAvatar(
                            radius: 120.0,
                            backgroundImage: imagepickerController
                                    .imagePath.value.isNotEmpty
                                ? FileImage(
                                    File(imagepickerController.imagePath.value))
                                : null,
                          )),
                      Text(
                        name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Fugaz'),
                      ),
                      Text(
                        job,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Passion'),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5.0),
                        color: Colors.white30,
                        child: Row(
                          children: [
                            Icon(Icons.email_outlined),
                            SizedBox(width: 7.0),
                            Text(
                              email,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 17.0),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5.0),
                        color: Colors.white30,
                        child: Row(
                          children: [
                            Icon(Icons.phone_android_outlined),
                            SizedBox(width: 7.0),
                            Text(
                              phone,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final image = await screenshotController.capture();
                if (image == null) return;
                final directory = await getTemporaryDirectory();
                final imagePath =
                    await File('${directory.path}/card.png').create();
                await imagePath.writeAsBytes(image);
                await Share.shareXFiles([XFile(imagePath.path)],
                    text: 'Here is my digital card!');
              },
              icon: Icon(Icons.share),
              label: Text(
                "Share",
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white30),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showInputForm,
        backgroundColor: Colors.red,
        child: Icon(Icons.edit),
      ),
    );
  }
}
