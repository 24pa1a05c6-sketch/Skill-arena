import 'package:equatable/equatable.dart';

class VerifiedCertificate extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String skillTitle;
  final String verifierName;
  final String verificationHash;
  final String qrCodeUrl;
  final DateTime issueDate;
  final bool isBlockchainVerified;

  const VerifiedCertificate({
    required this.id,
    required this.userId,
    required this.userName,
    required this.skillTitle,
    this.verifierName = 'Skill Arena AI Neural Examiner',
    required this.verificationHash,
    this.qrCodeUrl = '',
    required this.issueDate,
    this.isBlockchainVerified = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'skillTitle': skillTitle,
      'verifierName': verifierName,
      'verificationHash': verificationHash,
      'qrCodeUrl': qrCodeUrl,
      'issueDate': issueDate.toIso8601String(),
      'isBlockchainVerified': isBlockchainVerified,
    };
  }

  factory VerifiedCertificate.fromMap(Map<String, dynamic> map) {
    return VerifiedCertificate(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      userName: map['userName'] as String? ?? 'Vanguard Architect',
      skillTitle: map['skillTitle'] as String? ?? 'Master Flutter 2030 Architecture',
      verifierName: map['verifierName'] as String? ?? 'Skill Arena Neural Examiner',
      verificationHash: map['verificationHash'] as String? ?? '0x94F2...C7A0',
      qrCodeUrl: map['qrCodeUrl'] as String? ?? '',
      issueDate: map['issueDate'] != null ? DateTime.parse(map['issueDate'] as String) : DateTime.now(),
      isBlockchainVerified: map['isBlockchainVerified'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [id, userId, skillTitle, verificationHash];
}
