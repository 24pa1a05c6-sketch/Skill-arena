import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Entity representing an Onboarding slide in the Genesis Portal.
class OnboardingPage extends Equatable {
  final int index;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final String tag;

  const OnboardingPage({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.tag,
  });

  @override
  List<Object?> get props => [index, title, subtitle, description, icon, tag];
}
