import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_practice/models/job.dart';
import 'package:ui_practice/screens/EditJobPage.dart';
import 'package:ui_practice/services/database.dart';

class JobListTile extends StatefulWidget {
  const JobListTile({Key key, @required this.job,})
      : super(key: key);

  final Job job;
  

  @override
  _JobListTileState createState() => _JobListTileState();
}

class _JobListTileState extends State<JobListTile> {
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DataBase>(context);

    return GestureDetector(
      onVerticalDragEnd: (d) {
        double velocity = d.primaryVelocity;
        if (velocity > 0) database.deleteJob(widget.job);
      },
      child: Container(
        width: 250,
        child: _OpenContainerWrapper(
          closedBuilder: (BuildContext _, VoidCallback openContainer) {
            return _buildCard(openContainer);
          },
          transitionType: _transitionType,
          job: widget.job,
        ),
      ),
    );
  }

  InkWell _buildCard(VoidCallback openContainer) {
    return InkWell(
        onTap: openContainer,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.white70,
              elevation: 10,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 10),
                      Icon(Icons.account_circle),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.mode_edit),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 200),
                  Text(widget.job.name, style: TextStyle(fontSize: 18)),
                ],
              ),
            )));
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper(
      {this.closedBuilder, this.transitionType, this.onClosed, this.job});

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  final Job job;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DataBase>(context, listen: false);
    return OpenContainer<bool>(
      closedColor: Colors.transparent,
      openColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: 500),
      closedElevation: 0,
      openElevation: 0,
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return EditJobPage(
          database: database,
          job: job,
        );
      },
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}

/*ListTile(
      title: Text(job.name),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),


    );
    
    
    transform: Matrix4(((width/250-1)*controller.value+1),0,0,0,
                                                0,((height/350-1)*controller.value+1),0,0,
                                                0,0,1,0,
                                                0,0,0,1),
                                                alignment: FractionalOffset.center,*/
