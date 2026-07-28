import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../widgets/equalizer.dart';
import '../widgets/glass_card.dart';
import 'about_page.dart';
import 'web_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.audioHandler,
    super.key,
  });

  final AudioHandler audioHandler;

  Future<void> _openYouTube(BuildContext context) async {
    final opened = await launchUrl(
      Uri.parse(AppConstants.youtubeUrl),
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir YouTube.'),
        ),
      );
    }
  }

  Future<void> _openWeb(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const WebPage(),
      ),
    );
  }

  Future<void> _openAbout(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AboutPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.55),
              radius: 1.25,
              colors: [
                Color(0xFF0B3770),
                AppColors.navy,
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
            child: Column(
              children: [
                Container(
                  width: 255,
                  height: 255,
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppColors.gold,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.22),
                        blurRadius: 24,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Transform.scale(
                      scale: 1.55,
                      child: Image.asset(
                        'assets/images/huguenot_cross.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.navyLight,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.church_rounded,
                              color: AppColors.goldLight,
                              size: 96,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'DOGMA Y FE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                const Text(
                  'R A D I O',
                  style: TextStyle(
                    color: AppColors.goldLight,
                    fontSize: 21,
                    letterSpacing: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  AppConstants.slogan,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSoft,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                StreamBuilder<PlaybackState>(
                  stream: audioHandler.playbackState,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    final playing = state?.playing ?? false;
                    final processing =
                        state?.processingState ?? AudioProcessingState.idle;

                    final connecting =
                        processing == AudioProcessingState.loading ||
                            processing == AudioProcessingState.buffering;

                    return GlassCard(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.liveRed.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color:
                                AppColors.liveRed.withValues(alpha: 0.60),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: AppColors.liveRed,
                                  size: 11,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'EN DIRECTO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Container(
                                width: 74,
                                height: 74,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.gold,
                                  ),
                                  color: AppColors.navy,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.gold.withValues(
                                        alpha: 0.18,
                                      ),
                                      blurRadius: 14,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.sensors_rounded,
                                  color: AppColors.goldLight,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Escuchando en vivo',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      AppConstants.appName,
                                      style: TextStyle(
                                        color: AppColors.goldLight,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Equalizer(active: playing),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _RoundControl(
                                icon: Icons.pause_rounded,
                                label: 'Pausar',
                                onPressed: playing
                                    ? () => audioHandler.pause()
                                    : null,
                              ),
                              _RoundControl(
                                icon: Icons.stop_rounded,
                                label: 'Detener',
                                highlighted: true,
                                onPressed: () => audioHandler.stop(),
                              ),
                              _RoundControl(
                                icon: connecting
                                    ? Icons.hourglass_top_rounded
                                    : Icons.play_arrow_rounded,
                                label:
                                connecting ? 'Conectando' : 'Escuchar',
                                onPressed: connecting
                                    ? null
                                    : () => audioHandler.play(),
                              ),
                            ],
                          ),
                          if (state?.errorMessage != null) ...[
                            const SizedBox(height: 14),
                            Text(
                              state!.errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFFF8A80),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _LinkCard(
                        icon: Icons.language_rounded,
                        title: 'NUESTRA WEB',
                        subtitle: 'dogmayfe.org',
                        onPressed: () => _openWeb(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LinkCard(
                        icon: Icons.ondemand_video_rounded,
                        title: 'NUESTRO CANAL',
                        subtitle: '@laluzescristo',
                        onPressed: () => _openYouTube(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(
                        icon: Icons.radio_rounded,
                        label: 'Radio',
                        selected: true,
                        onPressed: () {},
                      ),
                      _NavItem(
                        icon: Icons.language_rounded,
                        label: 'Web',
                        onPressed: () => _openWeb(context),
                      ),
                      _NavItem(
                        icon: Icons.ondemand_video_rounded,
                        label: 'Canal',
                        onPressed: () => _openYouTube(context),
                      ),
                      _NavItem(
                        icon: Icons.info_outline_rounded,
                        label: 'Acerca de',
                        onPressed: () => _openAbout(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundControl extends StatelessWidget {
  const _RoundControl({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: highlighted
                  ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.goldLight,
                  AppColors.gold,
                ],
              )
                  : null,
              color: highlighted ? null : AppColors.navy,
              border: Border.all(
                color: AppColors.gold,
              ),
              boxShadow: highlighted
                  ? [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.42),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
                  : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: highlighted ? AppColors.navy : Colors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: onPressed == null ? Colors.white38 : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(26),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                color: AppColors.goldLight,
                size: 34,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.goldLight,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected
                  ? AppColors.goldLight
                  : Colors.white70,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? AppColors.goldLight
                    : Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
