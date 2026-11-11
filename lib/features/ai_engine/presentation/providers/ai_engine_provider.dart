import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_arena/features/ai_engine/data/datasources/firestore_ai_engine_datasource.dart';
import 'package:skill_arena/features/ai_engine/data/repositories/ai_engine_repository_impl.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/ai_mentor_profile.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/career_roadmap.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/chat_message.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/skill_gap_analysis.dart';
import 'package:skill_arena/features/ai_engine/domain/repositories/ai_engine_repository.dart';

class AiEngineState {
  final AiMentorProfile mentorProfile;
  final SkillGapAnalysis gapAnalysis;
  final CareerRoadmap? careerRoadmap;
  final List<ChatMessage> chatMessages;
  final bool isLoading;
  final bool isSending;
  final Map<String, dynamic>? latestCodeReview;
  final List<Map<String, dynamic>> mockInterviewQuestions;

  const AiEngineState({
    this.mentorProfile = const AiMentorProfile(userId: 'vanguard_2030'),
    this.gapAnalysis = const SkillGapAnalysis(userId: 'vanguard_2030'),
    this.careerRoadmap,
    this.chatMessages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.latestCodeReview,
    this.mockInterviewQuestions = const [],
  });

  AiEngineState copyWith({
    AiMentorProfile? mentorProfile,
    SkillGapAnalysis? gapAnalysis,
    CareerRoadmap? careerRoadmap,
    List<ChatMessage>? chatMessages,
    bool? isLoading,
    bool? isSending,
    Map<String, dynamic>? latestCodeReview,
    List<Map<String, dynamic>>? mockInterviewQuestions,
  }) {
    return AiEngineState(
      mentorProfile: mentorProfile ?? this.mentorProfile,
      gapAnalysis: gapAnalysis ?? this.gapAnalysis,
      careerRoadmap: careerRoadmap ?? this.careerRoadmap,
      chatMessages: chatMessages ?? this.chatMessages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      latestCodeReview: latestCodeReview ?? this.latestCodeReview,
      mockInterviewQuestions: mockInterviewQuestions ?? this.mockInterviewQuestions,
    );
  }
}

final firestoreAiEngineDataSourceProvider = Provider<FirestoreAiEngineDatasource>((ref) {
  return FirestoreAiEngineDatasource();
});

final aiEngineRepositoryProvider = Provider<AiEngineRepository>((ref) {
  final ds = ref.watch(firestoreAiEngineDataSourceProvider);
  return AiEngineRepositoryImpl(ds);
});

final aiEngineProvider = StateNotifierProvider<AiEngineNotifier, AiEngineState>((ref) {
  final repo = ref.watch(aiEngineRepositoryProvider);
  return AiEngineNotifier(repo);
});

class AiEngineNotifier extends StateNotifier<AiEngineState> {
  final AiEngineRepository _repository;

  AiEngineNotifier(this._repository) : super(const AiEngineState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final profile = await _repository.getMentorProfile('vanguard_2030');
    final gap = await _repository.analyzeSkillGap('vanguard_2030');
    final chat = await _repository.getChatHistory('session_vanguard_2030');
    final roadmap = await _repository.generateCareerRoadmap('vanguard_2030', CareerPath.flutterDev);

    state = state.copyWith(
      mentorProfile: profile,
      gapAnalysis: gap,
      chatMessages: chat,
      careerRoadmap: roadmap,
      isLoading: false,
    );
  }

  Future<void> sendMessage(String text) async {
    state = state.copyWith(isSending: true);
    final reply = await _repository.sendMessage(
      sessionId: 'session_vanguard_2030',
      userText: text,
    );
    final updatedList = List<ChatMessage>.from(state.chatMessages)..add(reply);
    state = state.copyWith(chatMessages: updatedList, isSending: false);
  }

  Future<void> reviewCode(String codeSnippet) async {
    state = state.copyWith(isLoading: true);
    final review = await _repository.reviewCode(codeSnippet, 'dart');
    state = state.copyWith(latestCodeReview: review, isLoading: false);
  }

  Future<void> generateMockInterview(String role) async {
    state = state.copyWith(isLoading: true);
    final questions = await _repository.generateMockInterview(role);
    state = state.copyWith(mockInterviewQuestions: questions, isLoading: false);
  }

  void clearHistory() {
    state = state.copyWith(chatMessages: []);
  }
}
