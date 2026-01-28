// lib/models/review_flag.dart
import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum ReviewFlag {
  operationMiss,
  toolOrEnvIssue,
  decisionPending,
  scopeExpanded,
  unresolved,
  newIssueFound,
}
