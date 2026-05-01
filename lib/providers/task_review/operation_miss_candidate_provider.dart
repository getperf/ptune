import 'package:flutter_riverpod/flutter_riverpod.dart';

final operationMissCandidateTaskIdsProvider = StateProvider<Set<String>>(
  (ref) => const <String>{},
);
