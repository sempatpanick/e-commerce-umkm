import 'package:flutter/material.dart';

import '../common/styles.dart';

class CustomImageDialog extends StatelessWidget {
  final String image;
  const CustomImageDialog({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              maxScale: 10,
              child: Image.network(
                "https://e-warung.my.id/assets/users/$image",
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 70.0,
                    color: textColorWhite,
                  );
                },
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.close,
                  color: textColorWhite,
                  shadows: [
                    Shadow(
                        color: Colors.grey[900]!,
                        offset: const Offset(1, 1),
                        blurRadius: 5)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
