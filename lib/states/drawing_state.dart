import 'package:flutter/material.dart';

enum DrawingStates { drawing }

int state_(DrawingStates state) {
  return state.index;
}

class DrawingState {
  final DrawingStates _state;
  Map<int, List<Offset>>? _hash = <int, List<Offset>>{};

  DrawingState(this._state) {
    print ("DrawingState.constructor ($_state)");
    _hash?.clear();
  }

  DrawingStates state() {
    return _state;
  }
  
  void setData(Map<int, List<Offset>>? data) {
    _hash = data;
  }

  Map<int, List<Offset>>? data() {
    return _hash;
  }

}
