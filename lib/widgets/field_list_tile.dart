import 'package:flutter/material.dart';

class FieldListTile extends StatelessWidget {
  final String title;
  final String? value;
  final EdgeInsetsGeometry padding;
  final Widget? suffixIcon;
  final Function()? onTap;

  const FieldListTile({
    super.key,
    required this.title,
    this.value,
    this.padding = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 16,
    ),
    this.suffixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: GestureDetector(
      onTap: onTap,
      behavior: onTap != null ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title.toUpperCase(),
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(value ?? "Sin información",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                if(suffixIcon != null) suffixIcon!,
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
