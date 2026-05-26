class Skill {
  final String name;
  final double level; // 0.0 to 1.0
  final bool isMissing; // Gap analyzer specific

  Skill({required this.name, required this.level, this.isMissing = false});
}
