import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef Reader = T Function<T>(ProviderListenable<T> provider);
