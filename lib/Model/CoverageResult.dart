class CoverageResult {
  final bool covered;
  final int? zoneId;
  final String? zoneName;
  final String? message;

  CoverageResult({
    required this.covered,
    this.zoneId,
    this.zoneName,
    this.message,
  });

  factory CoverageResult.fromJson(Map<String, dynamic> j) => CoverageResult(
        covered: j['covered'] == true,
        zoneId: j['zoneId'] as int?,
        zoneName: j['zoneName']?.toString(),
        message: j['message']?.toString(),
      );
}
