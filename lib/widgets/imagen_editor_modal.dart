import 'dart:async';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_editor/image_editor.dart';

class ImagenEditorModal extends StatefulWidget {
  final Uint8List? imagenInicial;
  final double? maxSize;
  final double? aspectRatio;

  ImagenEditorModal(
      {Key? key, this.imagenInicial, this.maxSize, this.aspectRatio})
      : super(key: key);

  @override
  _ImagenEditorModalState createState() => _ImagenEditorModalState();
}

class _ImagenEditorModalState extends State<ImagenEditorModal> {
  Uint8List? _imagen;

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  /*final List<AspectRatioItem> _aspectRatios = <AspectRatioItem>[
    AspectRatioItem(text: 'custom', value: CropAspectRatios.custom),
    AspectRatioItem(text: 'original', value: CropAspectRatios.original),
    AspectRatioItem(text: '1*1', value: CropAspectRatios.ratio1_1),
    AspectRatioItem(text: '4*3', value: CropAspectRatios.ratio4_3),
    AspectRatioItem(text: '3*4', value: CropAspectRatios.ratio3_4),
    AspectRatioItem(text: '16*9', value: CropAspectRatios.ratio16_9),
    AspectRatioItem(text: '9*16', value: CropAspectRatios.ratio9_16)
  ];
  */
  double? _aspectRatio;

  @override
  void initState() {
    _aspectRatio = widget.aspectRatio ?? CropAspectRatios.custom;
    _imagen = widget.imagenInicial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: new Theme(
        data: Get.theme.copyWith(
          canvasColor: Colors.black.withOpacity(0.5),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.flip,
                  color: Colors.white,
                ),
                label: 'Voltear',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.rotate_left,
                  color: Colors.white,
                ),
                label: 'Rotar',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.restore,
                  color: Colors.white,
                ),
                label: 'Restaurar',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                label: 'Listo',
              ),
            ],
            elevation: 0,
            onTap: (int index) async {
              switch (index) {
                case 0:
                  editorKey.currentState!.flip();
                  break;
                case 1:
                  editorKey.currentState!.rotate(right: false);
                  break;
                case 2:
                  editorKey.currentState!.reset();
                  break;
                default:
                  Uint8List? imagen = await _cropImage();
                  Get.back(result: imagen);
              }
            },
          ),
        ),
      ),
      body: ExtendedImage.memory(
        _imagen!,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        enableLoadState: true,
        extendedImageEditorKey: editorKey,
        initEditorConfigHandler: (ExtendedImageState? state) {
          return EditorConfig(
            maxScale: 8.0,
            initCropRectType: InitCropRectType.imageRect,
            cropRectPadding: EdgeInsets.all(50),
            cropAspectRatio: _aspectRatio,
            editorMaskColorHandler: (context, pointerDown) =>
                Colors.black.withOpacity(0.5),
            cornerColor: Colors.white,
          );
        },
      ),
    );
  }

  Future<Uint8List?> _cropImage() async {
    ExtendedImageEditorState state = editorKey.currentState!;
    EditActionDetails action = editorKey.currentState!.editAction!;

    final Rect? rect = state.getCropRect();

    Uint8List data = state.rawImageData;

    final rotateAngle = action.rotateAngle.toInt();
    final flipHorizontal = action.flipY;
    final flipVertical = action.flipX;
    final img = state.rawImageData;

    ImageEditorOption option = ImageEditorOption();

    if (action.needCrop) option.addOption(ClipOption.fromRect(rect!));

    if (action.needFlip)
      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));

    if (widget.maxSize != null) {
      double ratio;
      if (rect!.width > widget.maxSize! && rect.width > rect.height) {
        ratio = widget.maxSize! / rect.width;
        option.addOption(
          ScaleOption(
              (rect.width * ratio).floor(), (rect.height * ratio).floor()),
        );
      } else if (rect.height > widget.maxSize! && rect.height > rect.width) {
        ratio = widget.maxSize! / rect.height;
        option.addOption(
          ScaleOption(
              (rect.width * ratio).floor(), (rect.height * ratio).floor()),
        );
      }
    }

    if (action.hasRotateAngle) option.addOption(RotateOption(rotateAngle));

    return await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );
  }
}
