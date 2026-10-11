// Báo cáo hư hỏng. Bài: Hoang/05-damage-lifecycle/01-damage-report-form.md (Bước 2)
// API: { id, copyId, reporterId, status, severity, note, photoPath, createdAt }

class DamageReport {
  DamageReport({
    required this.id,
    required this.copyId,
    required this.reporterId,
    required this.status,
    this.severity,
    this.note,
    this.photoPath,
    required this.createdAt,
  });

  final int id;
  final int copyId;
  final int reporterId;
  final String status; // PENDING / REJECTED / REPAIR / DISPOSED
  final String? severity; // LIGHT / MEDIUM / HEAVY
  final String? note;
  final String? photoPath;
  final DateTime createdAt;

  factory DamageReport.fromJson(Map<String, dynamic> j) => DamageReport(
        id: (j['id'] as num).toInt(),
        copyId: (j['copyId'] as num).toInt(),
        reporterId: (j['reporterId'] as num).toInt(),
        status: j['status'] as String,
        severity: j['severity'] as String?,
        note: j['note'] as String?,
        photoPath: j['photoPath'] as String?,
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}
