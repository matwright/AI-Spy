import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'spied_model.g.dart';

@HiveType(typeId: 0)
class SpiedModel{

  @HiveField(0)
  Map rect;
  @HiveField(1)
  String word;
  @HiveField(2)
  var aspectRatio;
  @HiveField(3)
  Uint8List finalImage;
  SpiedModel(this.rect,this.word,this.finalImage,this.aspectRatio);
}