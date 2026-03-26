class MemoryScanEntry {
  const MemoryScanEntry({
    required this.title,
    required this.scannedAt,
    required this.legacyPoints,
  });

  final String title;
  final DateTime scannedAt;
  final int legacyPoints;
}
