enum LifeActionType {
  inheritance,
  housingReuse,
  legacyArchive,
  wellnessWalk,
}

class LifeAction {
  const LifeAction({
    required this.title,
    required this.description,
    required this.type,
  });

  final String title;
  final String description;
  final LifeActionType type;
}
