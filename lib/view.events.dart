import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:calendar/core.dart';

class EventsView extends StatelessWidget {
  EventsView({
    @required int this.year,
    @required int this.month,
    @required Day this.day,
    @required ViewCallback this.switchViewCallback
  });

  final int year;
  final int month;
  final Day day;
  final ViewCallback switchViewCallback;
  ThemeData _theme;
  var _scaffold;

  Widget _generateEventsViewHeader() {
    return new Container(
      margin: new EdgeInsets.only(top: 12.0),
      child: new Text('Day: ' + MonthNames[month]['long'] + ' ${day.date}, $year')
    );
  }

  Widget _generateEventsViewBody() {
    Block component = new Block(
      children: day.getEvents().map(_buildEventsViewBodyItem).toList()
    );
    return new Flexible(child: component);
  }

  Widget _buildEventsViewBodyItem(CalendarEvent item) {
    Widget component = new Dismissable(
      key: new ObjectKey(item),
      direction: DismissDirection.horizontal,
      onDismissed: (DismissDirection direction) {
        final String action = (direction == DismissDirection.startToEnd) ? 'right' : 'left';
        _scaffold.showSnackBar(new SnackBar(
          content: new Text('You swiped ${action} on ${item.title}'),
          action: new SnackBarAction(
            label: 'GOODJOB',
            onPressed: () {}
          )
        ));
      },
      background: new Container(
        decoration: new BoxDecoration(backgroundColor: _theme.primaryColor),
        child: new ListItem(
          leading: new Icon(Icons.input, color: Colors.white, size: 36.0)
        )
      ),
      secondaryBackground: new Container(
        decoration: new BoxDecoration(backgroundColor: _theme.primaryColor),
        child: new ListItem(
          trailing: new Icon(Icons.info, color: Colors.white, size: 36.0)
        )
      ),
      child: new Container(
        decoration: new BoxDecoration(
          backgroundColor: _theme.canvasColor,
          border: new Border(bottom: new BorderSide(color: _theme.dividerColor))
        ),
        child: new ListItem(
          title: new Text('${item.title}'),
          subtitle: new Text('url: ${item.url}'),
          isThreeLine: true
        )
      )
    );
    return component;
  }

  Widget _generateEventsViewFooter() {
    Widget component = new Container(
      padding: new EdgeInsets.all(8.0),
      margin: new EdgeInsets.only(top: 8.0, bottom: 12.0),
      child: new RaisedButton(
        child: new Text('back to calendar'),
        onPressed: () {
          switchViewCallback(
            view: RenderableView.calendar
          );
        }
      )
    );
    return component;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    _scaffold = Scaffold.of(context);
    Widget component = new Container(
      constraints: new BoxConstraints(),
      child: new Center(
        child: new Column(
          children: <Widget>[
            _generateEventsViewHeader(),
            _generateEventsViewBody(),
            _generateEventsViewFooter()
          ]
        )
      )
    );
    return component;
  }
}