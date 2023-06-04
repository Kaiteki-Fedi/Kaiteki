List<Link> parseLinkHeader(String header) {
  return header.split(',').map((e) {
    final values = e.split(';').map((e) => e.trim());

    final uriValue = values.first;
    if (!uriValue.startsWith('<') || !uriValue.endsWith('>')) {
      throw Exception('Uri does not start or end with <>');
    }

    final uri = Uri.parse(uriValue, 1, uriValue.length - 2);
    final map = Map.fromEntries(
      values.skip(1).map(
        (e) {
          final split = e.split('=');
          return MapEntry(split[0], split[1]);
        },
      ),
    );

    return Link(uri, map);
  }).toList();
}

class Link {
  final Uri reference;
  final Map<String, String> parameters;

  const Link(this.reference, this.parameters);
}
