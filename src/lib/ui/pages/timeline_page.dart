import 'package:flutter/material.dart';
import 'package:kaiteki/account_container.dart';
import 'package:kaiteki/api/clients/mastodon_client.dart';
import 'package:kaiteki/api/clients/pleroma_client.dart';
import 'package:kaiteki/api/model/mastodon/status.dart';
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
          Mdi.key,
          "You need to be signed in to view your timeline"
        )
      );

    if (!(container.client is PleromaClient))
      return Center(
        child: IconLandingWidget(
          Mdi.emoticonSad,
          "Unsupported client"
        )
      );

    var pleroma = container.client as PleromaClient;

    return FutureBuilder(
      future: pleroma.getTimeline(),
      builder: (_, AsyncSnapshot<Iterable<Status>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, i) {
              var status = snapshot.data.elementAt(i);

              return StatusWidget(status);
            }
          );
        } else if (snapshot.hasError) {
          return Center(child: IconLandingWidget(Mdi.close, snapshot.error.toString()));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}