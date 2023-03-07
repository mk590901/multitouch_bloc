import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawing_bloc.dart';
import 'path_painter.dart';
import 'state_machines/drawing_state_machine.dart';
import 'states/drawing_state.dart';
import 'events/draw_events.dart';
import 'events/event.dart';
import 'velocityHelper/VelocityHelper.dart';

void main() async {
  runApp(const GestureApp());
}

class GestureApp extends StatelessWidget {
  const GestureApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      //home: const GestureHomePage(title: 'Flutter Multi Touch Demo'),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<DrawingBloc>(
            create: (_) => DrawingBloc(DrawingState(DrawingStates.drawing)),
          ),
        ],
        child: GestureHomePage(title: 'Flutter Multi Touch Demo'),
      ),
    );
  }
}

class GestureHomePage extends StatelessWidget {
  GestureHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  Map<int, List<Offset>> hash = <int, List<Offset>>{};

  @override
  Widget build(BuildContext context) {
    AppBar _appBar = AppBar(
      title: Text(title),
    );

    final double _appBarHight = _appBar.preferredSize.height;
    final double _statusBarHeight = MediaQuery.of(context).padding.top;
    final VelocityHelper _velocityHelper = VelocityHelper(8);

    return Scaffold(
      appBar: _appBar,
      body: Listener(
        onPointerDown: (e) {
          traceTouch("D", _velocityHelper, e);
          List<Offset> points = <Offset>[];
          hash[e.pointer] = points;
          Offset point = Offset(
              e.position.dx, e.position.dy - _appBarHight - _statusBarHeight);
          points.add(point);
          redraw(context);
        },
        onPointerMove: (e) {
          bool rc = traceTouch("M", _velocityHelper, e);
          List<Offset>? points = hash[e.pointer];
          if (points != null && rc) {
            Offset point = Offset(
                e.position.dx, e.position.dy - _appBarHight - _statusBarHeight);
            points.add(point);
            redraw(context);
          }
        },
        onPointerUp: (e) {
          traceTouch("U", _velocityHelper, e);
          _velocityHelper.reset();
          hash.remove(e.pointer);
          redraw(context);
        },
        onPointerCancel: (e) {
          traceTouch("C", _velocityHelper, e);
          _velocityHelper.reset();
          hash.remove(e.pointer);
          redraw(context);
        },
        child: BlocBuilder<DrawingBloc, DrawingState>(builder: (ctx, state) {
          return CustomPaint(
            painter: PathPainter.hash(state.data()!), // state.hash !!!!!
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                gradient: const LinearGradient(
                    colors: <Color>[Colors.deepPurple, Colors.white30]),
                border: Border.all(
                  color: Colors.blueGrey,
                  width: 1.0,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void redraw(BuildContext context) {
    Event? event = Drawing();
    Map<int, List<Offset>>? data = hash;
    event.setData(data);
    context.read<DrawingBloc>().add(event);
  }
}

bool traceTouch(String s, VelocityHelper helper, PointerEvent e) {
  bool result = false;
  if (s == "D") {
    helper.init(e.timeStamp.inMilliseconds, e.position.dx, e.position.dy);
  } else {
    double velocity = helper.velocity(
        e.timeStamp.inMilliseconds, e.position.dx, e.position.dy);
    double average = helper.average();
    if (average >= 0.01) {
      result = true;
    }
  }
  return result;
}
