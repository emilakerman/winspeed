import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:winspeed/enums/window_size_enum.dart';
import 'package:winspeed/providers/window_size_provider.dart';

void actionChangeWindowSize({
  required WindowSizeEnum windowSizeEnum,
  required WidgetRef ref,
}) async {
  //Update window size
  await windowManager.setSize(
    Size(
      windowSizeEnum.width,
      windowSizeEnum.height,
    ),
  );
  //Read provider and change status
  ref.read(windowSizeProvider.notifier).changeSize(
        WindowSize(
          width: windowSizeEnum.width,
          height: windowSizeEnum.height,
        ),
      );
}
