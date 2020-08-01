import 'package:flutter/material.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:ui_practice/custom_widgets/custom_decorations.dart';
import 'package:ui_practice/models/job.dart';
import 'package:ui_practice/services/database.dart';

class EditJobPage extends StatefulWidget {
  final DataBase database;
  final Job job;
  EditJobPage({Key key, @required this.database, this.job}) : super(key: key);

  static Future<void> show(
      BuildContext context, DataBase database, Job job) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditJobPage(database: database, job: job),
      fullscreenDialog: true,
    ));
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return PlatformAlertDialog(
                    title: Text('Name already used'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Please choose a different job name')
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      PlatformDialogAction(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]);
              });
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(name: _name, ratePerHour: _ratePerHour, id: id);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return PlatformAlertDialog(
                  title: Text('Operation Failed'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[Text(e)],
                    ),
                  ),
                  actions: <Widget>[
                    PlatformDialogAction(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
            elevation: 4,
            title: Center(
                child: Text(widget.job == null ? 'New Job' : 'Edit job')),
            actions: <Widget>[
              FlatButton(
                onPressed: _submit,
                child: Text('Save',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              )
            ]),
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
          elevation: 10,
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
          initialValue: _name,
          validator: (value) =>
              value.isNotEmpty ? null : 'Name can\'t be empty',
          decoration: textfielddecoration.copyWith(
              labelText: 'Job name',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)))),
          onSaved: (value) => _name = value),
      SizedBox(
        height: 20,
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        validator: (value) =>
            value.isNotEmpty ? null : 'rate per hour can\'t be empty',
        decoration: textfielddecoration.copyWith(
            labelText: 'Rate per hour',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)))),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
