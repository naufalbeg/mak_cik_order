import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mak_cik_order/data/foods_data.dart';
import 'package:mak_cik_order/data/levels_data.dart';
import 'package:mak_cik_order/data/states_data.dart';
import 'package:mak_cik_order/models/order_model.dart';
import 'package:mak_cik_order/services/game_service.dart';
import 'package:mak_cik_order/services/order_service.dart';
import 'package:mak_cik_order/services/progression_service.dart';
import 'package:mak_cik_order/utils/art.dart';
import 'package:mak_cik_order/utils/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ProgressionService.instance.load();
    await ProgressionService.instance.resetProgress();
  });

  group('Order validation', () {
    const order = CustomerOrder(
      stateId: 'kelantan',
      dialectLabel: 'test',
      dialogue: 'd',
      translationMs: 't',
      hintEnabled: true,
      items: [OrderItem(foodId: 'akok', quantity: 2)],
    );

    test('exact match is correct', () {
      expect(order.matches({'akok': 2}), isTrue);
    });

    test('same total but different foods is wrong', () {
      // Akok × 2 is not Akok × 1 + Jala Mas × 1.
      expect(order.matches({'akok': 1, 'jala_mas': 1}), isFalse);
    });

    test('wrong quantity is wrong', () {
      expect(order.matches({'akok': 3}), isFalse);
    });

    test('zero-quantity entries are ignored', () {
      expect(order.matches({'akok': 2, 'nekbat': 0}), isTrue);
    });
  });

  group('Content data', () {
    test('every state food exists and every level is valid', () {
      for (final s in allStates) {
        for (final id in s.foodIds) {
          expect(foodById(id), isNotNull, reason: '$id missing');
        }
        final levels = levelsForState(s.id);
        expect(levels.length, 3);
        for (final l in levels) {
          expect(l.foodIds, isNotEmpty);
          expect(l.star3Score, greaterThan(l.star2Score));
        }
      }
    });

    test('every food has an illustration PNG', () {
      for (final f in allFoods) {
        expect(File(f.imageAsset).existsSync(), isTrue, reason: '${f.imageAsset} missing');
      }
    });

    test('every state background and character image exists', () {
      final paths = [
        Art.home,
        for (final s in allStates) Art.stateBackground(s.id),
        for (final m in ['neutral', 'happy', 'worried']) Art.makCik(m),
        for (final c in Art.customerSprites)
          for (final m in ['neutral', 'happy', 'angry']) Art.customer(c, m),
      ];
      for (final p in paths) {
        expect(File(p).existsSync(), isTrue, reason: '$p missing');
      }
    });

    test('generated dialogue never leaves a placeholder', () {
      final svc = OrderService(Random(1));
      for (final l in allLevels) {
        for (var i = 0; i < 20; i++) {
          final o = svc.nextCustomer(l).order;
          expect(o.dialogue.contains('{items}'), isFalse);
          expect(o.translationMs.contains('{items}'), isFalse);
          expect(o.items.length, lessThanOrEqualTo(l.maxDistinctItems));
          for (final it in o.items) {
            expect(it.quantity, inInclusiveRange(1, l.maxQuantity));
          }
        }
      }
    });
  });

  group('Game session', () {
    test('correct serve scores once and duplicate taps are ignored', () async {
      final level = levelsById['kelantan_1']!;
      final s = GameSession(level, rng: Random(3));
      s.start();
      final order = s.customer!.order;
      for (final item in order.items) {
        for (var i = 0; i < item.quantity; i++) {
          s.addFood(item.foodId);
        }
      }
      expect(s.serve(), FeedbackKind.correct);
      expect(s.serve(), isNull); // locked during feedback
      expect(s.score, Scoring.correctOrder);
      expect(s.correctOrders, 1);
      s.dispose();
    });

    test('empty serve does not penalise', () {
      final s = GameSession(levelsById['kelantan_1']!, rng: Random(4));
      s.start();
      expect(s.serve(), FeedbackKind.empty);
      expect(s.score, 0);
      s.dispose();
    });

    test('quantity never goes negative', () {
      final s = GameSession(levelsById['kelantan_1']!, rng: Random(5));
      s.start();
      s.removeFood('akok');
      expect(s.quantityOf('akok'), 0);
      expect(s.selection.containsKey('akok'), isFalse);
      s.dispose();
    });

    test('pause blocks input', () {
      final s = GameSession(levelsById['kelantan_1']!, rng: Random(6));
      s.start();
      s.pause();
      s.addFood('akok');
      expect(s.quantityOf('akok'), 0);
      s.resume();
      s.addFood('akok');
      expect(s.quantityOf('akok'), 1);
      s.dispose();
    });
  });

  group('Progression', () {
    test('only Kelantan level 1 is unlocked at start', () {
      final p = ProgressionService.instance;
      expect(p.isStateUnlocked('kelantan'), isTrue);
      expect(p.isStateUnlocked('terengganu'), isFalse);
      expect(p.isLevelUnlocked(levelsById['kelantan_1']!), isTrue);
      expect(p.isLevelUnlocked(levelsById['kelantan_2']!), isFalse);
    });

    test('completing all Kelantan levels unlocks Terengganu', () async {
      final p = ProgressionService.instance;
      String? unlocked;
      for (final l in levelsForState('kelantan')) {
        final out = await p.recordLevelResult(
          level: l,
          score: 600,
          stars: 2,
          completed: true,
          coinsEarned: 50,
          ordersServed: 5,
          servedFoodIds: {'akok'},
        );
        unlocked ??= out.unlockedStateId;
      }
      expect(unlocked, 'terengganu');
      expect(p.isStateUnlocked('terengganu'), isTrue);
      expect(p.coins, 150);
      expect(p.isFoodDiscovered('akok'), isTrue);
    });
  });
}
