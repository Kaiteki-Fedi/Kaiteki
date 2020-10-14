import 'package:kaiteki/adapters/fediverse_adapter.dart';

abstract class AdapterResponse<Adapter extends FediverseAdapter> {
  final Adapter source;

  const AdapterResponse(this.source);
}