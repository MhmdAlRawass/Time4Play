import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final brightnessProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system; 
});