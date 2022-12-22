import 'dart:io';

import 'package:flutter/foundation.dart';

bool get supportsVideoPlayer => kIsWeb || Platform.isAndroid || Platform.isIOS;
