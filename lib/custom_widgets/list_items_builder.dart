import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ui_practice/custom_widgets/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({Key key, this.snapshot, this.itemBuilder})
      : super(key: key);
  @required final AsyncSnapshot<List<T>> snapshot;
  @required final ItemWidgetBuilder<T> itemBuilder;

  

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;

      if (items.isNotEmpty) {
        return _buildList(items,context);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildList(List<T> items,BuildContext context) {
    
    return Container(height: 350,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
              
         
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) => itemBuilder(context, items[index]),
        ),
    );
  }
}
