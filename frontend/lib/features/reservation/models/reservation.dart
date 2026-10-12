// Lượt đặt trước. Bài: Hoang/07-reservation/03-reservation-queue.md (Bước 1)
// API trả entity Reservation có title và reader lồng bên trong.

class Reservation {
  Reservation({
    required this.id,
    required this.titleId,
    required this.titleName,
    required this.readerId,
    required this.readerName,
    required this.status,
    this.heldCopyId,
    required this.createdAt,
    this.readyUntil,
  });

  final int id;
  final int titleId;
  final String titleName;
  final int readerId;
  final String readerName;
  final String status; // WAITING / READY / FULFILLED / EXPIRED / CANCELLED
  final int? heldCopyId;
  final DateTime createdAt;
  final DateTime? readyUntil; // hạn nhận khi READY

  factory Reservation.fromJson(Map<String, dynamic> j) {
    final t = j['title'] as Map<String, dynamic>;
    final r = j['reader'] as Map<String, dynamic>;
    return Reservation(
      id: (j['id'] as num).toInt(),
      titleId: (t['id'] as num).toInt(),
      titleName: t['name'] as String,
      readerId: (r['id'] as num).toInt(),
      readerName: (r['displayName'] ?? '') as String,
      status: j['status'] as String,
      heldCopyId: (j['heldCopyId'] as num?)?.toInt(),
      createdAt: DateTime.parse(j['createdAt'] as String),
      readyUntil: j['readyUntil'] == null ? null : DateTime.parse(j['readyUntil'] as String),
    );
  }
}
