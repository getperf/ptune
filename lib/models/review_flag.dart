// lib/models/review_flag.dart
import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum ReviewFlag {
  stuckUnknown,
  toolOrEnvIssue,
  decisionPending,
  scopeExpanded,
  unresolved,
  newIssueFound,
}
