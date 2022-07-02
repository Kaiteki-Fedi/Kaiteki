import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/interfaces/report_support.dart';
import 'package:kaiteki/fediverse/model/report.dart';
import 'package:tuple/tuple.dart';

class SubmittedReportsScreen extends ConsumerWidget {
  const SubmittedReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adapter = ref.watch(adapterProvider) as ReportSupport;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submitted Reports'),
      ),
      body: FutureBuilder<List<Report>>(
        future: adapter.getReports(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final reports = snapshot.data!;
            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return ReportWidget(report);
              },
              padding: const EdgeInsets.all(12.0),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ReportWidget extends StatelessWidget {
  final Report report;

  const ReportWidget(this.report, {super.key});

  @override
  Widget build(BuildContext context) {
    final stateColor = _getStateColor(
      report.state,
      Theme.of(context).brightness,
    );
    final primaryColor = Theme.of(context).colorScheme.primary;
    final stateBackgroundColor = stateColor.item1.harmonizeWith(primaryColor);
    final stateForegroundColor = stateColor.item2.harmonizeWith(primaryColor);

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Report against ${report.userId}",
                        style: Theme.of(context).textTheme.headline6,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      backgroundColor: stateBackgroundColor,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                      label: Text(
                        report.state.name,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: stateForegroundColor,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(report.comment),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const ExpansionTile(
                    title: Text("Posts"),
                    children: [
                      Text("😱")
                      //for (final post in report.posts) PostWidget(post),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.event_rounded,
                      size: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      report.createdAt.toIso8601String(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Divider(height: 1),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       TextButton(
          //         onPressed: () {},
          //         child: Text("Manage Report"),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  static Tuple2<Color, Color> _getStateColor(
    ReportState state,
    Brightness brightness,
  ) {
    final isLight = brightness == Brightness.light;

    switch (state) {
      case ReportState.open:
        return isLight
            ? const Tuple2(Color(0xFFffddb3), Color(0xFF291800))
            : const Tuple2(Color(0xFF624000), Color(0xFFffddb3));
      case ReportState.closed:
        return isLight
            ? const Tuple2(Color(0xFFffdad9), Color(0xFF400009))
            : const Tuple2(Color(0xFF920021), Color(0xFFffdad9));
      case ReportState.resolved:
        return isLight
            ? const Tuple2(Color(0xFF62ff96), Color(0xFF00210b))
            : const Tuple2(Color(0xFF005226), Color(0xFF62ff96));
    }
  }
}
