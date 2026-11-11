import 'package:flutter/material.dart';
import 'package:skill_arena/core/theme/tokens/app_colors.dart';

/// Primary Mode of operation chosen by a Vanguard user.
enum UserMode {
  compete,
  master,
  both,
}

extension UserModeExtension on UserMode {
  String get displayName {
    switch (this) {
      case UserMode.compete:
        return 'COMPETE 🎮';
      case UserMode.master:
        return 'MASTER 🎓';
      case UserMode.both:
        return 'EXPLORE BOTH ⚡';
    }
  }

  String get tag {
    switch (this) {
      case UserMode.compete:
        return 'GAMER ARENA';
      case UserMode.master:
        return 'STUDENT ACADEMY';
      case UserMode.both:
        return 'HYBRID VANGUARD';
    }
  }

  String get description {
    switch (this) {
      case UserMode.compete:
        return 'Tournaments • Rankings • Teams • Competitive Gaming';
      case UserMode.master:
        return 'Courses • Skills • Projects • Certifications';
      case UserMode.both:
        return 'Full Access • Dynamic Gaming & Mastery Experience';
    }
  }

  IconData get icon {
    switch (this) {
      case UserMode.compete:
        return Icons.sports_esports_rounded;
      case UserMode.master:
        return Icons.school_rounded;
      case UserMode.both:
        return Icons.hub_rounded;
    }
  }

  Color get accentColor {
    switch (this) {
      case UserMode.compete:
        return AppColors.cyberAmber;
      case UserMode.master:
        return AppColors.electricBlue;
      case UserMode.both:
        return AppColors.neonCyan;
    }
  }
}
