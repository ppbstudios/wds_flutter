import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

abstract class IconBuilder {
  const IconBuilder();

  @mustBeOverridden
  Widget build() => throw UnimplementedError();
}
