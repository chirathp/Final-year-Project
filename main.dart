// // import 'dart:typed_data';
// // import 'package:flutter/material.dart';
// // import 'package:camera/camera.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:url_launcher/url_launcher.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   cameras = await availableCameras();
// //   runApp(MyApp());
// // }

// // late List<CameraDescription> cameras;

// // class MyApp extends StatefulWidget {
// //   const MyApp({super.key});

// //   @override
// //   _MyAppState createState() => _MyAppState();
// // }

// // class _MyAppState extends State<MyApp> {
// //   Uint8List? _imageBytes;
// //   String? _predictedEmotion;
// //   bool _isLoading = false;
// //   CameraController? _controller;
// //   bool _isCameraInitialized = false;
// //   bool _isCameraOpen = false;
// //   String? _songLink;

// //   @override
// //   void initState() {
// //     super.initState();
// //   }

// //   Future<void> initializeCamera() async {
// //     if (_controller != null) {
// //       await _controller!.dispose();
// //     }

// //     _controller = CameraController(cameras[0], ResolutionPreset.medium);
// //     await _controller!.initialize();
// //     if (mounted) {
// //       setState(() {
// //         _isCameraInitialized = true;
// //         _isCameraOpen = true;
// //       });
// //     }
// //   }

// //   Future<void> closeCamera() async {
// //     if (_controller != null) {
// //       await _controller!.dispose();
// //       if (mounted) {
// //         setState(() {
// //           _isCameraInitialized = false;
// //           _isCameraOpen = false;
// //         });
// //       }
// //     }
// //   }

// //   Future<void> captureImage() async {
// //     if (_controller == null || !_controller!.value.isInitialized) return;

// //     try {
// //       XFile image = await _controller!.takePicture();
// //       Uint8List imageBytes = await image.readAsBytes();
// //       setState(() {
// //         _imageBytes = imageBytes;
// //         _predictedEmotion = null; // Reset previous prediction
// //         _songLink = null; // Reset previous song link
// //       });
// //     } catch (e) {
// //       print("Error capturing image: $e");
// //     }
// //   }

// //   Future<void> pickImageFromGallery() async {
// //     final picker = ImagePicker();
// //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

// //     if (pickedFile != null) {
// //       Uint8List imageBytes = await pickedFile.readAsBytes();
// //       setState(() {
// //         _imageBytes = imageBytes;
// //         _predictedEmotion = null; // Reset previous prediction
// //         _songLink = null; // Reset previous song link
// //       });
// //     }
// //   }

// //   Future<void> uploadImage() async {
// //     if (_imageBytes == null) return;

// //     setState(() {
// //       _isLoading = true;
// //       _predictedEmotion = null;
// //       _songLink = null;
// //     });

// //     try {
// //       var request = http.MultipartRequest(
// //         'POST',
// //         Uri.parse("https://9703-34-46-180-208.ngrok-free.app/predict"),
// //       );
// //       request.files.add(
// //         http.MultipartFile.fromBytes('file', _imageBytes!,
// //             filename: 'image.jpg'),
// //       );

// //       var response = await request.send();
// //       var responseData = await response.stream.bytesToString();

// //       if (response.statusCode == 200) {
// //         var jsonResponse = json.decode(responseData);
// //         setState(() {
// //           _isLoading = false;
// //           _predictedEmotion = jsonResponse['predicted_class'];
// //           _songLink = jsonResponse['song_link'];
// //         });
// //       } else {
// //         setState(() {
// //           _isLoading = false;
// //           _predictedEmotion = "Error: ${json.decode(responseData)['error']}";
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         _isLoading = false;
// //         _predictedEmotion = "Error: $e";
// //       });
// //     }
// //   }

// //   Future<void> openSpotifyLink() async {
// //     if (_songLink != null && await canLaunch(_songLink!)) {
// //       await launch(_songLink!);
// //     } else {
// //       throw 'Could not launch $_songLink';
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(title: Text("Emotion Detection-Music Recommendation")),
// //         body: Padding(
// //           padding: EdgeInsets.symmetric(horizontal: 20),
// //           child: Row(
// //             children: [
// //               // Left Side: Emotion Detection
// //               Expanded(
// //                 flex: 3,
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.start,
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     SizedBox(height: 20),
// //                     Text(
// //                       "Emotion Detection",
// //                       style:
// //                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //                     ),
// //                     SizedBox(height: 20),
// //                     _isCameraOpen
// //                         ? SizedBox(
// //                             width: 200,
// //                             height: 150,
// //                             child: _isCameraInitialized
// //                                 ? CameraPreview(_controller!)
// //                                 : Center(child: CircularProgressIndicator()),
// //                           )
// //                         : Text("Camera is closed"),
// //                     SizedBox(height: 10),
// //                     _isCameraOpen
// //                         ? ElevatedButton(
// //                             onPressed: captureImage,
// //                             child: Text("Capture Image"),
// //                           )
// //                         : Container(),
// //                     SizedBox(height: 10),
// //                     _imageBytes != null
// //                         ? Image.memory(_imageBytes!,
// //                             width: 200, height: 200, fit: BoxFit.cover)
// //                         : Text("No image captured"),
// //                     SizedBox(height: 10),
// //                     _isCameraOpen
// //                         ? ElevatedButton(
// //                             onPressed: closeCamera,
// //                             child: Text("Close Camera"),
// //                           )
// //                         : ElevatedButton(
// //                             onPressed: initializeCamera,
// //                             child: Text("Open Camera"),
// //                           ),
// //                     SizedBox(height: 10),
// //                     ElevatedButton(
// //                       onPressed: pickImageFromGallery,
// //                       child: Text("Upload Image from Gallery"),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Vertical Divider
// //               Container(
// //                 width: 2,
// //                 height: double.infinity,
// //                 color: Colors.grey.shade400,
// //                 margin: EdgeInsets.symmetric(vertical: 20),
// //               ),

// //               // Right Side: Music Recommendation
// //               Expanded(
// //                 flex: 2,
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.start,
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [
// //                     SizedBox(height: 20),
// //                     Text(
// //                       "Music Recommendation",
// //                       style:
// //                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //                     ),
// //                     SizedBox(height: 20),
// //                     ElevatedButton(
// //                       onPressed: uploadImage,
// //                       child: Text("Get Prediction"),
// //                     ),
// //                     SizedBox(height: 20),
// //                     _isLoading
// //                         ? CircularProgressIndicator()
// //                         : _predictedEmotion != null
// //                             ? Column(
// //                                 children: [
// //                                   Text(
// //                                     "Prediction: $_predictedEmotion",
// //                                     style: TextStyle(
// //                                         fontSize: 20,
// //                                         fontWeight: FontWeight.bold),
// //                                   ),
// //                                   SizedBox(height: 20),
// //                                   ElevatedButton(
// //                                     onPressed: () {
// //                                       if (_songLink != null) {
// //                                         uploadImage();
// //                                       }
// //                                     },
// //                                     child: Text("Get Recommended Song"),
// //                                   ),
// //                                   SizedBox(height: 10),
// //                                   ElevatedButton(
// //                                     onPressed: _songLink != null
// //                                         ? openSpotifyLink
// //                                         : null,
// //                                     child: Text("Open Song in Spotify"),
// //                                     style: ElevatedButton.styleFrom(
// //                                       backgroundColor: Colors.green,
// //                                       foregroundColor: Colors.white,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               )
// //                             : Container(),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
// import 'package:url_launcher/url_launcher.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(MyApp());
// }

// late List<CameraDescription> cameras;

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   Uint8List? _imageBytes;
//   String? _predictedEmotion;
//   bool _isLoading = false;
//   bool _isLoadingSong = false;
//   CameraController? _controller;
//   bool _isCameraInitialized = false;
//   bool _isCameraOpen = false;
//   String? _songLink;
//   String? _songName;
//   String? _artistName;
//   bool _showSongDetails = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> initializeCamera() async {
//     if (_controller != null) {
//       await _controller!.dispose();
//     }

//     _controller = CameraController(cameras[0], ResolutionPreset.medium);
//     await _controller!.initialize();
//     if (mounted) {
//       setState(() {
//         _isCameraInitialized = true;
//         _isCameraOpen = true;
//       });
//     }
//   }

//   Future<void> closeCamera() async {
//     if (_controller != null) {
//       await _controller!.dispose();
//       if (mounted) {
//         setState(() {
//           _isCameraInitialized = false;
//           _isCameraOpen = false;
//         });
//       }
//     }
//   }

//   Future<void> captureImage() async {
//     if (_controller == null || !_controller!.value.isInitialized) return;

//     try {
//       XFile image = await _controller!.takePicture();
//       Uint8List imageBytes = await image.readAsBytes();
//       setState(() {
//         _imageBytes = imageBytes;
//         _predictedEmotion = null;
//         _songLink = null;
//         _songName = null;
//         _artistName = null;
//         _showSongDetails = false;
//       });
//     } catch (e) {
//       print("Error capturing image: $e");
//     }
//   }

//   Future<void> pickImageFromGallery() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       Uint8List imageBytes = await pickedFile.readAsBytes();
//       setState(() {
//         _imageBytes = imageBytes;
//         _predictedEmotion = null;
//         _songLink = null;
//         _songName = null;
//         _artistName = null;
//         _showSongDetails = false;
//       });
//     }
//   }

//   Future<void> getPrediction() async {
//     if (_imageBytes == null) return;

//     setState(() {
//       _isLoading = true;
//       _predictedEmotion = null;
//       _songLink = null;
//       _songName = null;
//       _artistName = null;
//       _showSongDetails = false;
//     });

//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse("https://5956-35-202-216-67.ngrok-free.app/predict"),
//       );
//       request.files.add(
//         http.MultipartFile.fromBytes('file', _imageBytes!,
//             filename: 'image.jpg'),
//       );

//       var response = await request.send();
//       var responseData = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(responseData);
//         setState(() {
//           _isLoading = false;
//           _predictedEmotion = jsonResponse['predicted_class'];
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _predictedEmotion = "Error: ${json.decode(responseData)['error']}";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _predictedEmotion = "Error: $e";
//       });
//     }
//   }

//   Future<void> getRecommendedSong() async {
//     if (_imageBytes == null || _predictedEmotion == null) return;

//     setState(() {
//       _isLoadingSong = true;
//       _songLink = null;
//       _songName = null;
//       _artistName = null;
//       _showSongDetails = false;
//     });

//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse("https://5956-35-202-216-67.ngrok-free.app/predict"),
//       );
//       request.files.add(
//         http.MultipartFile.fromBytes('file', _imageBytes!,
//             filename: 'image.jpg'),
//       );

//       var response = await request.send();
//       var responseData = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(responseData);
//         setState(() {
//           _isLoadingSong = false;
//           _songLink = jsonResponse['song_link'];
//           _songName = jsonResponse['song_name'];
//           _artistName = jsonResponse['artist_name'];
//           _showSongDetails = true;
//         });
//       } else {
//         setState(() {
//           _isLoadingSong = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoadingSong = false;
//       });
//     }
//   }

//   Future<void> openSpotifyLink() async {
//     if (_songLink != null && await canLaunch(_songLink!)) {
//       await launch(_songLink!);
//     } else {
//       throw 'Could not launch $_songLink';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Emotion Detection-Music Recommendation")),
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             children: [
//               // Left Column - Emotion Detection UI
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 20),
//                     Text(
//                       "Emotion Detection",
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 20),
//                     _isCameraOpen
//                         ? SizedBox(
//                             width: 200,
//                             height: 150,
//                             child: _isCameraInitialized
//                                 ? CameraPreview(_controller!)
//                                 : Center(child: CircularProgressIndicator()),
//                           )
//                         : Text("Camera is closed"),
//                     SizedBox(height: 10),
//                     _isCameraOpen
//                         ? ElevatedButton(
//                             onPressed: captureImage,
//                             child: Text("Capture Image"),
//                           )
//                         : Container(),
//                     SizedBox(height: 10),
//                     _imageBytes != null
//                         ? Image.memory(_imageBytes!,
//                             width: 200, height: 200, fit: BoxFit.cover)
//                         : Text("No image captured"),
//                     SizedBox(height: 10),
//                     _isCameraOpen
//                         ? ElevatedButton(
//                             onPressed: closeCamera,
//                             child: Text("Close Camera"),
//                           )
//                         : ElevatedButton(
//                             onPressed: initializeCamera,
//                             child: Text("Open Camera"),
//                           ),
//                     SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: pickImageFromGallery,
//                       child: Text("Upload Image from Gallery"),
//                     ),
//                   ],
//                 ),
//               ),

//               // Middle Column - Prediction Button and Results
//               Container(
//                 width: 2,
//                 height: double.infinity,
//                 color: Colors.grey.shade400,
//                 margin: EdgeInsets.symmetric(vertical: 20),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: getPrediction,
//                       child: Text("Get Prediction"),
//                       style: ElevatedButton.styleFrom(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                         textStyle: TextStyle(fontSize: 18),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     _isLoading
//                         ? CircularProgressIndicator()
//                         : _predictedEmotion != null
//                             ? Column(
//                                 children: [
//                                   Text(
//                                     "Detected Emotion:",
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Text(
//                                     _predictedEmotion!.toUpperCase(),
//                                     style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.blue,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : Container(),
//                   ],
//                 ),
//               ),

//               // Right Column - Music Recommendation
//               Container(
//                 width: 2,
//                 height: double.infinity,
//                 color: Colors.grey.shade400,
//                 margin: EdgeInsets.symmetric(vertical: 20),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 20),
//                     Text(
//                       "Music Recommendation",
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 40),
//                     if (_predictedEmotion != null) ...[
//                       ElevatedButton(
//                         onPressed: getRecommendedSong,
//                         child: _isLoadingSong
//                             ? CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               )
//                             : Text("Get Recommended Song"),
//                         style: ElevatedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 15),
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       if (_showSongDetails)
//                         Column(
//                           children: [
//                             Text(
//                               "We recommend:",
//                               style: TextStyle(fontSize: 18),
//                             ),
//                             SizedBox(height: 20),
//                             Container(
//                               padding: EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     _songName ?? 'No song name',
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   SizedBox(height: 10),
//                                   Text(
//                                     "by ${_artistName ?? 'Unknown artist'}",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontStyle: FontStyle.italic,
//                                     ),
//                                   ),
//                                   SizedBox(height: 20),
//                                   ElevatedButton(
//                                     onPressed: _songLink != null
//                                         ? openSpotifyLink
//                                         : null,
//                                     child: Text("Play on Spotify"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.green,
//                                       foregroundColor: Colors.white,
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 30, vertical: 15),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                     ] else ...[
//                       Text(
//                         "Get an emotion prediction first",
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
// import 'package:url_launcher/url_launcher.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(MyApp());
// }

// late List<CameraDescription> cameras;

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   Uint8List? _imageBytes;
//   String? _predictedEmotion;
//   bool _isLoading = false;
//   bool _isLoadingSong = false;
//   CameraController? _controller;
//   bool _isCameraInitialized = false;
//   bool _isCameraOpen = false;

//   // Spotify recommendation data
//   String? _songLink;
//   String? _songName;
//   String? _artistName;
//   String? _albumImageUrl;
//   bool _showSongDetails = false;

//   // KNN recommendations
//   List<dynamic> _knnRecommendations = [];
//   String? _modelUsed;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> initializeCamera() async {
//     if (_controller != null) {
//       await _controller!.dispose();
//     }

//     _controller = CameraController(cameras[0], ResolutionPreset.medium);
//     await _controller!.initialize();
//     if (mounted) {
//       setState(() {
//         _isCameraInitialized = true;
//         _isCameraOpen = true;
//       });
//     }
//   }

//   Future<void> closeCamera() async {
//     if (_controller != null) {
//       await _controller!.dispose();
//       if (mounted) {
//         setState(() {
//           _isCameraInitialized = false;
//           _isCameraOpen = false;
//         });
//       }
//     }
//   }

//   Future<void> captureImage() async {
//     if (_controller == null || !_controller!.value.isInitialized) return;

//     try {
//       XFile image = await _controller!.takePicture();
//       Uint8List imageBytes = await image.readAsBytes();
//       setState(() {
//         _imageBytes = imageBytes;
//         _predictedEmotion = null;
//         _songLink = null;
//         _songName = null;
//         _artistName = null;
//         _albumImageUrl = null;
//         _showSongDetails = false;
//         _knnRecommendations = [];
//       });
//     } catch (e) {
//       print("Error capturing image: $e");
//     }
//   }

//   Future<void> pickImageFromGallery() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       Uint8List imageBytes = await pickedFile.readAsBytes();
//       setState(() {
//         _imageBytes = imageBytes;
//         _predictedEmotion = null;
//         _songLink = null;
//         _songName = null;
//         _artistName = null;
//         _albumImageUrl = null;
//         _showSongDetails = false;
//         _knnRecommendations = [];
//       });
//     }
//   }

//   Future<void> getPredictionAndRecommendations() async {
//     if (_imageBytes == null) return;

//     setState(() {
//       _isLoading = true;
//       _isLoadingSong = true;
//       _predictedEmotion = null;
//       _songLink = null;
//       _songName = null;
//       _artistName = null;
//       _albumImageUrl = null;
//       _showSongDetails = false;
//       _knnRecommendations = [];
//     });

//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse("https://5956-35-202-216-67.ngrok-free.app/predict"),
//       );
//       request.files.add(
//         http.MultipartFile.fromBytes('file', _imageBytes!,
//             filename: 'image.jpg'),
//       );

//       var response = await request.send();
//       var responseData = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(responseData);
//         print(jsonResponse); // For debugging

//         setState(() {
//           _isLoading = false;
//           _isLoadingSong = false;
//           _predictedEmotion = jsonResponse['predicted_class'];
//           _modelUsed = jsonResponse['model_used'];

//           // Handle spotify recommendation
//           if (jsonResponse['spotify_recommendation'] != null) {
//             var spotifyRec = jsonResponse['spotify_recommendation'];
//             _songLink = spotifyRec['link'];
//             _songName = spotifyRec['name'];
//             _artistName = spotifyRec['artist'];
//             _albumImageUrl = spotifyRec['image'];
//           }

//           // Handle KNN recommendations
//           if (jsonResponse['knn_recommendations'] != null) {
//             _knnRecommendations = jsonResponse['knn_recommendations'];
//           }

//           _showSongDetails = true;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _isLoadingSong = false;
//           _predictedEmotion = "Error: ${json.decode(responseData)['error']}";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _isLoadingSong = false;
//         _predictedEmotion = "Error: $e";
//       });
//     }
//   }

//   Future<void> openSpotifyLink(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   Widget _buildRecommendationCard(Map<String, dynamic> recommendation) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Column(
//           children: [
//             if (recommendation['image'] != null)
//               Image.network(
//                 recommendation['image'],
//                 height: 100,
//                 width: 100,
//                 fit: BoxFit.cover,
//               ),
//             SizedBox(height: 8),
//             Text(
//               recommendation['name'] ?? 'Unknown song',
//               style: TextStyle(fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 4),
//             Text(
//               recommendation['artist'] ?? 'Unknown artist',
//               style: TextStyle(color: Colors.grey),
//             ),
//             SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () => openSpotifyLink(recommendation['link']),
//               child: Text("Play on Spotify"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Emotion Detection-Music Recommendation")),
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             children: [
//               // Left Column - Emotion Detection UI
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 20),
//                     Text(
//                       "Emotion Detection",
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 20),
//                     _isCameraOpen
//                         ? SizedBox(
//                             width: 200,
//                             height: 150,
//                             child: _isCameraInitialized
//                                 ? CameraPreview(_controller!)
//                                 : Center(child: CircularProgressIndicator()),
//                           )
//                         : Text("Camera is closed"),
//                     SizedBox(height: 10),
//                     _isCameraOpen
//                         ? ElevatedButton(
//                             onPressed: captureImage,
//                             child: Text("Capture Image"),
//                           )
//                         : Container(),
//                     SizedBox(height: 10),
//                     _imageBytes != null
//                         ? Image.memory(_imageBytes!,
//                             width: 200, height: 200, fit: BoxFit.cover)
//                         : Text("No image captured"),
//                     SizedBox(height: 10),
//                     _isCameraOpen
//                         ? ElevatedButton(
//                             onPressed: closeCamera,
//                             child: Text("Close Camera"),
//                           )
//                         : ElevatedButton(
//                             onPressed: initializeCamera,
//                             child: Text("Open Camera"),
//                           ),
//                     SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: pickImageFromGallery,
//                       child: Text("Upload Image from Gallery"),
//                     ),
//                   ],
//                 ),
//               ),

//               // Middle Column - Prediction Button and Results
//               Container(
//                 width: 2,
//                 height: double.infinity,
//                 color: Colors.grey.shade400,
//                 margin: EdgeInsets.symmetric(vertical: 20),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: getPredictionAndRecommendations,
//                       child: Text("Get Prediction"),
//                       style: ElevatedButton.styleFrom(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                         textStyle: TextStyle(fontSize: 18),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     _isLoading
//                         ? CircularProgressIndicator()
//                         : _predictedEmotion != null
//                             ? Column(
//                                 children: [
//                                   Text(
//                                     "Detected Emotion:",
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Text(
//                                     _predictedEmotion!.toUpperCase(),
//                                     style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.blue,
//                                     ),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Text(
//                                     "Model used: ${_modelUsed ?? 'Unknown'}",
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ],
//                               )
//                             : Container(),
//                   ],
//                 ),
//               ),

//               // Right Column - Music Recommendation
//               Container(
//                 width: 2,
//                 height: double.infinity,
//                 color: Colors.grey.shade400,
//                 margin: EdgeInsets.symmetric(vertical: 20),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 20),
//                     Text(
//                       "Music Recommendations",
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 20),
//                     if (_isLoadingSong)
//                       CircularProgressIndicator()
//                     else if (_showSongDetails) ...[
//                       Text(
//                         "Top Recommendation for $_predictedEmotion:",
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       SizedBox(height: 20),
//                       if (_songName != null)
//                         _buildRecommendationCard({
//                           'name': _songName,
//                           'artist': _artistName,
//                           'image': _albumImageUrl,
//                           'link': _songLink,
//                         }),
//                       SizedBox(height: 20),
//                       if (_knnRecommendations.isNotEmpty) ...[
//                         Text(
//                           "Similar Recommendations:",
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         SizedBox(height: 10),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: _knnRecommendations.length,
//                             itemBuilder: (context, index) {
//                               return _buildRecommendationCard(
//                                   _knnRecommendations[index]);
//                             },
//                           ),
//                         ),
//                       ],
//                     ] else ...[
//                       Text(
//                         "Get an emotion prediction first",
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

late List<CameraDescription> cameras;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uint8List? _imageBytes;
  String? _predictedEmotion;
  bool _isLoading = false;
  bool _isLoadingSong = false;
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isCameraOpen = false;

  // Spotify recommendation data
  String? _songLink;
  String? _songName;
  String? _artistName;
  String? _albumImageUrl;
  bool _showSongDetails = false;
  bool _showRecommendations = false; // New flag to control visibility

  // KNN recommendations
  List<dynamic> _knnRecommendations = [];
  String? _modelUsed;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeCamera() async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller!.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
        _isCameraOpen = true;
      });
    }
  }

  Future<void> closeCamera() async {
    if (_controller != null) {
      await _controller!.dispose();
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
          _isCameraOpen = false;
        });
      }
    }
  }

  Future<void> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      XFile image = await _controller!.takePicture();
      Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _imageBytes = imageBytes;
        _predictedEmotion = null;
        _songLink = null;
        _songName = null;
        _artistName = null;
        _albumImageUrl = null;
        _showSongDetails = false;
        _showRecommendations = false;
        _knnRecommendations = [];
      });
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = imageBytes;
        _predictedEmotion = null;
        _songLink = null;
        _songName = null;
        _artistName = null;
        _albumImageUrl = null;
        _showSongDetails = false;
        _showRecommendations = false;
        _knnRecommendations = [];
      });
    }
  }

  Future<void> getPrediction() async {
    if (_imageBytes == null) return;

    setState(() {
      _isLoading = true;
      _predictedEmotion = null;
      _songLink = null;
      _songName = null;
      _artistName = null;
      _albumImageUrl = null;
      _showSongDetails = false;
      _showRecommendations = false;
      _knnRecommendations = [];
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://9cb5-34-125-205-230.ngrok-free.app/predict"),
      );
      request.files.add(
        http.MultipartFile.fromBytes('file', _imageBytes!,
            filename: 'image.jpg'),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseData);
        print(jsonResponse); // For debugging

        setState(() {
          _isLoading = false;
          _predictedEmotion = jsonResponse['predicted_class'];
          _modelUsed = jsonResponse['model_used'];

          // If prediction fails or camera misdetects, defaults to 'neutral'
          _predictedEmotion ??= 'neutral'; // Ensures neutral if null response

          // Store recommendations but don't show them yet
          if (jsonResponse['spotify_recommendation'] != null) {
            var spotifyRec = jsonResponse['spotify_recommendation'];
            _songLink = spotifyRec['link'];
            _songName = spotifyRec['name'];
            _artistName = spotifyRec['artist'];
            _albumImageUrl = spotifyRec['image'];
            _showSongDetails = true;
          }

          if (jsonResponse['knn_recommendations'] != null) {
            _knnRecommendations = jsonResponse['knn_recommendations'];
          }
        });
      } else {
        setState(() {
          _isLoading = false;
          _predictedEmotion = "Error: ${json.decode(responseData)['error']}";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _predictedEmotion = "Error: $e";
      });
    }
  }

  void showRecommendations() {
    setState(() {
      _showRecommendations = true;
    });
  }

  Future<void> openSpotifyLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildRecommendationCard(Map<String, dynamic> recommendation) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            if (recommendation['image'] != null)
              Image.network(
                recommendation['image'],
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 8),
            Text(
              recommendation['name'] ?? 'Unknown song',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              recommendation['artist'] ?? 'Unknown artist',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => openSpotifyLink(recommendation['link']),
              child: Text("Play on Spotify"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Emotion Detection-Music Recommendation")),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Left Column - Emotion Detection UI
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Emotion Detection",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    _isCameraOpen
                        ? SizedBox(
                            width: 200,
                            height: 150,
                            child: _isCameraInitialized
                                ? CameraPreview(_controller!)
                                : Center(child: CircularProgressIndicator()),
                          )
                        : Text("Camera is closed"),
                    SizedBox(height: 10),
                    _isCameraOpen
                        ? ElevatedButton(
                            onPressed: captureImage,
                            child: Text("Capture Image"),
                          )
                        : Container(),
                    SizedBox(height: 10),
                    _imageBytes != null
                        ? Image.memory(_imageBytes!,
                            width: 200, height: 200, fit: BoxFit.cover)
                        : Text("No image captured"),
                    SizedBox(height: 10),
                    _isCameraOpen
                        ? ElevatedButton(
                            onPressed: closeCamera,
                            child: Text("Close Camera"),
                          )
                        : ElevatedButton(
                            onPressed: initializeCamera,
                            child: Text("Open Camera"),
                          ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: pickImageFromGallery,
                      child: Text("Upload Image from Gallery"),
                    ),
                  ],
                ),
              ),

              // Middle Column - Prediction Button and Results
              Container(
                width: 2,
                height: double.infinity,
                color: Colors.grey.shade400,
                margin: EdgeInsets.symmetric(vertical: 20),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: getPrediction,
                      child: Text("Get Prediction"),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 30),
                    _isLoading
                        ? CircularProgressIndicator()
                        : _predictedEmotion != null
                            ? Column(
                                children: [
                                  Text(
                                    "Detected Emotion:",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    _predictedEmotion!.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              )
                            : Container(),
                  ],
                ),
              ),

              // Right Column - Music Recommendation
              Container(
                width: 2,
                height: double.infinity,
                color: Colors.grey.shade400,
                margin: EdgeInsets.symmetric(vertical: 20),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Music Recommendations",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: showRecommendations,
                      child: Text("Get Recommended Song"),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_showRecommendations && _showSongDetails) ...[
                      Text(
                        "Top Recommendation for $_predictedEmotion:",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      if (_songName != null)
                        _buildRecommendationCard({
                          'name': _songName,
                          'artist': _artistName,
                          'image': _albumImageUrl,
                          'link': _songLink,
                        }),
                      SizedBox(height: 20),
                      if (_knnRecommendations.isNotEmpty) ...[
                        Text(
                          "Similar Recommendations:",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _knnRecommendations.length,
                            itemBuilder: (context, index) {
                              return _buildRecommendationCard(
                                  _knnRecommendations[index]);
                            },
                          ),
                        ),
                      ],
                    ] else if (_predictedEmotion != null &&
                        !_showRecommendations) ...[
                      Text(
                        "",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ] else ...[
                      Text(
                        "Get an emotion prediction first",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
