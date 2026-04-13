import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/beans_provider.dart';
import '../../../providers/brew_logs_provider.dart';
import '../../../../core/constants/brew_methods.dart';
import '../../../../domain/entities/brew_log.dart';

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({super.key});

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final beansAsync = ref.watch(beansProvider);
    final brewLogsAsync = ref.watch(brewLogsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, _) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  children: [
                    // Greeting with time-aware message
                    _GreetingSection(),
                    const SizedBox(height: 28),

                    // Quick stats - Asymmetric grid
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _StatCard(
                            title: 'Beans',
                            value: beansAsync.when(
                              data: (beans) => '${beans.length}',
                              loading: () => '-',
                              error: (_, __) => '!',
                            ),
                            icon: Icons.coffee_outlined,
                            iconBgColor: AppColors.secondary.withOpacity(0.15),
                            iconColor: AppColors.secondary,
                            backgroundColor: AppColors.surfaceContainerLow,
                            textColor: AppColors.onSurface,
                            subtitleColor: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: _StatCard(
                            title: 'Brews',
                            value: brewLogsAsync.when(
                              data: (logs) => '${logs.length}',
                              loading: () => '-',
                              error: (_, __) => '!',
                            ),
                            icon: Icons.local_cafe_outlined,
                            iconBgColor: AppColors.primary.withOpacity(0.15),
                            iconColor: AppColors.primary,
                            backgroundColor: AppColors.surfaceContainer,
                            textColor: AppColors.onSurface,
                            subtitleColor: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Recent brews section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Brews',
                          style: GoogleFonts.notoSerif(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: AppColors.onSurface,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'View all',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    brewLogsAsync.when(
                      data: (logs) {
                        if (logs.isEmpty) {
                          return _EmptyBrewState(
                            backgroundColor: AppColors.surfaceContainerLow,
                            iconColor: AppColors.onSurfaceVariant,
                            textColor: AppColors.onSurface,
                            secondaryTextColor: AppColors.onSurfaceVariant,
                            buttonColor: AppColors.secondary,
                            buttonTextColor: AppColors.onSecondary,
                            onPressed: () => context.push('/brew'),
                          );
                        }
                        return Column(
                          children: logs.take(3).toList().asMap().entries.map((e) {
                            final index = e.key;
                            final log = e.value;
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: 300 + (index * 80)),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 10 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: _BrewLogCard(
                                log: log,
                                surfaceColor: AppColors.surfaceContainerLow,
                                textColor: AppColors.onSurface,
                                secondaryTextColor: AppColors.onSurfaceVariant,
                                ratingColor: AppColors.secondary,
                                tertiaryColor: AppColors.tertiary,
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: CircularProgressIndicator(color: AppColors.secondary),
                        ),
                      ),
                      error: (e, _) => Center(
                        child: Text(
                          'Error: $e',
                          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80), // bottom nav spacer
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    String subtitle;
    if (hour < 12) {
      greeting = 'Good morning.';
      subtitle = 'A fresh start begins here.';
    } else if (hour < 17) {
      greeting = 'Good afternoon.';
      subtitle = 'Time for an afternoon cup?';
    } else {
      greeting = 'Good evening.';
      subtitle = 'Wind down with a brew.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: GoogleFonts.notoSerif(
            fontSize: 32,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final Color backgroundColor;
  final Color textColor;
  final Color subtitleColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.backgroundColor,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.surfaceContainer,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.notoSerif(
              fontSize: 36,
              fontWeight: FontWeight.w400,
              color: textColor,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBrewState extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final VoidCallback onPressed;

  const _EmptyBrewState({
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.surfaceContainer,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_cafe_outlined,
              size: 32,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No brews yet',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start logging your brews',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [buttonColor, buttonColor.withOpacity(0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton.icon(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: Icon(Icons.add, color: buttonTextColor),
              label: Text(
                'Start your first brew',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: buttonTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrewLogCard extends StatelessWidget {
  final BrewLog log;
  final Color surfaceColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color ratingColor;
  final Color tertiaryColor;

  const _BrewLogCard({
    required this.log,
    required this.surfaceColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.ratingColor,
    required this.tertiaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.surfaceContainer,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Method icon badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              log.method.displayName.substring(0, 1),
              style: GoogleFonts.notoSerif(
                fontSize: 20,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.method.displayName,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${log.dose}g / ${log.yield_}g',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          if (log.rating != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                (i) => Icon(
                  i < (log.rating ?? 0) ? Icons.star : Icons.star_border,
                  size: 16,
                  color: ratingColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}