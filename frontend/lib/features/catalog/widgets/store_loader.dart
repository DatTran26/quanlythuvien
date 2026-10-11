import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/state_views.dart';
import 'package:frontend/features/catalog/data/catalog_store.dart';

/// Chờ dữ liệu danh mục rồi vẽ phần thân màn.
class StoreLoader extends StatefulWidget {
  const StoreLoader({super.key, required this.builder});

  final Widget Function(BuildContext context, CatalogStore store) builder;

  @override
  State<StoreLoader> createState() => _StoreLoaderState();
}

class _StoreLoaderState extends State<StoreLoader> {
  late Future<CatalogStore> _future = CatalogStore.instance.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CatalogStore>(
      future: _future,
      builder: (context, snap) {
        if (snap.hasError) {
          return ErrorState(
            message: 'Không tải được dữ liệu danh mục.',
            onRetry: () => setState(() => _future = CatalogStore.instance.load()),
          );
        }
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        return widget.builder(context, snap.data!);
      },
    );
  }
}
