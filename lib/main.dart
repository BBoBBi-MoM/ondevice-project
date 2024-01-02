import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'image_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // String imgPath = 'assets/test.png';
  // image_lib.Image image = image_lib.decodeImage(File(imgPath).readAsBytesSync())!;
  final ByteData data = await rootBundle.load('assets/test.png');
  final Uint8List bytes = data.buffer.asUint8List();
  image_lib.Image image = image_lib.decodeImage(Uint8List.fromList(bytes))!.convert(numChannels: 3);
  image_lib.Image resizedImage = image_lib.copyResize(
      image,
      height: 1024,
      width: 1024,
      interpolation: image_lib.Interpolation.linear);
  Tensor4D inputTensor = toTensor(resizedImage);
  // print(tensor);
  //1, 256 64, 64
  Tensor4D outputTensor = List.generate(1, (i) =>
      List.generate(256, (j) =>
          List.generate(64, (k) =>
              List.generate(64, (l) => 0.0)
          )
      )
  );
  var output = List.filled(1*256*64*64, 0.0).reshape([1, 256, 64, 64]);

  final samEncoder = await Interpreter.fromAsset('assets/models/vit_b_encoder.tflite');
  print('encoder load success!!!');
  samEncoder.allocateTensors();
  samEncoder.invoke();
  samEncoder.run(inputTensor, outputTensor);
  print(outputTensor);
  // final samDecoder = await Interpreter.fromAsset('assets/models/vit_b_decoder.tflite');
  // print('decoder load success!!!');
}