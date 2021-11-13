import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/chat_message.dart';
import 'package:kaiteki/ui/widgets/attachments.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';
import 'package:kaiteki/utils/text/text_renderer_theme.dart';

class ChatMessageClip extends CustomClipper<Path> {
  final ChatMessageNipPosition nipPosition;
  final double nipSize;
  final double rounding;

  ChatMessageClip({
    required this.nipPosition,
    required this.nipSize,
    this.rounding = 0.0,
  });

  @override
  Path getClip(Size size) {
    final maxRounding = math.min(size.width / 2.0, size.height / 2.0);
    final rounding = math.min(maxRounding, this.rounding);
    final radius = Radius.circular(rounding);
    final xx = size.width - nipSize;

    final Path path;

    if (nipPosition == ChatMessageNipPosition.left) {
      path = Path()
        ..lineTo(0, size.height) // bottom left
        ..lineTo(nipSize, size.height - nipSize) // top nip part
        ..lineTo(nipSize, rounding) // top-left curve start
        ..arcToPoint(
          // Top-left
          Offset(rounding, 0),
          radius: radius,
        )
        ..lineTo(size.width - nipSize, 0)
        ..arcToPoint(
          // Top-right
          Offset(size.width, rounding),
          radius: radius,
        )
        ..lineTo(size.width, size.height - rounding)
        ..arcToPoint(
          // Bottom-right
          Offset(size.width - rounding, size.height),
          radius: radius,
        )
        ..lineTo(0, size.height)
        ..close();
    } else if (nipPosition == ChatMessageNipPosition.right) {
      path = Path()
        ..lineTo(rounding, size.height)
        ..arcToPoint(
          // Bottom-left
          Offset(0, size.height - rounding),
          radius: radius,
        )
        ..lineTo(0, rounding)
        ..arcToPoint(
          // Top-left
          Offset(rounding, 0),
          radius: radius,
        )
        ..lineTo(xx - rounding, 0)
        ..arcToPoint(
          // Top-right
          Offset(xx, rounding),
          radius: radius,
        )
        ..lineTo(xx, size.height - nipSize) // Nip
        ..lineTo(size.width, size.height)
        ..lineTo(rounding, size.height)
        ..close();
    } else {
      throw UnimplementedError();
    }

    return path;
  }

  EdgeInsets getPadding({bool withRounding = true}) {
    double left = 0.0;
    double right = 0.0;
    double all = 0.0;

    if (nipPosition == ChatMessageNipPosition.left) {
      left += nipSize;
    } else if (nipPosition == ChatMessageNipPosition.right) {
      right += nipSize;
    } else {
      throw UnimplementedError();
    }

    if (withRounding) {
      all += rounding;
    }

    return EdgeInsets.fromLTRB(left + all, all, right + all, all);
  }

  @override
  bool shouldReclip(covariant ChatMessageClip oldClipper) {
    return rounding != oldClipper.rounding ||
        nipSize != oldClipper.nipSize ||
        nipPosition != oldClipper.nipPosition;
  }
}

enum ChatMessageNipPosition { left, right }

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  final bool received;
  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.received,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messageColor =
        received ? theme.hoverColor : theme.colorScheme.primary;
    final textColor =
        received ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary;

    final renderer = TextRenderer(
      emojis: message.emojis,
      theme: TextRendererTheme.fromContext(context),
    );

    // TODO: Copy Telegram Desktop's adaptive message alignment
    final reverse = !received;
    final mainAxisAlignment =
        reverse ? MainAxisAlignment.end : MainAxisAlignment.start;
    final nipPosition =
        reverse ? ChatMessageNipPosition.right : ChatMessageNipPosition.left;
    final clip = ChatMessageClip(
      nipSize: 8.0,
      rounding: 12.0,
      nipPosition: nipPosition,
    );

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: ifReverse([
        AvatarWidget(
          message.author,
          size: 32.0,
        ),
        const SizedBox(width: 6.0),
        Flexible(
          child: ClipPath(
            clipper: clip,
            child: Container(
              color: messageColor,
              constraints: const BoxConstraints(maxWidth: 450),
              padding: clip.getPadding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.content != null)
                    Text.rich(
                      renderer.renderFromHtml(
                        context,
                        message.content!,
                      ),
                      style: TextStyle(color: textColor),
                    ),
                  if (message.attachments.isNotEmpty == true)
                    getAttachmentWidget(message.attachments.first),
                ],
              ),
            ),
          ),
        ),
      ], reverse),
    );
  }

  List<T> ifReverse<T>(List<T> list, bool condition) {
    if (condition) {
      return list.reversed.toList(growable: false);
    } else {
      return list;
    }
  }
}
