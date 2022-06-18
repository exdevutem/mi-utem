import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/imagen_editor_modal.dart';

class ProfilePhoto extends StatefulWidget {
  final double radius;
  final Usuario? usuario;
  final Function(BuildContext, ImageProvider)? onImageTap;
  final Function()? onTap;
  final double borderWidth;
  final Color borderColor;
  final bool editable;
  final Function(String)? onImage;
  ProfilePhoto(
      {Key? key,
      this.onTap,
      this.onImageTap,
      this.radius = 25,
      this.borderColor = Colors.white,
      this.borderWidth = 0.0,
      required this.usuario,
      this.onImage,
      this.editable = false})
      : super(key: key);

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: Stack(
        children: <Widget>[
          CircularProfileAvatar(
            widget.usuario!.fotoUrl ?? "",
            onTap: () => widget.onTap != null && widget.onImageTap == null
                ? widget.onTap
                : null,
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
            initialsText: Text(
              widget.usuario!.iniciales,
              style: TextStyle(
                fontSize: widget.radius * 0.5,
                color: Colors.white,
              ),
            ),
          ),
          if (widget.editable)
            InkWell(
              onTap: () async {
                try {
                  final imagen =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (imagen != null) {
                    Uint8List imagenOriginalBytes =
                        File(imagen.path).readAsBytesSync();

                    Uint8List imagenEditadaBytes = await Get.to(
                      () => ImagenEditorModal(
                        imagenInicial: imagenOriginalBytes,
                        aspectRatio: 1,
                      ),
                    );

                    String imagenEditadaBase64 =
                        base64Encode(imagenEditadaBytes);

                    widget.onImage!(imagenEditadaBase64);
                  } else {
                    Get.snackbar(
                      "Error",
                      "No se pudo obtener la foto",
                      colorText: Colors.white,
                      backgroundColor: Get.theme.primaryColor,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(20),
                    );
                  }
                } catch (e) {
                  print(e);
                  Get.snackbar(
                    "Error",
                    "No se pudo cambiar la foto",
                    colorText: Colors.white,
                    backgroundColor: Get.theme.primaryColor,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.all(20),
                  );
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
                  color: Get.theme.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
