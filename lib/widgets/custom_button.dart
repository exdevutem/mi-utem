import 'package:flutter/material.dart';

import 'package:tinycolor/tinycolor.dart' as tc;

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    @required this.onPressed,
    this.icon,
    this.outlined = false,
    this.color,
    this.text = ""
  }) : super(key: key);

  final bool outlined;
  final Color color;
  final String text;
  final IconData icon;
  final GestureTapCallback onPressed;
 
  @override
  Widget build(BuildContext context) {
    Color c = this.color != null ? this.color : Theme.of(context).primaryColor;
    if (outlined) {
      return OutlineButton(
        borderSide: BorderSide(
          color: c,
          width: 2
        ),
        onPressed: onPressed,
        shape: const StadiumBorder(),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              this.icon != null ? Icon(
                this.icon,
                color: Colors.white,
              ) : Container(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  this.text.toUpperCase(),
                  maxLines: 1,
                  style: TextStyle(
                    color: c,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return FlatButton(
        color: c,
        
        splashColor: tc.TinyColor(c).darken().color,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              this.icon != null ? Icon(
                this.icon,
                color: Colors.white,
              ) : Container(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  this.text.toUpperCase(),
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          ),
        ),
        onPressed: onPressed,
        
        shape: const StadiumBorder(),
      );
    }
    
  }
}