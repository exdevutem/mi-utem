import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async => false,
      child: LoadingIndicator(
        color: Colors.white,
      )
  );
}

void showLoadingDialog(BuildContext context) => showDialog(context: context, builder: (ctx) => LoadingDialog(), barrierDismissible: false);