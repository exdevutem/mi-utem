import 'package:flutter/material.dart';

import 'package:mi_utem/themes/theme.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
  })  : preferredSize = Size.fromHeight(toolbarHeight ??
            kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)),
        super(
          key: key,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: title,
          actions: actions,
          bottom: bottom,
          elevation: elevation,
          shape: shape,
          backgroundColor: backgroundColor,
          iconTheme: iconTheme,
          actionsIconTheme: actionsIconTheme,
          primary: primary,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  MainTheme.utemAzul,
                  MainTheme.utemVerde,
                ],
              ),
            ),
          ),
          toolbarTextStyle: textTheme?.bodyText2,
          titleTextStyle: textTheme?.headline6,
        );

  /// A widget to display before the [title].
  ///
  /// Typically the [leading] widget is an [Icon] or an [IconButton].
  ///
  /// Becomes the leading component of the [NavigationToolbar] built
  /// by this widget. The [leading] widget's width and height are constrained to
  /// be no bigger than [leadingWidth] and [toolbarHeight] respectively.
  ///
  /// If this is null and [automaticallyImplyLeading] is set to true, the
  /// [AppBar] will imply an appropriate widget. For example, if the [AppBar] is
  /// in a [Scaffold] that also has a [Drawer], the [Scaffold] will fill this
  /// widget with an [IconButton] that opens the drawer (using [Icons.menu]). If
  /// there's no [Drawer] and the parent [Navigator] can go back, the [AppBar]
  /// will use a [BackButton] that calls [Navigator.maybePop].
  ///
  /// {@tool snippet}
  ///
  /// The following code shows how the drawer button could be manually specified
  /// instead of relying on [automaticallyImplyLeading]:
  ///
  /// ```dart
  /// CustomAppBar(
  ///   leading: Builder(
  ///     builder: (BuildContext context) {
  ///       return IconButton(
  ///         icon: const Icon(Icons.menu),
  ///         onPressed: () { Scaffold.of(context).openDrawer(); },
  ///         tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
  ///       );
  ///     },
  ///   ),
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// The [Builder] is used in this example to ensure that the `context` refers
  /// to that part of the subtree. That way this code snippet can be used even
  /// inside the very code that is creating the [Scaffold] (in which case,
  /// without the [Builder], the `context` wouldn't be able to see the
  /// [Scaffold], since it would refer to an ancestor of that widget).
  ///
  /// See also:
  ///
  ///  * [Scaffold.appBar], in which an [AppBar] is usually placed.
  ///  * [Scaffold.drawer], in which the [Drawer] is usually placed.
  final Widget? leading;

  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [leading] is null, automatically try to deduce what the leading
  /// widget should be. If false and [leading] is null, leading space is given to [title].
  /// If leading widget is not null, this parameter has no effect.
  final bool automaticallyImplyLeading;

  /// The primary widget displayed in the app bar.
  ///
  /// Typically a [Text] widget that contains a description of the current
  /// contents of the app.
  ///
  /// Becomes the middle component of the [NavigationToolbar] built by this widget.
  /// The [title]'s width is constrained to fit within the remaining space
  /// between the toolbar's [leading] and [actions] widgets. Its height is
  /// _not_ constrained. The [title] is vertically centered and clipped to fit
  /// within the toolbar, whose height is [toolbarHeight]. Typically this
  /// isn't noticeable because a simple [Text] [title] will fit within the
  /// toolbar by default. On the other hand, it is noticeable when a
  /// widget with an intrinsic height that is greater than [toolbarHeight]
  /// is used as the [title]. For example, when the height of an Image used
  /// as the [title] exceeds [toolbarHeight], it will be centered and
  /// clipped (top and bottom), which may be undesirable. In cases like this
  /// the height of the [title] widget can be constrained. For example:
  ///
  /// ```dart
  /// MaterialApp(
  ///   home: Scaffold(
  ///     appBar: CustomAppBar(
  ///        title: SizedBox(
  ///        height: toolbarHeight,
  ///        child: child: Image.asset(logoAsset),
  ///      ),
  ///      toolbarHeight: toolbarHeight,
  ///   ),
  /// )
  /// ```
  final Widget? title;

  /// Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [IconButton]s representing common operations.
  /// For less common operations, consider using a [PopupMenuButton] as the
  /// last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built
  /// by this widget. The height of each action is constrained to be no bigger
  /// than the [toolbarHeight].
  final List<Widget>? actions;

  /// This widget is stacked behind the toolbar and the tab bar. It's height will
  /// be the same as the app bar's overall height.
  ///
  /// A flexible space isn't actually flexible unless the [AppBar]'s container
  /// changes the [AppBar]'s size. A [SliverAppBar] in a [CustomScrollView]
  /// changes the [AppBar]'s height when scrolled.
  ///
  /// Typically a [FlexibleSpaceBar]. See [FlexibleSpaceBar] for details.
  //final Widget flexibleSpace;

  /// This widget appears across the bottom of the app bar.
  ///
  /// Typically a [TabBar]. Only widgets that implement [PreferredSizeWidget] can
  /// be used at the bottom of an app bar.
  ///
  /// See also:
  ///
  ///  * [PreferredSize], which can be used to give an arbitrary widget a preferred size.
  final PreferredSizeWidget? bottom;

  /// The z-coordinate at which to place this app bar relative to its parent.
  ///
  /// This controls the size of the shadow below the app bar.
  ///
  /// The value is non-negative.
  ///
  /// If this property is null, then [AppBarTheme.elevation] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the default value
  /// is 4.
  final double? elevation;

  /// The color to paint the shadow below the app bar.
  ///
  /// If this property is null, then [AppBarTheme.shadowColor] of
  /// [ThemeData.appBarTheme] is used. If that is also null, the default value
  /// is fully opaque black.
  final Color? shadowColor;

  /// The material's shape as well its shadow.
  ///
  /// A shadow is only displayed if the [elevation] is greater than
  /// zero.
  final ShapeBorder? shape;

  /// The color to use for the app bar's material. Typically this should be set
  /// along with [brightness], [iconTheme], [textTheme].
  ///
  /// If this property is null, then [AppBarTheme.backgroundColor] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then
  /// [ThemeData.primaryColor] is used.
  final Color? backgroundColor;

  /// The brightness of the app bar's material. Typically this is set along
  /// with [backgroundColor], [iconTheme], [textTheme].
  ///
  /// If this property is null, then [AppBarTheme.systemOverlayStyle] of
  /// [ThemeData.appBarTheme] is used.
  final Brightness? brightness;

  /// The color, opacity, and size to use for app bar icons. Typically this
  /// is set along with [backgroundColor], [brightness], [textTheme].
  ///
  /// If this property is null, then [AppBarTheme.iconTheme] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then
  /// [ThemeData.primaryIconTheme] is used.
  final IconThemeData? iconTheme;

  /// The color, opacity, and size to use for the icons that appear in the app
  /// bar's [actions]. This should only be used when the [actions] should be
  /// themed differently than the icon that appears in the app bar's [leading]
  /// widget.
  ///
  /// If this property is null, then [AppBarTheme.actionsIconTheme] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then this falls
  /// back to [iconTheme].
  final IconThemeData? actionsIconTheme;

  /// The typographic styles to use for text in the app bar. Typically this is
  /// set along with [brightness] [backgroundColor], [iconTheme].
  ///
  /// If this property is null, then [AppBarTheme.textTheme] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then
  /// [ThemeData.primaryTextTheme] is used.
  final TextTheme? textTheme;

  /// Whether this app bar is being displayed at the top of the screen.
  ///
  /// If true, the app bar's toolbar elements and [bottom] widget will be
  /// padded on top by the height of the system status bar. The layout
  /// of the [flexibleSpace] is not affected by the [primary] property.
  final bool primary;

  /// Whether the title should be centered.
  ///
  /// If this property is null, then [AppBarTheme.centerTitle] of
  /// [ThemeData.appBarTheme] is used. If that is also null, then value is
  /// adapted to the current [TargetPlatform].
  final bool? centerTitle;

  /// Whether the title should be wrapped with header [Semantics].
  ///
  /// Defaults to false.
  final bool excludeHeaderSemantics;

  /// The spacing around [title] content on the horizontal axis. This spacing is
  /// applied even if there is no [leading] content or [actions]. If you want
  /// [title] to take all the space available, set this value to 0.0.
  ///
  /// Defaults to [NavigationToolbar.kMiddleSpacing].
  final double titleSpacing;

  /// How opaque the toolbar part of the app bar is.
  ///
  /// A value of 1.0 is fully opaque, and a value of 0.0 is fully transparent.
  ///
  /// Typically, this value is not changed from its default value (1.0). It is
  /// used by [SliverAppBar] to animate the opacity of the toolbar when the app
  /// bar is scrolled.
  final double toolbarOpacity;

  /// How opaque the bottom part of the app bar is.
  ///
  /// A value of 1.0 is fully opaque, and a value of 0.0 is fully transparent.
  ///
  /// Typically, this value is not changed from its default value (1.0). It is
  /// used by [SliverAppBar] to animate the opacity of the toolbar when the app
  /// bar is scrolled.
  final double bottomOpacity;

  /// A size whose height is the sum of [toolbarHeight] and the [bottom] widget's
  /// preferred height.
  ///
  /// [Scaffold] uses this size to set its app bar's height.
  @override
  final Size preferredSize;

  /// Defines the height of the toolbar component of an [AppBar].
  ///
  /// By default, the value of `toolbarHeight` is [kToolbarHeight].
  final double? toolbarHeight;

  /// Defines the width of [leading] widget.
  ///
  /// By default, the value of `leadingWidth` is 56.0.
  final double? leadingWidth;
}
