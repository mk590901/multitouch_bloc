import '../velocityHelper/ShiftBuffer.dart';

class VelocityHelper {
  int _capacity = 0;

  double _prevX = 0;
  double _prevY = 0;
  double _prevTime = 0;

  double _nextX = 0;
  double _nextY = 0;
  double _nextTime = 0;

  ShiftBuffer<double>? _shiftBuffer;

  VelocityHelper(this._capacity) {
    _shiftBuffer = ShiftBuffer<double>(_capacity);
  }

  void reset() {
    _prevX = 0;
    _prevY = 0;
    _prevTime = 0;

    _nextX = 0;
    _nextY = 0;
    _nextTime = 0;

    _shiftBuffer!.reset();
  }

  void init(int time, double x, double y) {
    _prevX = x;
    _prevY = y;
    _prevTime = time.toDouble();
  }

  double velocity(int time, double x, double y) {
    _nextX = x;
    _nextY = y;
    _nextTime = time.toDouble();

    double dx = _nextX - _prevX;
    double dy = _nextY - _prevY;
    double dt = _nextTime - _prevTime;
    double v = (dx * dx + dy * dy) / dt;

    _prevX = _nextX;
    _prevY = _nextY;
    _prevTime = _nextTime;

    _shiftBuffer!.put(v);

    return v;
  }

  double average() {
    double v = 0;
    int size = _shiftBuffer!.size();
    if (size == 0) return v;
    for (int i = 0; i < size; i++) {
      double? value = _shiftBuffer!.get(i);
      if (value != null) {
        v += value;
      }
    }
    v = v / size.toDouble();
    return v;
  }
}
