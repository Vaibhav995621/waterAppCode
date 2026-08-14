import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final String? tag;
  final bool isCircle;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    this.title,
    this.tag,
    this.isCircle = false,
  });

  /// Opens the full-screen interactive image viewer
  static void open(
    BuildContext context, {
    required String imageUrl,
    String? title,
    String? tag,
    bool isCircle = false,
  }) {
    final cleanUrl = imageUrl.trim();
    if (cleanUrl.isEmpty || cleanUrl == "null" || cleanUrl == "N/A") {
      return;
    }
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.92),
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) => FullScreenImageViewer(
          imageUrl: cleanUrl,
          title: title,
          tag: tag,
          isCircle: isCircle,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          /// Tap background to dismiss
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          /// Interactive zoom & pan image
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(40),
              child: tag != null && tag!.isNotEmpty
                  ? Hero(
                      tag: tag!,
                      child: _buildImageContent(),
                    )
                  : _buildImageContent(),
            ),
          ),

          /// Top Bar with Title and Close Button
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null && title!.isNotEmpty)
                    Expanded(
                      child: Text(
                        title!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black87,
                              blurRadius: 8,
                            )
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    final bool isNetworkUrl = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (isCircle) {
      ImageProvider imageProvider;
      if (isNetworkUrl) {
        imageProvider = NetworkImage(imageUrl);
      } else {
        imageProvider = FileImage(File(imageUrl));
      }
      return CircleAvatar(
        radius: 150,
        backgroundColor: Colors.grey.shade900,
        backgroundImage: imageProvider,
      );
    }

    Widget imageWidget;
    if (isNetworkUrl) {
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            width: 200,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: Colors.white70),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    } else {
      imageWidget = Image.file(
        File(imageUrl),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageWidget,
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.broken_image_rounded, color: Colors.white54, size: 54),
          SizedBox(height: 10),
          Text(
            "Failed to load image",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
