import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_arena/features/recruiter/data/datasources/firestore_recruiter_datasource.dart';
import 'package:skill_arena/features/recruiter/domain/entities/company_model.dart';
import 'package:skill_arena/features/recruiter/domain/entities/job_model.dart';
import 'package:skill_arena/features/recruiter/domain/entities/verified_certificate.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Phase 9 Recruiter Ecosystem & Verified Skills Unit Tests', () {
    test('CompanyModel serialization and verification status', () {
      const company = CompanyModel(
        id: 'comp_test',
        name: 'Neural Quantum AI',
        industry: 'Machine Learning',
        location: 'San Francisco, CA',
        openJobsCount: 15,
      );

      final map = company.toMap();
      final restored = CompanyModel.fromMap(map);

      expect(restored.id, equals('comp_test'));
      expect(restored.name, equals('Neural Quantum AI'));
      expect(restored.isVerified, isTrue);
    });

    test('JobModel required skills and applicant count', () {
      final job = JobModel(
        id: 'job_test',
        companyId: 'comp_test',
        companyName: 'Neural Quantum AI',
        title: 'Lead Mobile Architect',
        salaryRange: '\$200k - \$250k',
        requiredSkills: const ['Flutter 2030', 'State Management'],
        postedAt: DateTime.now(),
      );

      final map = job.toMap();
      final restored = JobModel.fromMap(map);

      expect(restored.title, equals('Lead Mobile Architect'));
      expect(restored.requiredSkills.length, equals(2));
    });

    test('VerifiedCertificate blockchain hash generation', () {
      final cert = VerifiedCertificate(
        id: 'cert_test',
        userId: 'usr_test',
        userName: 'Vanguard Architect',
        skillTitle: 'Master Flutter 2030 Architecture',
        verificationHash: '0x94F2C7A0E8B294',
        issueDate: DateTime.now(),
      );

      expect(cert.isBlockchainVerified, isTrue);
      expect(cert.verificationHash, contains('0x'));
    });

    test('FirestoreRecruiterDatasource companies, jobs and certificates operations', () async {
      final ds = FirestoreRecruiterDatasource();
      final companies = await ds.getCompanies();
      final jobs = await ds.getJobs();
      final certs = await ds.getCertificates('vanguard_2030');

      expect(companies.length, greaterThanOrEqualTo(3));
      expect(jobs.length, greaterThanOrEqualTo(2));
      expect(certs.length, greaterThanOrEqualTo(2));

      final applicationSuccess = await ds.applyForJob('vanguard_2030', jobs.first.id);
      expect(applicationSuccess, isTrue);

      final newCert = await ds.issueCertificate(
        userId: 'vanguard_2030',
        userName: 'Vanguard Architect',
        skillTitle: 'Verified AI Developer Certificate',
      );
      expect(newCert.skillTitle, contains('Verified AI'));
    });
  });
}
