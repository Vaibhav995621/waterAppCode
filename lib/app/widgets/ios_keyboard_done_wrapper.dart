import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A global wrapper widget that attaches a native iOS-styled "Done" accessory toolbar
/// right above the keyboard on iOS devices to easily dismiss/down the keyboard.
class IOSKeyboardDoneWrapper extends StatelessWidget {
  final Widget child;

  const IOSKeyboardDoneWrapper({
    super.key,
    required this.child,
  });

  static const double _toolbarHeight = 44.0;

  @override
  Widget build(BuildContext context) {
    final bool isIOS = (!kIsWeb && Platform.isIOS) ||
        Theme.of(context).platform == TargetPlatform.iOS;

    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardVisible = keyboardHeight > 0;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color barBackground = isDark
        ? const Color(0xFF2C2C2E)
        : const Color(0xFFD2D5DC);
    final Color borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFB5B8BE);
    final Color buttonColor = isDark
        ? const Color(0xFF0A84FF)
        : const Color(0xFF007AFF);

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (isIOS && isKeyboardVisible)
          Positioned(
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            height: _toolbarHeight,
            child: Material(
              color: barBackground,
              elevation: 4.0,
              child: Container(
                height: _toolbarHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: barBackground,
                  border: Border(
                    top: BorderSide(color: borderColor, width: 0.5),
                    bottom: BorderSide(color: borderColor, width: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Icon(
                        CupertinoIcons.chevron_down,
                        size: 20,
                        color: buttonColor.withOpacity(0.85),
                      ),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 6.0,
                      ),
                      minSize: 0,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: buttonColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
