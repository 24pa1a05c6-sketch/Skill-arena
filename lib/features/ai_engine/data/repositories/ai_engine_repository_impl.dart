import 'package:skill_arena/features/ai_engine/data/datasources/firestore_ai_engine_datasource.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/ai_mentor_profile.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/career_roadmap.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/chat_message.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/skill_gap_analysis.dart';
import 'package:skill_arena/features/ai_engine/domain/repositories/ai_engine_repository.dart';

/// Implementation of [AiEngineRepository].
class AiEngineRepositoryImpl implements AiEngineRepository {
  final FirestoreAiEngineDatasource _datasource;

  AiEngineRepositoryImpl(this._datasource);

  @override
  Future<AiMentorProfile> getMentorProfile(String userId) {
    return _datasource.getMentorProfile(userId);
  }

  @override
  Future<SkillGapAnalysis> analyzeSkillGap(String userId) {
    return _datasource.analyzeSkillGap(userId);
  }

  @override
  Future<CareerRoadmap> generateCareerRoadmap(String userId, CareerPath path) {
    return _datasource.generateCareerRoadmap(userId, path);
  }

  @override
  Future<Map<String, dynamic>> reviewCode(String codeSnippet, String language) {
    return _datasource.reviewCode(codeSnippet, language);
  }

  @override
  Future<List<Map<String, dynamic>>> generateMockInterview(String role) {
    return _datasource.generateMockInterview(role);
  }

  @override
  Future<ChatMessage> sendMessage({
    required String sessionId,
    required String userText,
  }) {
    return _datasource.sendMessage(sessionId: sessionId, userText: userText);
  }

  @override
  Future<List<ChatMessage>> getChatHistory(String sessionId) {
    return _datasource.getChatHistory(sessionId);
  }
}
