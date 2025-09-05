import 'package:flutter/material.dart';

class PerformanceUtils {
  static void optimizeListView({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    ScrollController? controller,
  }) {
    // Use ListView.builder for better performance with large lists
    // Consider using ListView.separated if you need separators
    // Use AutomaticKeepAliveClientMixin for items that should stay alive
  }

  static Widget buildOptimizedCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double? elevation,
    VoidCallback? onTap,
    BorderRadius? borderRadius,
  }) {
    return Card(
      elevation: elevation ?? 4.0,
      margin: margin ?? const EdgeInsets.all(8.0),
      color: color ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }

  static void preloadImages(BuildContext context, List<String> imagePaths) {
    // Preload images for better performance
    for (String path in imagePaths) {
      precacheImage(AssetImage(path), context);
    }
  }

  static Widget buildShimmerLoading() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const SizedBox(
        height: 100,
        width: double.infinity,
      ),
    );
  }

  static void clearTextControllers(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      controller.clear();
    }
  }

  static void disposeControllers(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      controller.dispose();
    }
  }
}
