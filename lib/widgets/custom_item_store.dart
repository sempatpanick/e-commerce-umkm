import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_warung/data/model/list_store_result.dart';
import 'package:e_warung/screen/buyer/detail_store/detail_store_buyer_screen.dart';
import 'package:flutter/material.dart';

import '../common/styles.dart';
import 'custom_image_dialog.dart';

class CustomItemStore extends StatelessWidget {
  final Store store;

  const CustomItemStore({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DetailStoreBuyerScreen.routeName,
            arguments: store);
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(25.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            store.image != null
                ? store.image != ""
                    ? GestureDetector(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) =>
                                CustomImageDialog(image: store.image!)),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20), // Image border
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(35), // Image radius
                            child: Image.network(
                              "https://e-warung.my.id/assets/users/${store.image}",
                              fit: BoxFit.fill,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 70.0,
                                  color: textColorWhite,
                                );
                              },
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: primaryColor,
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                      )
                : Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: primaryColor,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    store.name ?? "",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: textColorBlue,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AutoSizeText(
                    store.address.name ?? "",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Colors.grey[400],
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
