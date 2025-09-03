library;

import 'package:flutter/widgets.dart';
import 'package:wds_tokens/semantic/wds_semantic_shadow.dart';

class WdsShaows {
  const WdsShaows._();

  static const List<BoxShadow> normal = WdsSemanticShadowNeutral.normal;
  static const List<BoxShadow> emphasize = WdsSemanticShadowNeutral.emphasize;
  static const List<BoxShadow> strong = WdsSemanticShadowNeutral.strong;
  static const List<BoxShadow> heavy = WdsSemanticShadowNeutral.heavy;

  static const List<BoxShadow> normalCoolNeutral =
      WdsSemanticShadowCoolNeutral.normal;
  static const List<BoxShadow> emphasizeCoolNeutral =
      WdsSemanticShadowCoolNeutral.emphasize;
  static const List<BoxShadow> strongCoolNeutral =
      WdsSemanticShadowCoolNeutral.strong;
  static const List<BoxShadow> heavyCoolNeutral =
      WdsSemanticShadowCoolNeutral.heavy;
}
