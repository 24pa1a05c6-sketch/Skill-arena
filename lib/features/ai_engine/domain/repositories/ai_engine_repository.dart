import 'package:skill_arena/features/ai_engine/domain/entities/ai_mentor_profile.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/career_roadmap.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/chat_message.dart';
import 'package:skill_arena/features/ai_engine/domain/entities/skill_gap_analysis.dart';

/// Repository contract for the Phase 6 AI Mentor & Skill Intelligence Platform.
abstract class AiEngineRepository {
  /// Fetches persistent AI mentor profile.
  Future<AiMentorProfile> getMentorProfile(String userId);

  /// Performs AI Skill Gap Analysis.
  Future<SkillGapAnalysis> analyzeSkillGap(String userId);

  /// Generates career path roadmap.
  Future<CareerRoadmap> generateCareerRoadmap(String userId, CareerPath path);

  /// Submits code snippet for AI Code Review.
  Future<Map<String, dynamic>> reviewCode(String codeSnippet, String language);

  /// Generates mock interview questions & feedback.
  Future<List<Map<String, dynamic>>> generateMockInterview(String role);

  /// Sends message to AI Mentor and receives response.
  Future<ChatMessage> sendMessage({
    required String sessionId,
    required String userText,
  });

  /// Fetches conversation history for session.
  Future<List<ChatMessage>> getChatHistory(String sessionId);
}
