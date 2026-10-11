import 'package:flutter/material.dart';

/// Khóa navigator gốc, để lớp gọi API chuyển sang màn xác thực lại khi gặp 401.
final appNavigatorKey = GlobalKey<NavigatorState>();
