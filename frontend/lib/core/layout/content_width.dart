// Giới hạn chiều rộng nội dung trên màn rộng. Bài: Hoang/01-nen-tang/06-giao-dien-dien-thoai-va-web.md
import 'package:flutter/widgets.dart';

/// Căn giữa nội dung và không cho rộng quá [maxWidth].
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth = 720});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      // heightFactor: 1 -> cao đúng bằng nội dung. Thiếu dòng này, Align giãn hết chiều cao được cấp:
      // bọc thanh nút đáy (bottomNavigationBar) thì thanh nút chiếm cả màn, phần thân bị ép còn 0.
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
