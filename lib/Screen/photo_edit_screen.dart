import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_editor/Bloc/draft_bloc.dart';
import 'package:photo_editor/Provider/filter_provider.dart';
import 'package:photo_editor/Model/draft.dart';
import 'package:photo_editor/Model/sticker.dart';
import 'package:photo_editor/View/Camera/camera_live_view.dart';
import 'package:photo_editor/Screen/sticker_select_screen.dart';
import 'package:photo_editor/View/Filter/filter_select_carousel_view.dart';
import 'package:photo_editor/View/Sticker/sticker_view_cell.dart';
import 'package:photo_editor/View/ScalableView/scalable_view.dart';
import 'package:provider/provider.dart';

// Photo editor

@immutable
class PhotoEditScreen extends StatefulWidget {
  final Draft? draft;

  PhotoEditScreen({this.draft});
  PhotoEditScreenState createState() => PhotoEditScreenState();
}

class PhotoEditScreenState extends State<PhotoEditScreen> {
  // Picked image file
  File? _imageFile;

  bool _isShowCameraLiveView = true;

  GlobalKey _captureViewKey = new GlobalKey();

  // Stickers
  double _offSetY = 0;
  bool _isDraggingSticker = false;
  List<Sticker> _stickers = [];

  // Filter
  bool _isShowFilterBar = false;

  @override
  void initState() {
    final draft = widget.draft;
    if (draft != null) {
      loadDraft(draft);
    }
    super.initState();
  }

  void loadDraft(Draft draft) async {
    final path = await absolutePathForImage(draft.path);
    setState(() {
      _imageFile = File(path);
      _isShowCameraLiveView = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = _buildAppBar();
    _offSetY = appBar.preferredSize.height + MediaQuery.of(context).padding.top;
    final body = (_imageFile != null && !_isShowCameraLiveView)
        ? _buildContentView()
        : _buildCameraLiveView();

    return ChangeNotifierProvider(
        create: (context) => FilterProvider(),
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: appBar,
          body: SafeArea(child: body),
        ));
  }

  // App bar with Save draft button and done button for closing filter bar
  AppBar _buildAppBar() {
    return AppBar(
        title: Text(widget.draft == null ? "New photo" : "Edit"),
        backgroundColor: Colors.black,
        actions: [
          if (_isShowFilterBar)
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(color: Colors.white),
              ),
              onPressed: () => setState(() => this._toggleFilterBar()),
              child: const Text("Done"),
            )
          else if (_imageFile != null)
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(color: Colors.white),
              ),
              onPressed: () => this._saveDraft(),
              child: const Text("Save"),
            )
        ]);
  }

  // Content view when editting image with tool bar
  Widget _buildContentView() {
    return Stack(children: [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 90,
        child: _buildEditView(),
      ),
      Positioned(
          left: 0, right: 0, bottom: 0, height: 90, child: _buildBottomBar())
    ]);
  }

  // Editing area with image view and stickers
  Widget _buildEditView() {
    return Stack(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: RepaintBoundary(
              key: _captureViewKey,
              child: Stack(
                  children: [_buildImageView(), ..._buildStickersView()]))),
      if (_isDraggingSticker)
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 20.0,
          child: _buildDeleteDragTarget(),
        )
    ]);
  }

  // Widget to show image
  Widget _buildImageView() {
    return Consumer<FilterProvider>(
      builder: (context, filter, child) {
        final color = filter.color;
        return Positioned.fill(
            child: Image.file(
          _imageFile!,
          fit: BoxFit.cover,
          color: color.withOpacity(0.5),
          colorBlendMode: BlendMode.color,
        ));
      },
    );
  }

  Widget _buildCameraLiveView() {
    return Stack(children: [
      Positioned.fill(child: CameraLiveView(handleDidCaptureImage: (path) {
        setState(() {
          _isShowCameraLiveView = false;
          _imageFile = File(path);
        });
      })),
      Positioned(
          bottom: 20,
          left: 20,
          child: Center(
              child: IconButton(
                  icon: const Icon(Icons.photo_size_select_actual_outlined),
                  color: Colors.white,
                  onPressed: () => this._showImagePicker())))
    ]);
  }

  // Sticker views
  List<Widget> _buildStickersView() {
    final List<Widget> cell = _stickers.map((sticker) {
      var stickerView = ScalableView(child: StickerViewCell(sticker));
      return Positioned(
          left: sticker.offset.dx,
          top: sticker.offset.dy,
          child: Draggable(
              maxSimultaneousDrags: 1,
              feedback: stickerView,
              child: stickerView,
              childWhenDragging: SizedBox.shrink(),
              onDragStarted: () {
                setState(() {
                  _isDraggingSticker = true;
                });
              },
              onDragEnd: (details) {
                _isDraggingSticker = false;
              },
              onDragCompleted: () {
                setState(() {
                  _stickers.remove(sticker);
                });
              },
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                setState(() =>
                    sticker.offset = Offset(offset.dx, offset.dy - _offSetY));
              }));
    }).toList();
    return cell;
  }

  // Drag sticker into delete area
  Widget _buildDeleteDragTarget() {
    return DragTarget(
        builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) =>
            Center(
                child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                        width: 2,
                        color: Colors.red,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Icon(Icons.delete, color: Colors.red))),
        onWillAccept: (data) {
          return true;
        });
  }

  // Bottom bar
  Widget _buildBottomBar() {
    if (_isShowFilterBar) return _buildFilterSelectionBar();
    if (_imageFile != null) return _buildToolBar();
    return SizedBox.shrink();
  }

  Widget _buildFilterSelectionBar() {
    return FilterSelector();
  }

  Widget _buildToolBar() {
    List<Widget> buttons = [
      IconButton(
        icon: const Icon(Icons.photo_size_select_actual_outlined,
            color: Colors.white),
        onPressed: () => this._showImagePicker(),
      ),
      IconButton(
        icon: const Icon(Icons.photo_camera_outlined, color: Colors.white),
        onPressed: () => this._showCamera(),
      ),
      IconButton(
        icon: const Icon(Icons.auto_awesome_outlined, color: Colors.white),
        onPressed: () => this._toggleFilterBar(),
      ),
      IconButton(
        icon: const Icon(Icons.stars_outlined, color: Colors.white),
        onPressed: () => this._showStickerScreen(),
      ),
      IconButton(
        icon: const Icon(Icons.file_download_outlined, color: Colors.white),
        onPressed: () => this._saveImageToDeviceGallery(),
      )
    ];

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: buttons);
  }

  // Tool bar buttons's action
  Future<void> _showImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image?.path != null) {
      setState(() {
        _isShowCameraLiveView = false;
        _imageFile = File(image!.path);
      });
    }
  }

  void _showCamera() {
    setState(() {
      _isShowCameraLiveView = true;
    });
  }

  void _toggleFilterBar() {
    setState(() {
      _isShowFilterBar = !_isShowFilterBar;
    });
  }

  void _showStickerScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => StickerSelectScreen((sticker) => setState(() {
                  RenderBox box = _captureViewKey.currentContext
                      ?.findRenderObject() as RenderBox;
                  sticker.offset =
                      Offset(box.size.width / 2 - 50, box.size.height / 2 - 50);
                  _stickers.add(sticker);
                }))));
  }

  // Generate image
  Future<Uint8List> get _generateCurrentDraftImage async {
    try {
      RenderRepaintBoundary boundary = _captureViewKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();
      return bytes!;
    } catch (e) {
      throw Exception();
    }
  }

  // Save image to gallery
  void _saveImageToDeviceGallery() async {
    Uint8List data = await _generateCurrentDraftImage;
    final result = await ImageGallerySaver.saveImage(data,
        quality: 60, name: nameForNewImage());

    if (result != null && result["isSuccess"] == true) {
      // Show snackbar
      final snackBar = SnackBar(content: Text('Saved to gallery!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Save image to document directory then save draft with image info to database
  void _saveDraft() async {
    // Capture current image
    Uint8List data = await _generateCurrentDraftImage;

    // Generate file path for new image
    final name = nameForNewImage();
    final path = await absolutePathForImage(name);

    // Save image file
    File(path).writeAsBytes(data).whenComplete(() {
      print("Saved: $path");

      // Create draft and save to DB
      final draft = Draft(name);

      final draftProvider =
          BlocProvider.of<DraftsCubit>(context, listen: false);
      draftProvider.addDraft(draft);

      // Show snackbar
      final snackBar = SnackBar(content: Text('Saved draft!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
