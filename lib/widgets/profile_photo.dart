import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/image/imagen_editor_modal.dart';
import 'package:mi_utem/widgets/snackbar.dart';

class ProfilePhoto extends StatefulWidget {
  final double radius;
  final String? base64Data;
  final String? fotoUrl;
  final String iniciales;
  final Function(BuildContext, ImageProvider)? onImageTap;
  final Function()? onTap;
  final double borderWidth;
  final Color borderColor;
  final bool editable;
  final Function(String)? onImage;

  ProfilePhoto({
    super.key,
    required this.iniciales,
    this.base64Data,
    this.fotoUrl,
    this.onTap,
    this.onImageTap,
    this.radius = 25,
    this.borderColor = Colors.white,
    this.borderWidth = 0.0,
    this.onImage,
    this.editable = false
  });

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) => Container(
    width: widget.radius * 2,
    height: widget.radius * 2,
    child: Stack(
      children: [
        FutureBuilder<String?>(
          // future: Get.find<PreferencesRepository>().getProfilePicture(),
          initialData: widget.base64Data,
          builder: (ctx, snapshot) => CircularProfileAvatar(snapshot.data != null ? '' : (widget.fotoUrl ?? ""),
            child: snapshot.data != null ? Image.memory(Base64Decoder().convert(snapshot.data!)) : null,
            onTap: () => widget.onTap != null && widget.onImageTap == null ? widget.onTap : null,
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
            radius: widget.radius,
            backgroundColor: MainTheme.primaryColor,
            imageBuilder: (context, imageProvider) => GestureDetector(
              onTap: () {
                if (widget.onImageTap != null) {
                  widget.onImageTap!(context, imageProvider);
                }
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            initialsText: Text(widget.iniciales,
              style: TextStyle(
                fontSize: widget.radius * 0.5,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (widget.editable)
          InkWell(
            onTap: () async {
              try {
                final imagen = await _picker.pickImage(source: ImageSource.gallery);
                if (imagen == null) {
                  showErrorSnackbar(context, "No se pudo obtener la foto");
                  return;
                }

                Uint8List imagenOriginalBytes =
                File(imagen.path).readAsBytesSync();

                Uint8List imagenEditadaBytes = await Navigator.push(context, MaterialPageRoute(builder: (ctx) => ImagenEditorModal(imagenInicial: imagenOriginalBytes, aspectRatio: 1)));

                String imagenEditadaBase64 =
                base64Encode(imagenEditadaBytes);

                widget.onImage!(imagenEditadaBase64);
              } catch (e) {
                logger.e("Error al cambiar la foto", e);
                showErrorSnackbar(context, "No se pudo cambiar la foto");
              }
            },
            borderRadius: BorderRadius.circular(25),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.camera_alt,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
    ),
  );
}
