import 'package:flutter/widgets.dart';

import 'supabase_service.dart';

class KidmeBackendScope extends InheritedWidget {
  const KidmeBackendScope({
    super.key,
    required this.service,
    required super.child,
  });

  final SupabaseService service;

  static SupabaseService of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<KidmeBackendScope>();
    assert(scope != null, 'KidmeBackendScope was not found in the widget tree');
    return scope!.service;
  }

  @override
  bool updateShouldNotify(KidmeBackendScope oldWidget) {
    return service != oldWidget.service;
  }
}
