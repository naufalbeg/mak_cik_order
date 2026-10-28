import 'package:flutter/material.dart';

import '../services/progression_service.dart';
import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/common.dart';
import '../widgets/profile_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _reset(BuildContext context) async {
    final ok = await confirmDialog(
      context,
      title: tr('reset_confirm_title'),
      body: tr('reset_confirm_body'),
      confirmLabel: tr('reset_progress'),
      cancelLabel: tr('cancel'),
      destructive: true,
    );
    if (!ok) return;
    await ProgressionService.instance.resetProgress();
    if (context.mounted) showToast(context, tr('reset_done'));
  }

  @override
  Widget build(BuildContext context) {
    final p = ProgressionService.instance;
    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: ListenableBuilder(
            listenable: p,
            builder: (context, _) {
              final s = p.settings;
              return Column(
                children: [
                  ScreenHeader(title: tr('settings')),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                      children: [
                        StallPanel(
                          title: tr('profile'),
                          icon: Icons.person_rounded,
                          accent: AppColors.pandanDark,
                          child: Row(
                            children: [
                              AvatarCircle(avatar: s.avatar, size: 64),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.playerName ?? '-',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.woodDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, size: 16, color: AppColors.turmeric),
                                        Text(
                                          ' ${p.totalStars}/${p.maxStars}',
                                          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink),
                                        ),
                                        const SizedBox(width: 10),
                                        const CoinBadge(size: 12),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 112,
                                child: GameButton(
                                  label: tr('edit_profile'),
                                  icon: Icons.edit_rounded,
                                  height: 44,
                                  fontSize: 14,
                                  color: AppColors.turmeric,
                                  shadow: const Color(0xFFB98A00),
                                  textColor: AppColors.ink,
                                  onPressed: () => showEditProfileSheet(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        StallPanel(
                          title: tr('sound_gameplay'),
                          icon: Icons.tune_rounded,
                          child: GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.6,
                            children: [
                              _ToggleTile(
                                icon: Icons.music_note_rounded,
                                label: tr('music'),
                                color: const Color(0xFF7B4FD6),
                                value: s.music,
                                onChanged: (v) async {
                                  await p.updateSettings((x) => x.music = v);
                                  await AudioManager.instance.syncWithSettings();
                                },
                              ),
                              _ToggleTile(
                                icon: Icons.volume_up_rounded,
                                label: tr('sfx'),
                                color: const Color(0xFF2B8CC4),
                                value: s.sfx,
                                onChanged: (v) async {
                                  await p.updateSettings((x) => x.sfx = v);
                                  AudioManager.instance.play(Sfx.tap);
                                },
                              ),
                              _ToggleTile(
                                icon: Icons.vibration_rounded,
                                label: tr('vibration'),
                                color: AppColors.chili,
                                value: s.vibration,
                                onChanged: (v) async {
                                  await p.updateSettings((x) => x.vibration = v);
                                  AudioManager.instance.vibrate();
                                },
                              ),
                              _ToggleTile(
                                icon: Icons.lightbulb_rounded,
                                label: tr('auto_hint'),
                                color: const Color(0xFFDB8A00),
                                value: s.showHintByDefault,
                                onChanged: (v) => p.updateSettings((x) => x.showHintByDefault = v),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        StallPanel(
                          title: tr('language'),
                          icon: Icons.language_rounded,
                          child: Row(
                            children: [
                              for (final (code, label, flag) in const [
                                ('ms', 'Bahasa Melayu', '🇲🇾'),
                                ('en', 'English', '🇬🇧'),
                              ]) ...[
                                if (code == 'en') const SizedBox(width: 12),
                                Expanded(
                                  child: _LanguageOption(
                                    label: label,
                                    flag: flag,
                                    selected: s.language == code,
                                    onTap: () {
                                      AudioManager.instance.play(Sfx.tap);
                                      p.updateSettings((x) => x.language = code);
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        StallPanel(
                          title: tr('game_data'),
                          icon: Icons.save_rounded,
                          accent: const Color(0xFF9E2B21),
                          child: GameButton(
                            label: tr('reset_progress'),
                            icon: Icons.restart_alt_rounded,
                            height: 50,
                            fontSize: 16,
                            color: AppColors.chili,
                            shadow: const Color(0xFF9E2B21),
                            onPressed: () => _reset(context),
                          ),
                        ),
                        const SizedBox(height: 18),
                        StallPanel(
                          title: tr('about'),
                          icon: Icons.info_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tr('about_body'), style: const TextStyle(height: 1.4, color: AppColors.ink)),
                              const SizedBox(height: 8),
                              const Text(
                                'Mak Cik, Order! v1.0.0',
                                style: TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Big tappable toggle tile: coloured icon, label and an ON/OFF pill.
class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = value ? color : Colors.grey.shade500;
    return Semantics(
      toggled: value,
      button: true,
      label: label,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: value ? fade(color, 0.15) : fade(Colors.white, 0.45),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c, width: 2.5),
            boxShadow: [BoxShadow(color: fade(c, 0.5), offset: const Offset(0, 4))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: c,
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      value ? tr('on') : tr('off'),
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink, height: 1.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String flag;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({required this.label, required this.flag, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.pandan : fade(Colors.white, 0.45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.pandanDark : AppColors.creamDark, width: 2.5),
          boxShadow: [
            BoxShadow(color: selected ? AppColors.pandanDark : fade(AppColors.wood, 0.3), offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Text(flag, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: selected ? Colors.white : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
