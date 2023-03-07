import 'package:flutter/material.dart';
abstract class ITransitionMethod {
  void execute([Map<int, List<Offset>>? data]);
}