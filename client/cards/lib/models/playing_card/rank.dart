class Rank {
  int value;

  Rank(this.value);

  static final two = Rank(2);
  static final three = Rank(3);
  static final four = Rank(4);
  static final five = Rank(5);
  static final six = Rank(6);
  static final seven = Rank(7);
  static final eight = Rank(8);
  static final nine = Rank(9);
  static final ten = Rank(10);
  static final jack = Rank(11);
  static final queen = Rank(12);
  static final king = Rank(13);
  static final ace = Rank(14);

  @override
  toString() {
    switch (value) {
      case 11:
        return 'J';
      case 12:
        return 'Q';
      case 13:
        return 'K';
      case 14:
        return 'A';
      default:
        return value.toString();
    }
  }
}
