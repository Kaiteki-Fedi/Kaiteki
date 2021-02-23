import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/model/fediverse/post.dart';
import 'package:kaiteki/model/fediverse/timeline_type.dart';
import 'package:kaiteki/ui/screens/conversation_screen.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class TimelinePage extends StatefulWidget {
  TimelinePage({Key key}) : super(key: key);

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  Widget build(BuildContext context) {
    var container = Provider.of<AccountContainer>(context);

    if (!container.loggedIn)
      return Center(
        child: IconLandingWidget(
          icon: Mdi.key,
          text: "You need to be signed in to view your timeline"
        )
      );



    return FutureBuilder(
      future: container.adapter.getTimeline(TimelineType.Home),
      builder: (_, AsyncSnapshot<Iterable<Post>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, i) {
              var status = snapshot.data.elementAt(i);

              return StatusWidget(status, onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ConversationScreen(status)));
              });
            }
          );
        } else if (snapshot.hasError) {
          return Center(child: IconLandingWidget(icon: Mdi.close, text: snapshot.error.toString()));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}