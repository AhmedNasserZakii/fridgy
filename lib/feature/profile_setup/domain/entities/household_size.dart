enum HouseholdSize {
  one(1, '1'),
  two(2, '2'),
  three(3, '3'),
  four(4, '4'),
  fivePlus(5, '5+');

  const HouseholdSize(this.jsonValue, this.label);

  final int jsonValue;
  final String label;

  int toJson() => jsonValue;
}
