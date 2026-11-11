import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/features/recruiter/data/datasources/firestore_recruiter_datasource.dart';
import 'package:skill_arena/features/recruiter/data/repositories/recruiter_repository_impl.dart';
import 'package:skill_arena/features/recruiter/domain/entities/company_model.dart';
import 'package:skill_arena/features/recruiter/domain/entities/job_model.dart';
import 'package:skill_arena/features/recruiter/domain/entities/verified_certificate.dart';
import 'package:skill_arena/features/recruiter/domain/repositories/recruiter_repository.dart';

class RecruiterState {
  final List<CompanyModel> companies;
  final List<JobModel> jobs;
  final List<VerifiedCertificate> certificates;
  final Set<String> appliedJobIds;
  final bool isLoading;
  final String? statusMessage;

  const RecruiterState({
    this.companies = const [],
    this.jobs = const [],
    this.certificates = const [],
    this.appliedJobIds = const {},
    this.isLoading = false,
    this.statusMessage,
  });

  RecruiterState copyWith({
    List<CompanyModel>? companies,
    List<JobModel>? jobs,
    List<VerifiedCertificate>? certificates,
    Set<String>? appliedJobIds,
    bool? isLoading,
    String? statusMessage,
  }) {
    return RecruiterState(
      companies: companies ?? this.companies,
      jobs: jobs ?? this.jobs,
      certificates: certificates ?? this.certificates,
      appliedJobIds: appliedJobIds ?? this.appliedJobIds,
      isLoading: isLoading ?? this.isLoading,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}

final firestoreRecruiterDatasourceProvider = Provider<FirestoreRecruiterDatasource>((ref) {
  return FirestoreRecruiterDatasource();
});

final recruiterRepositoryProvider = Provider<RecruiterRepository>((ref) {
  final ds = ref.watch(firestoreRecruiterDatasourceProvider);
  return RecruiterRepositoryImpl(ds);
});

final recruiterProvider = StateNotifierProvider<RecruiterNotifier, RecruiterState>((ref) {
  final repo = ref.watch(recruiterRepositoryProvider);
  return RecruiterNotifier(repo);
});

class RecruiterNotifier extends StateNotifier<RecruiterState> {
  final RecruiterRepository _repository;

  RecruiterNotifier(this._repository) : super(const RecruiterState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final companies = await _repository.getCompanies();
    final jobs = await _repository.getJobs();
    final certs = await _repository.getCertificates('vanguard_2030');

    state = state.copyWith(
      companies: companies,
      jobs: jobs,
      certificates: certs,
      isLoading: false,
    );
  }

  Future<void> applyForJob(String jobId) async {
    await _repository.applyForJob('vanguard_2030', jobId);
    final updated = Set<String>.from(state.appliedJobIds)..add(jobId);
    state = state.copyWith(
      appliedJobIds: updated,
      statusMessage: 'Application & Verified Skill Profile submitted successfully!',
    );
  }
}
