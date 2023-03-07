# multitouch_bloc

Flutter in action. Drawing using BLoC

## Introduction

In principle, the approach proposed earlier in previous project (account management -> multi_bloc repository) can be used to solve more prosaic problems. For example, to draw graphical objects using the CustomPaint class. The painter attribute constructor of this class simply needs to contain some data structure that keeps information for rendering the scene. And this data structure must be the parameter of state of the corresponding BLoC class. See below for more details.

## Brief description of the application

The state machine diagram, which describes the drawing process in its most general form, is presented below.

![image](https://user-images.githubusercontent.com/125393245/223510734-0ebcc576-cbc4-4df3-bd85-232e0c96f87e.png)

State machine extremely primitive: it is one single state with one closure on itself when exposed to the of Drawing event. Can use this approach, for example, to draw a multi touch trail. The data structure for drawing is a map in dart terms. The application tracks internal events (not to be confused with BLoC events) of the Listener object: onPointerDown, onPointerMove, onPointerUp and onPointerCancel. The callback onPointerDown adds a single touch point vector to the map. The key is the identifier of touch: event.pointer. onPointerMove adds next point to this vector, and onPointerUp and onPointerCancel remove the event.pointer key (and it’s entry) from the map. The redraw() procedure attaches the map to the event object and makes a call to context.read<DrawingBloc>().add(event). In the procedure "done" of the DrawingBloc class, the data attached to the event is added to the state, and this is where all the wonders end.

## App in action  

https://user-images.githubusercontent.com/125393245/223511760-35951fb9-b563-46a5-84ff-11e4a00a6ca8.mp4

