import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_practice/custom_widgets/entries_list_item_builder.dart';
import 'package:ui_practice/entries/entries_list_tile.dart';

import 'package:ui_practice/entries/entries_bloc.dart';

class EntriesPage extends StatelessWidget {
 /* static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Provider<EntriesBloc>(
      create: (_) => EntriesBloc(database: database),
      builder: (context){return EntriesPage();},
      child: EntriesPage(),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              backgroundColor: Colors.blueGrey[400],

        title: Text('Entries'),
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return EntriesListItemsBuilder<EntriesListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) => EntriesListTile(model: model),
        );
      },
    );
  }
}
