import 'dart:math';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:ui_practice/custom_widgets/joblist_tile.dart';
import 'package:ui_practice/custom_widgets/list_items_builder.dart';
import 'package:ui_practice/models/job.dart';
import 'package:ui_practice/screens/EditJobPage.dart';
import 'package:ui_practice/services/auth.dart';
import 'package:ui_practice/services/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController controller;
  double maxSlide = 250;
  bool _canBeDragged;
  Animation animation;
  ContainerTransitionType _transitionType=ContainerTransitionType.fade;
  double _fabDimension=56;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
  }

  void toggle() {
    controller.forward();
    print('toggle');
  }

  void toggleback() {
    controller.reverse();
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        controller.isDismissed && details.globalPosition.dx < 60;
    bool isDragCloseFromRight =
        controller.isCompleted && details.globalPosition.dx > 30;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
    print(controller.status);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      controller.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (controller.isDismissed || controller.isCompleted) return;
    if (details.velocity.pixelsPerSecond.dx.abs() >= 365) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      controller.fling(velocity: visualVelocity);
    } else if (controller.value < 0.5) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DataBase>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);

    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Scaffold(
        /* appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Center(child: Text("           Jobs")),
            
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    _buildAlertDialog(context);
                  },
                  child: Text("Sign out"))
            ],
          ),*/

        body: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Stack(children: <Widget>[
                Container(
                  color: Colors.grey[400],
                ),
                Transform.translate(
                    offset: Offset(maxSlide * (controller.value - 1), 0),
                    child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(pi / 2 * (1 - controller.value)),
                        alignment: Alignment.centerRight,
                        child: _buildSideBar())),
                Transform.translate(
                    offset: Offset(maxSlide * controller.value, 0),
                    child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(-pi / 2 * controller.value),
                        alignment: Alignment.centerLeft,
                        child: _buildJobPage(context, user))),
                Transform.translate(
                  offset: Offset(500 * controller.value, 0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 400),
                      _buildContents(context),
                    ],
                  ),
                ),
              ]);
            }),
        floatingActionButton: OpenContainer(
        transitionType: _transitionType,
        transitionDuration: Duration(milliseconds:350),
        openBuilder: (BuildContext context, VoidCallback _) {
          return EditJobPage(database: database,job: null,);
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(56 / 2),
          ),
        ),
        closedColor: Theme.of(context).colorScheme.secondary,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          );
        },
      ),
      ),
    );
  }

  Container _buildSideBar() => Container(
      width: 250,
      color: Colors.yellow,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Flutter Sidebar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: toggleback,
                )
              ],
            ),
            Row(
              children: <Widget>[Icon(Icons.next_week), Text('News')],
            )
          ],
        ),
      ));

  Container _buildJobPage(BuildContext context, User user) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xfff6696c), Color(0xfff89e57)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 25,
                ),
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: toggle,
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  '       JOBS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Container(),
                ),
                FlatButton(
                  child: Text('Logout'),
                  onPressed: () {
                    _buildAlertDialog(context);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Hello, ${user.displayName}.',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'You have many tasks to complete',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Future _buildAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return PlatformAlertDialog(
            title: Text('Logout'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text('Are you sure you want to logout?')],
              ),
            ),
            actions: <Widget>[
              PlatformDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              PlatformDialogAction(
                child: Text('Logout'),
                actionType: ActionType.Preferred,
                onPressed: () {
                  _signOut(context);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<DataBase>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (context, job) => JobListTile(
                  job: job,
                ));
      },
    );
  }
}

/*  Future<void> _createJob(BuildContext context) async {
    try {
      final dataBase = Provider.of<DataBase>(context, listen: false);
      await dataBase.createJob(Job(
        name: 'market',
        ratePerHour: 20,
      ));
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return PlatformAlertDialog(
              title: Text('Operation failed'),
              actions: <Widget>[
                PlatformDialogAction(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text('$e')],
                ),
              ),
            );
          });
    }


    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.menu),
              Text(
                ' JOBS',
                style: TextStyle(fontSize: 25,),
              ),
              FlatButton(
                child: Text('Logout'),
                onPressed: () {
                  _buildAlertDialog(context);
                },
              )
            ],
          ),
  }
  
  
  FloatingActionButton(
          onPressed: () {
            EditJobPage.show(context, database, null);
          },
          child: Icon(Icons.add),
        ),*/
