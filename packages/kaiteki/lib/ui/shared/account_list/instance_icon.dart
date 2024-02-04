import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/fediverse/instance_prober.dart";

class InstanceIcon extends ConsumerWidget {
  final String host;
  final double? size;

  const InstanceIcon(this.host, {super.key, this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = this.size ?? IconTheme.of(context).size;
    final value = ref.watch(probeInstanceProvider(host));

    return value.when(
      data: (result) {
        final iconUrl = result.instance?.iconUrl;
        if (iconUrl == null) return _buildFallback();
        return Image.network(
          iconUrl.toString(),
          width: size,
          height: size,
          cacheHeight: size?.ceil(),
          cacheWidth: size?.ceil(),
          errorBuilder: (_, __, ___) => _buildFallback(),
          loadingBuilder: (_, child, event) =>
              event == null ? child : _buildFallback(),
        );
      },
      error: (_, __) => _buildFallback(),
      loading: _buildFallback,
    );
  }

  Widget _buildFallback() => Icon(Icons.public_rounded, size: size);
}
