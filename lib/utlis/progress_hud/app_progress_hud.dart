import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class AppProgressHUD extends StatelessWidget {
  final Widget child;

  const AppProgressHUD({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      barrierColor: Colors.black.withOpacity(0.3),
      backgroundColor: Colors.red,
      indicatorColor: Colors.white,
      child: child,
    );
  }
}
