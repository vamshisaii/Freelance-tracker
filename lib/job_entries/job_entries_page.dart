import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:ui_practice/custom_widgets/entries_list_item_builder.dart';
import 'package:ui_practice/job_entries/entry_list_item.dart';
import 'package:ui_practice/job_entries/entry_page.dart';
import 'package:ui_practice/screens/EditJobPage.dart';
import 'package:ui_practice/models/entry.dart';
import 'package:ui_practice/models/job.dart';
import 'package:ui_practice/services/database.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.job});
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final Database database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              PlatformAlertDialog(title: Text('Operation failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Edit',
              style: TextStyle(fontSize: 18.0, color: Colors.black45),
            ),
            onPressed: () => EditJobPage.show(context, database, job),
          ),
        ],
      ),
      body: _buildContent(context, job),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            EntryPage.show(context: context, database: database, job: job),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Job job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 40,),
        Row(
          children: <Widget>[
            SizedBox(
              width: 45,
            ),
            Icon(
              Icons.work,
              color: Colors.blueGrey[400],
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            FutureBuilder<int>(
                future: database.entriesCount(job),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == 1)
                      return Text(
                        '       ${snapshot.data} Entry',
                        style: TextStyle(color: Colors.black26),
                      );
                    return Text(
                      '       ${snapshot.data} Entries',
                      style: TextStyle(color: Colors.black26),
                    );
                  }
                  return Container();
                }),
          ],
        ),
        
        Text(
          '     ${job.name}',
          style: TextStyle(fontSize: 33),
        ),
        SizedBox(height: 20,),
        
        Expanded(
          child: StreamBuilder<List<Entry>>(
            stream: database.entriesStream(job: job),
            builder: (context, snapshot) {
              return EntriesListItemsBuilder<Entry>(
                snapshot: snapshot,
                itemBuilder: (context, entry) {
                  return DismissibleEntryListItem(
                    key: Key('entry-${entry.id}'),
                    entry: entry,
                    job: job,
                    onDismissed: () => _deleteEntry(context, entry),
                    onTap: () => EntryPage.show(
                      context: context,
                      database: database,
                      job: job,
                      entry: entry,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/*Icon(
          Icons.work,
          color: Colors.blueGrey[400],
        ),
        FutureBuilder<int>(
            future: database.entriesCount(job),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == 1)
                  return Text(
                    '    ${snapshot.data} Entry',
                    style: TextStyle(color: Colors.black26),
                  );
                return Text(
                  '    ${snapshot.data} Entries',
                  style: TextStyle(color: Colors.black26),
                );
              }
              return Container();
            }),
        Text(
          '   ${job.name}',
          style: TextStyle(fontSize: 20),
        ),
        Divider(
          color: Colors.blue[300],
        ), */
