import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/controllers/home_controller.dart';

final homeControllerProvider =
    Provider.family<HomeController, BuildContext>((ref, context) {
  return HomeController(ref, context);
});
