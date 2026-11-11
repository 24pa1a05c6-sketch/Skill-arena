import 'package:skill_arena/features/recruiter/data/datasources/firestore_recruiter_datasource.dart';
import 'package:skill_arena/features/recruiter/domain/entities/company_model.dart';
import 'package:skill_arena/features/recruiter/domain/entities/job_model.dart';
import 'package:skill_arena/features/recruiter/domain/entities/verified_certificate.dart';
import 'package:skill_arena/features/recruiter/domain/repositories/recruiter_repository.dart';

/// Implementation of [RecruiterRepository].
class RecruiterRepositoryImpl implements RecruiterRepository {
  final FirestoreRecruiterDatasource _datasource;

  RecruiterRepositoryImpl(this._datasource);

  @override
  Future<List<CompanyModel>> getCompanies() {
    return _datasource.getCompanies();
  }

  @override
  Future<List<JobModel>> getJobs() {
    return _datasource.getJobs();
  }

  @override
  Future<bool> applyForJob(String userId, String jobId) {
    return _datasource.applyForJob(userId, jobId);
  }

  @override
  Future<List<VerifiedCertificate>> getCertificates(String userId) {
    return _datasource.getCertificates(userId);
  }

  @override
  Future<VerifiedCertificate> issueCertificate({
    required String userId,
    required String userName,
    required String skillTitle,
  }) {
    return _datasource.issueCertificate(
      userId: userId,
      userName: userName,
      skillTitle: skillTitle,
    );
  }

  @override
  Future<void> shortlistCandidate(String recruiterId, String candidateUserId) {
    return _datasource.shortlistCandidate(recruiterId, candidateUserId);
  }
}
