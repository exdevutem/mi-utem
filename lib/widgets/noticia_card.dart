import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';

class NoticiaCard extends StatelessWidget {
  const NoticiaCard(
      {Key? key, this.titulo, this.subtitulo, this.imagenUrl, this.onTap})
      : super(key: key);

  final String? titulo, subtitulo, imagenUrl;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        width: 200,
        child: Card(
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () => this.onTap!(),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          imagenUrl != null
                              ? Image.network(
                                  imagenUrl!,
                                  height: 110,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 110,
                                  width: double.infinity,
                                  color: Colors.grey,
                                  child: Icon(
                                    Mdi.imageOff,
                                    color: Colors.white,
                                  ),
                                ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Spacer(),
                                Text(
                                  titulo!,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Get.theme.textTheme.bodyText1,
                                ),

                                /* Text(
                        subtitulo,
                        overflow: TextOverflow.ellipsis,
                        style: Get.theme.textTheme.bodyText2,
                        maxLines: 2
                      ) */
                                Spacer(),
                              ],
                            ),
                          )
                        ])))));
  }
}
