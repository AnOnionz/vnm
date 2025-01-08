import 'dart:convert';

class VerificationCodeEntity {
  final String requestId;
  final String recipient;
  final int otpLength;
  final DateTime? otpResendAvailableAt;
  final DateTime? otpExpiresAt;

  VerificationCodeEntity({
    required this.requestId,
    required this.recipient,
    required this.otpLength,
    this.otpResendAvailableAt,
    this.otpExpiresAt,
  });

  VerificationCodeEntity copyWith({
    String? requestId,
    String? recipient,
    int? otpLength,
    DateTime? otpResendAt,
    DateTime? otpExpiresAt,
  }) {
    return VerificationCodeEntity(
      requestId: requestId ?? this.requestId,
      recipient: recipient ?? this.recipient,
      otpLength: otpLength ?? this.otpLength,
      otpResendAvailableAt: otpResendAt ?? this.otpResendAvailableAt,
      otpExpiresAt: otpExpiresAt ?? this.otpExpiresAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'requestId': requestId,
      'recipient': recipient,
      'otpLength': otpLength,
      'otpResendAvailableAt': otpResendAvailableAt != null
          ? otpResendAvailableAt?.toUtc().toIso8601String()
          : null,
      'otpExpiresAt':
          otpExpiresAt != null ? otpExpiresAt?.toUtc().toIso8601String() : null,
    };
  }

  factory VerificationCodeEntity.fromMap(Map<String, dynamic> map) {
    return VerificationCodeEntity(
      requestId: map['requestId'] as String,
      recipient: map['recipient'] as String,
      otpLength: map['otpLength'] as int,
      otpResendAvailableAt: map['otpResendAvailableAt'] != null
          ? DateTime.parse(map['otpResendAvailableAt'] as String).toLocal()
          : null,
      otpExpiresAt: map['otpExpiresAt'] != null
          ? DateTime.parse(map['otpExpiresAt'] as String).toLocal()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerificationCodeEntity.fromJson(String source) =>
      VerificationCodeEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VerificationCodeEntity(requestId: $requestId, recipient: $recipient, otpLength: $otpLength, otpResendAvailableAt: $otpResendAvailableAt, otpExpiresAt: $otpExpiresAt)';
  }

  @override
  bool operator ==(covariant VerificationCodeEntity other) {
    if (identical(this, other)) return true;

    return other.requestId == requestId &&
        other.recipient == recipient &&
        other.otpLength == otpLength &&
        other.otpResendAvailableAt == otpResendAvailableAt &&
        other.otpExpiresAt == otpExpiresAt;
  }

  @override
  int get hashCode {
    return requestId.hashCode ^
        recipient.hashCode ^
        otpLength.hashCode ^
        otpResendAvailableAt.hashCode ^
        otpExpiresAt.hashCode;
  }
}
