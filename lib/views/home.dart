import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/post_field.dart';
import 'widgets/post_data.dart';
import 'package:forumapp/controllers/post_controller.dart';
import 'package:forumapp/controllers/authentication.dart';
import '../views/quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostController _postController = Get.put(PostController());
  final TextEditingController _textController = TextEditingController();
  final AuthenticationController authController = AuthenticationController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protectress'),
        backgroundColor: const Color.fromARGB(255, 228, 226, 226),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authController.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () async {
              await _postController.getAllPosts();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostFIeld(
                  hintText: 'What do you want to ask?',
                  controller: _textController,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () async {
                    await _postController.createPost(
                      content: _textController.text.trim(),
                    );
                    _textController.clear();
                    _postController.getAllPosts();
                  },
                  child: Obx(() {
                    return _postController.isLoading.value
                        ? const CircularProgressIndicator()
                        : Text('Post');
                  }),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Text('Posts'),
                // const SizedBox(
                //   height: 20,
                // ),
                // const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => QuizPage());
                  },
                  child: const Text('Start Quiz'),
                ),
                const SizedBox(height: 30),
                const Text('Posts'),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await sendEmergencyMessage();
                  },
                  child: const Text('Emergency Message'),
                ),
                const SizedBox(height: 30),
                const Text('Posts'),
                const SizedBox(height: 20),
                Obx(() {
                  return _postController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _postController.posts.value.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: PostData(
                                post: _postController.posts.value[index],
                              ),
                            );
                          },
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendEmergencyMessage() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    String message =
        'Help me, I am in an emergency with the location: https://maps.google.com/?q=${_locationData.latitude},${_locationData.longitude}';

    String? emergencyNumber = authController.box.read('emergency_number');
    print("Read Emergency Number: $emergencyNumber"); // Debug print
    if (emergencyNumber == null || emergencyNumber.isEmpty) {
      // Handle the case where emergency number is not set
      Get.snackbar('Error', 'Emergency number is not set.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    String url =
        'https://wa.me/$emergencyNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
