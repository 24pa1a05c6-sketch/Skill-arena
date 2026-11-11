import 'package:flutter/material.dart';
import 'package:skill_arena/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:skill_arena/features/onboarding/domain/entities/onboarding_page.dart';
import 'package:skill_arena/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Implementation of [OnboardingRepository].
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDatasource _localDatasource;

  OnboardingRepositoryImpl(this._localDatasource);

  @override
  List<OnboardingPage> getOnboardingPages() {
    return const [
      OnboardingPage(
        index: 0,
        tag: 'WELCOME',
        title: 'Learn. Compete. Prove. Grow.',
        subtitle: 'The 2030 Skill Stadium',
        description:
            'Step into the next-generation arena where learning tech skills unlocks battle trophies, real rewards, and global reputation.',
        icon: Icons.bolt_rounded,
      ),
      OnboardingPage(
        index: 1,
        tag: 'LEARN',
        title: 'Master Futuristic Stacks',
        subtitle: 'AI-Guided Learning Trees',
        description:
            'Explore interactive skill nodes across Architecture, Cyber Security, AI Prompting, and Web3 with automated code evaluation.',
        icon: Icons.school_rounded,
      ),
      OnboardingPage(
        index: 2,
        tag: 'COMPETE',
        title: 'High-Stakes Tournaments',
        subtitle: 'Battle Tokens & Live Rankings',
        description:
            'Join instant matchmaking or grand championship tournaments. Win \$ARENA tokens, raise your global ELO, and claim the leaderboard.',
        icon: Icons.emoji_events_rounded,
      ),
      OnboardingPage(
        index: 3,
        tag: 'PROVE',
        title: 'Verifiable Skill Matrix',
        subtitle: 'Recruiter-Ready Holographic Profile',
        description:
            'Build your 5-axis Skill Radar, earn cryptographically signed certificates, and showcase your live battle record to recruiters.',
        icon: Icons.radar_rounded,
      ),
      OnboardingPage(
        index: 4,
        tag: 'GROW',
        title: 'Accelerate Your Career',
        subtitle: 'Guilds, Marketplace & AI Mentor',
        description:
            'Form clans, trade digital assets in the Vault, and let Skill Arena AI guide your career trajectory into world-class roles.',
        icon: Icons.auto_graph_rounded,
      ),
      OnboardingPage(
        index: 5,
        tag: 'MODE SELECT',
        title: 'WHAT\'S YOUR ARENA?',
        subtitle: 'Personalize Your Primary Vanguard Mode',
        description:
            'Choose how you want to experience Skill Arena. Your selection tailors your dashboard, notifications, and recommendations. You can change this anytime.',
        icon: Icons.sports_score_rounded,
      ),
    ];
  }

  @override
  Future<bool> isOnboardingCompleted() => _localDatasource.isOnboardingCompleted();

  @override
  Future<void> completeOnboarding() => _localDatasource.setOnboardingCompleted();
}
