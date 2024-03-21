import 'package:flutter/widgets.dart';

class NavigationTab {
  final String label;
  final Widget child;
  final bool initial;

  NavigationTab({
    required this.label,
    required this.child,
    this.initial = false,
  });
}