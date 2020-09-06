

import 'dart:math';

class Cnt {
  Cnt({
    this.count = 0
  });

  int count;

  static Cnt countForSuggest = Cnt(count: Random().nextInt(20));
}
