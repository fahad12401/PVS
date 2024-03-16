import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../animation_image.dart';

class CustomImage extends StatefulWidget {
  final String image;
  const CustomImage({super.key, required this.image});

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage>
    with SingleTickerProviderStateMixin {
  late ImageStream _imageStream;
  late ImageInfo _imageInfo;
  late ImageDetails _imageDetails;
  late ImageValueNotifier _imageValueNotifier;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation = Tween(begin: 100.0, end: 200.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.bounceOut));
    _imageDetails = ImageDetails();
    _imageValueNotifier = ImageValueNotifier(_imageDetails);
    _imageStream = AssetImage(widget.image).resolve(const ImageConfiguration());
    _imageStream.addListener(ImageStreamListener((info, value) {
      _imageInfo = info;
      _imageValueNotifier.changeLoadingState(true);
      _animationController.forward();
    }, onChunk: (event) {
      _imageDetails.expectedTotalBytes = event.expectedTotalBytes!;
      _imageValueNotifier.ChangeCumulativeBytesloaded(
          event.cumulativeBytesLoaded);
    }));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _imageValueNotifier,
        builder: (context, ImageDetails value, child) {
          return Center(
            child: Container(
                height: 150,
                width: 300,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: !value.isloaded
                    ? Center(
                        child: SpinKitCircle(color: Colors.white, size: 40.0))
                    : Center(
                        child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return OverflowBox(
                            child: SizedBox(
                              height: _animation.value,
                              width: _animation.value,
                              child: child,
                            ),
                          );
                        },
                        child: Center(
                          child: RawImage(
                            image: _imageInfo.image,
                          ),
                        ),
                      ))),
          );
        });
  }
}
