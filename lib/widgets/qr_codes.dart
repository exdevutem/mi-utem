import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class QRCodes extends StatelessWidget {
  const QRCodes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 30.0),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            children: [Text("PERMISOS ACTIVOS"), Text("Ver Todos")],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        CarouselSlider.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int i, int rI) => QRCard(),
          options: CarouselOptions(
            height: 175,
            initialPage: 0,
            autoPlay: false,
            viewportFraction: 0.9,
            enableInfiniteScroll: false,
            pageSnapping: true,
            disableCenter: true,
          ),
        )
      ]),
    );
  }
}

class QRCard extends StatelessWidget {
  const QRCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 175,
      child: Card(
        child: Material(color: Colors.white),
      ),
    );
  }
}
