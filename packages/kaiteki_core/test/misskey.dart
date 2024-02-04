import 'dart:developer';

import 'package:kaiteki_core/backends/misskey.dart';
import 'package:test/test.dart';

void main() {
  late MisskeyClient client;
  setUpAll(() {
    client = MisskeyClient('misskey.io');
  });
  test('fetch instance meta', () async {
    final meta = await client.getMeta(detail: true);
    log(
      'We are testing on ${meta.name}, an instance run by ${meta.maintainerName} (${meta.maintainerEmail}), running Misskey ${meta.version}.',
    );
  });
  test('fetch global timeline', () async {
    final notes = await client.getGlobalTimeline(MisskeyTimelineRequest());
    log('Fetched ${notes.length} note(s)');
  });
  test('fetch user profile', () async {
    final user = await client.showUserByName('syuilo');
    log('${user.name} (@${user.username}) - ${_multiLineTrim(user.description)}');
  });
}

String? _multiLineTrim(String? input) {
  if (input == null) return null;
  return input.split('\n').map((l) => l.trim()).join(' ');
}
