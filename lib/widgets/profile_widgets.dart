import 'package:flutter/material.dart';

import '../services/progression_service.dart';
import '../utils/audio_manager.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import 'common.dart';

const List<String> playerAvatars = ['🧑🏽', '👩🏽', '🧕🏽', '👨🏽', '👦🏽', '👧🏽', '👴🏽', '👵🏽', '🧑🏽‍🍳', '👩🏽‍🍳', '👨🏽‍🍳', '🥷🏽'];

/// Returns an error message, or null if [name] is a valid player name.
String? validatePlayerName(String name) {
  final n = name.trim();
  return n.length < 2 || n.length > 16 ? tr('name_required') : null;
}

class AvatarCircle extends StatelessWidget {
  final String avatar;
  final double size;
  const AvatarCircle({super.key, required this.avatar, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(colors: [Color(0xFFFFF3D6), Color(0xFFF2D49B)]),
        border: Border.all(color: AppColors.turmeric, width: size * 0.06),
        boxShadow: [BoxShadow(color: fade(AppColors.woodDark, 0.35), offset: const Offset(0, 3))],
      ),
      child: Text(avatar, style: TextStyle(fontSize: size * 0.55)),
    );
  }
}

class AvatarPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const AvatarPicker({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final a in playerAvatars)
          GestureDetector(
            onTap: () {
              AudioManager.instance.play(Sfx.tap);
              onChanged(a);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: a == selected ? fade(AppColors.pandan, 0.25) : fade(Colors.white, 0.6),
                border: Border.all(color: a == selected ? AppColors.pandan : AppColors.creamDark, width: 3),
              ),
              child: Text(a, style: const TextStyle(fontSize: 28)),
            ),
          ),
      ],
    );
  }
}

/// Bottom sheet to change the player's name and avatar.
Future<void> showEditProfileSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _EditProfileSheet(),
  );
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet();

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _settings = ProgressionService.instance.settings;
  late final _name = TextEditingController(text: _settings.playerName ?? '');
  late String _avatar = _settings.avatar;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final error = validatePlayerName(_name.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    await ProgressionService.instance.updateSettings((s) {
      s.playerName = _name.text.trim();
      s.avatar = _avatar;
    });
    if (!mounted) return;
    Navigator.of(context).pop();
    showToast(context, tr('profile_saved'), color: AppColors.pandanDark);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: StallPanel(
        title: tr('edit_profile'),
        icon: Icons.edit_rounded,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AvatarCircle(avatar: _avatar, size: 84),
              const SizedBox(height: 14),
              TextField(
                controller: _name,
                maxLength: 16,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                decoration: InputDecoration(
                  labelText: tr('your_name'),
                  errorText: _error,
                  filled: true,
                  fillColor: fade(Colors.white, 0.7),
                  prefixIcon: const Icon(Icons.person_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(tr('choose_avatar'), style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 10),
              AvatarPicker(selected: _avatar, onChanged: (a) => setState(() => _avatar = a)),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: GameButton(
                      label: tr('cancel'),
                      height: 48,
                      fontSize: 16,
                      color: Colors.blueGrey,
                      shadow: const Color(0xFF37474F),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GameButton(
                      label: tr('save'),
                      icon: Icons.check_rounded,
                      height: 48,
                      fontSize: 16,
                      onPressed: _save,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
