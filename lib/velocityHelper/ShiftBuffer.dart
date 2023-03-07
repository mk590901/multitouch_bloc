class ShiftBuffer<T> {
  List<T>? _elements;
  int _capacity = 0;

  ShiftBuffer(int capacity) {
    _capacity = capacity;
    _elements = <T>[];
  }

  void reset() {
    _elements!.clear();
  }

  void put(T element) {
    if (_elements!.length == _capacity) {
      _elements!.removeAt(0);
    }
    _elements!.add(element);
  }

  int size() {
    return _elements!.length;
  }

  T? get(int index) {
    T? result;
    if (index >= 0 && index < size()) {
      result = _elements![index];
    }
    return result;
  }

  // void trace() {
  //   String result = "";
  //   for (int i = 0; i < _elements!.length; i++) {
  //     result += "${_elements![i]} ";
  //   }
  //   print("($_elements.length)->[$result]");
  // }
}
