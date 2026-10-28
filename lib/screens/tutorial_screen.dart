import 'package:flutter/material.dart';

import '../app.dart';
import '../services/progression_service.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/common.dart';
import 'home_screen.dart';

class TutorialScreen extends StatefulWidget {
  /// When true, finishing goes to the Home screen instead of popping.
  final bool fromSplash;

  const TutorialScreen({super.key, this.fromSplash = false});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    ('🧕🏽', 'tut_1_title', 'tut_1_body'),
    ('💬', 'tut_2_title', 'tut_2_body'),
    ('🍢', 'tut_3_title', 'tut_3_body'),
    ('🍽️', 'tut_4_title', 'tut_4_body'),
    ('🗺️', 'tut_5_title', 'tut_5_body'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ProgressionService.instance.updateSettings((s) => s.tutorialSeen = true);
    if (!mounted) return;
    if (widget.fromSplash) {
      Navigator.of(context).pushReplacement(gameRoute(const HomeScreen()));
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = _page == _pages.length - 1;
    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  if (!widget.fromSplash)
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, color: AppColors.woodDark),
                    ),
                  const Spacer(),
                  TextButton(onPressed: _finish, child: Text(tr('skip'))),
                  const SizedBox(width: 8),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    final (emoji, title, body) = _pages[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 170,
                            height: 170,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.wood, width: 5),
                            ),
                            child: Text(emoji, style: const TextStyle(fontSize: 84)),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            tr(title),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.woodDark,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            tr(body),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 17, height: 1.4, color: AppColors.ink),
                          ),
                          if (i == 1) ...[
                            const SizedBox(height: 18),
                            const _ExampleBubble(),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(4),
                    width: i == _page ? 22 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: i == _page ? AppColors.pandan : AppColors.creamDark,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 20),
                child: GameButton(
                  label: last ? tr('lets_go') : tr('next'),
                  icon: last ? Icons.check_rounded : Icons.arrow_forward_rounded,
                  onPressed: () {
                    if (last) {
                      _finish();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExampleBubble extends StatelessWidget {
  const _ExampleBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.wood, width: 2),
      ),
      child: const Column(
        children: [
          Text(
            '“Mok Cik, kawe nok duo Akok gak.”',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          SizedBox(height: 6),
          Text(
            'Mak Cik, saya mahu dua Akok.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.pandanDark, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
