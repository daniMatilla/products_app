import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({Key? key, this.url}) : super(key: key);

  final String? url;

  @override
  Widget build(BuildContext context) {
    return url?.isNotEmpty ?? false
        ? CachedNetworkImage(
            imageUrl: url!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Image.asset(
              'assets/jar-loading.gif',
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => const NoImage(),
          )
        : const NoImage();
  }
}

class NoImage extends StatelessWidget {
  const NoImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Icon(
          Icons.image_outlined,
          color: Colors.black.withOpacity(.05),
          size: constraints.maxHeight * .5,
        );
      },
    );
  }
}
