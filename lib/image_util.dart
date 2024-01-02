import 'dart:io';
import 'package:image/image.dart';

typedef Tensor4D<num> = List<List<List<List<num>>>>;

Tensor4D<num> toTensor(Image image) {
  int height = image.height;
  int width = image.width;

  List<List<List<num>>> channels = List.generate(3, (channel) {
    return List.generate(height, (y) {
      return List.generate(width, (x) {
        Pixel pix = image.getPixel(x, y);
        switch (channel) {
          case 0:
            return pix.r.toDouble() / 255;
          case 1:
            return pix.g.toDouble() / 255;
          case 2:
            return pix.b.toDouble() / 255;
          default:
            throw ArgumentError('Invalid channel index: $channel');
        }
      });
    });
  });
  return [channels];
}