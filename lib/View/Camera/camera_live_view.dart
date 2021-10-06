import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class CameraLiveView extends StatefulWidget {
  final void Function(String) handleDidCaptureImage;

  const CameraLiveView({Key? key, required this.handleDidCaptureImage})
      : super(key: key);

  @override
  CameraLiveViewState createState() => CameraLiveViewState();
}

class CameraLiveViewState extends State<CameraLiveView> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraDescription?>(
        future: this._getCameraDescription(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            setUpCameraDescription(snapshot.data!);
            return _buildLiveView();
          }
          return const SizedBox.shrink();
        });
  }

  void setUpCameraDescription(CameraDescription camera) {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller!.initialize();
  }

  Widget _buildLiveView() {
    return Stack(children: [
      Positioned.fill(
          child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          // If the Future is complete, display the preview.
          if (snapshot.connectionState == ConnectionState.done) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CameraPreview(_controller!));
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      )),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 90,
          child: Center(child: _buildCaptureButton()))
    ]);
  }

  Widget _buildCaptureButton() {
    return IconButton(
      icon: Icon(Icons.camera),
      iconSize: 70,
      color: Colors.white,
      onPressed: () async {
        try {
          // Ensure that the camera is initialized.
          await _initializeControllerFuture;

          // Attempt to take a picture and get the file `image`
          // where it was saved.
          final image = await _controller!.takePicture();

          // If the picture was taken, display it on a new screen.
          widget.handleDidCaptureImage(image.path);
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
    );
  }

  Future<CameraDescription?> _getCameraDescription() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      return cameras.first;
    }
    return null;
  }
}
