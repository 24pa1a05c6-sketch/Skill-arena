import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Centralized Firestore Collection Constants & Helper Extensions.
class FirestoreCollections {
  // Phase 4 Collections
  static const String users = 'users';
  static const String tournaments = 'tournaments';
  static const String courses = 'courses';
  static const String registrations = 'registrations';
  static const String badges = 'badges';
  static const String notifications = 'notifications';
  static const String leaderboards = 'leaderboards';
  static const String xpLogs = 'xp_logs';
  static const String wallet = 'wallet';
  static const String skills = 'skills';
  static const String analyticsEvents = 'analytics_events';

  // Phase 5 Collections
  static const String matches = 'matches';
  static const String brackets = 'brackets';
  static const String results = 'results';
  static const String rewards = 'rewards';
  static const String ratings = 'ratings';
  static const String organizers = 'organizers';
  static const String reports = 'reports';
  static const String disputes = 'disputes';

  // Phase 6 Collections
  static const String aiProfiles = 'ai_profiles';
  static const String aiSessions = 'ai_sessions';
  static const String aiRecommendations = 'ai_recommendations';
  static const String careerPaths = 'career_paths';
  static const String learningPlans = 'learning_plans';
  static const String interviewHistory = 'interview_history';
  static const String codingReviews = 'coding_reviews';
  static const String mentorMessages = 'mentor_messages';

  // Phase 7 Collections
  static const String friends = 'friends';
  static const String friendRequests = 'friend_requests';
  static const String messages = 'messages';
  static const String activityFeed = 'activity_feed';
  static const String presence = 'presence';
  static const String searchIndex = 'search_index';
  static const String guilds = 'guilds';
  static const String guildMembers = 'guild_members';
  static const String guildChat = 'guild_chat';
  static const String guildEvents = 'guild_events';
  static const String guildRankings = 'guild_rankings';

  // Phase 8 Collections
  static const String wallets = 'wallets';
  static const String transactions = 'transactions';
  static const String marketplaceItems = 'marketplace_items';
  static const String ownedItems = 'owned_items';
  static const String inventory = 'inventory';
  static const String battlePass = 'battle_pass';
  static const String missions = 'missions';
  static const String creatorProfiles = 'creator_profiles';
  static const String creatorAssets = 'creator_assets';
  static const String creatorSales = 'creator_sales';
  static const String coupons = 'coupons';
  static const String payments = 'payments';
  static const String subscriptions = 'subscriptions';
  static const String referrals = 'referrals';
  static const String rewardClaims = 'reward_claims';
  static const String wishlist = 'wishlist';

  // Phase 9 Collections
  static const String companies = 'companies';
  static const String jobs = 'jobs';
  static const String applications = 'applications';
  static const String interviews = 'interviews';
  static const String certificates = 'certificates';
  static const String resumes = 'resumes';
  static const String skillVerifications = 'skill_verifications';
  static const String portfolioViews = 'portfolio_views';
  static const String employerNotes = 'employer_notes';
  static const String candidateShortlists = 'candidate_shortlists';
  static const String verificationRequests = 'verification_requests';

  // Phase 10 Live Coding & Assessment Expansion Collections
  static const String codingProblems = 'coding_problems';
  static const String codingSubmissions = 'coding_submissions';
  static const String codingContests = 'coding_contests';
  static const String assessmentResults = 'assessment_results';
  static const String proctorLogs = 'proctor_logs';
  static const String contestLeaderboards = 'contest_leaderboards';
  static const String editorSettings = 'editor_settings';

  static CollectionReference<Map<String, dynamic>>? get usersRef => _ref(users);
  static CollectionReference<Map<String, dynamic>>? get tournamentsRef => _ref(tournaments);
  static CollectionReference<Map<String, dynamic>>? get coursesRef => _ref(courses);
  static CollectionReference<Map<String, dynamic>>? get codingProblemsRef => _ref(codingProblems);
  static CollectionReference<Map<String, dynamic>>? get codingSubmissionsRef => _ref(codingSubmissions);
  static CollectionReference<Map<String, dynamic>>? get proctorLogsRef => _ref(proctorLogs);

  static CollectionReference<Map<String, dynamic>>? _ref(String collectionName) {
    try {
      return FirebaseFirestore.instance.collection(collectionName);
    } catch (e) {
      debugPrint('[FirestoreCollections] Collection reference fallback ($collectionName): $e');
      return null;
    }
  }
}
