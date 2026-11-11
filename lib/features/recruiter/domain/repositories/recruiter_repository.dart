import 'package:skill_arena/features/recruiter/domain/entities/company_model.dart';
import 'package:skill_arena/features/recruiter/domain/entities/job_model.dart';
import 'package:skill_arena/features/recruiter/domain/entities/verified_certificate.dart';

/// Repository contract for Phase 9 Recruiter Ecosystem, Verified Skills & Talent Platform.
abstract class RecruiterRepository {
  /// Fetches verified hiring companies.
  Future<List<CompanyModel>> getCompanies();

  /// Fetches active open job listings.
  Future<List<JobModel>> getJobs();

  /// Applies for a job listing.
  Future<bool> applyForJob(String userId, String jobId);

  /// Fetches verified certificates for user.
  Future<List<VerifiedCertificate>> getCertificates(String userId);

  /// Issues a new verified skill certificate.
  Future<VerifiedCertificate> issueCertificate({
    required String userId,
    required String userName,
    required String skillTitle,
  });

  /// Shortlists a candidate for recruiter pipeline.
  Future<void> shortlistCandidate(String recruiterId, String candidateUserId);
}
