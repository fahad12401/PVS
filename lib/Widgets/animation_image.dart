import 'package:flutter/material.dart';

class ImageDetails {
  late bool isloaded = false;
  late int cumulativeBytesloaded = 0;
  late int expectedTotalBytes = 1;
}

class ImageValueNotifier extends ValueNotifier<ImageDetails> {
  late ImageDetails _imageDetails;
  ImageValueNotifier(imageDetail) : super(imageDetail) {
    _imageDetails = imageDetail;
  }
  void changeLoadingState(bool isLoaded) {
    _imageDetails.isloaded = isLoaded;
    notifyListeners();
  }

  void ChangeCumulativeBytesloaded(int CumulativeBytesLoaded) {
    _imageDetails.cumulativeBytesloaded = CumulativeBytesLoaded;
    notifyListeners();
  }
}
