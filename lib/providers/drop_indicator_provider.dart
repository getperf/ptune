import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/task_row.dart';

final currentDropIndicatorProvider =
    StateProvider<DropIndicator?>((ref) => null);
