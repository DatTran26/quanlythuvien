// Ba mốc chiều rộng theo Material 3. Bài: Hoang/01-nen-tang/06-giao-dien-dien-thoai-va-web.md
import 'package:flutter/widgets.dart';

enum ScreenSize { compact, medium, expanded }

extension ScreenSizeX on BuildContext {
  ScreenSize get screenSize {
    final w = MediaQuery.sizeOf(this).width;
    if (w < 600) return ScreenSize.compact; // điện thoại
    if (w < 1024) return ScreenSize.medium; // tablet, cửa sổ trình duyệt hẹp
    return ScreenSize.expanded; // máy tính tại quầy
  }

  bool get isCompact => screenSize == ScreenSize.compact;
  bool get isExpanded => screenSize == ScreenSize.expanded;
}
