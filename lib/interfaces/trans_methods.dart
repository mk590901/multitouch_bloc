import 'package:flutter/material.dart';
import 'i_transition_method.dart';

class OnNothing implements ITransitionMethod {
  @override
  void execute([ Map<int, List<Offset>>? hashMap]) {
    //print ("@OnNothing $hashMap");
  }
}
