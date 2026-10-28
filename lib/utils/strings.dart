import '../services/progression_service.dart';

/// Minimal UI localisation: Bahasa Melayu (default) and English.
/// Use: `tr('play')`, or `tr('served_x', {'n': '3'})`.
const Map<String, Map<String, String>> _strings = {
  'app_title': {'ms': 'Mak Cik, Order!', 'en': 'Mak Cik, Order!'},
  'subtitle': {'ms': 'Jelajah Rasa Malaysia', 'en': 'Jelajah Rasa Malaysia'},
  'loading': {'ms': 'Menyediakan gerai...', 'en': 'Setting up the stall...'},
  'play': {'ms': 'Main', 'en': 'Play'},
  'register_title': {'ms': 'Daftar Akaun', 'en': 'Create Account'},
  'register_desc': {
    'ms': 'Daftar sekali sahaja. Lepas ni terus main!',
    'en': 'Register once. Next time you jump straight in!'
  },
  'your_name': {'ms': 'Nama anda', 'en': 'Your name'},
  'choose_avatar': {'ms': 'Pilih watak', 'en': 'Choose your avatar'},
  'name_required': {'ms': 'Sila masukkan nama (2-16 huruf)', 'en': 'Please enter a name (2-16 characters)'},
  'register': {'ms': 'Daftar', 'en': 'Register'},
  'welcome_back': {'ms': 'Selamat kembali, {name}!', 'en': 'Welcome back, {name}!'},
  'continue': {'ms': 'Teruskan', 'en': 'Continue'},
  'how_to_play': {'ms': 'Cara Bermain', 'en': 'How to Play'},
  'collection': {'ms': 'Koleksi Makanan', 'en': 'Food Collection'},
  'shop': {'ms': 'Kedai Gerai', 'en': 'Stall Shop'},
  'settings': {'ms': 'Tetapan', 'en': 'Settings'},
  'exit': {'ms': 'Keluar', 'en': 'Exit'},
  'exit_confirm': {'ms': 'Keluar dari permainan?', 'en': 'Exit the game?'},
  'yes': {'ms': 'Ya', 'en': 'Yes'},
  'no': {'ms': 'Tidak', 'en': 'No'},
  'cancel': {'ms': 'Batal', 'en': 'Cancel'},
  'save': {'ms': 'Simpan', 'en': 'Save'},
  'profile': {'ms': 'Profil', 'en': 'Profile'},
  'edit_profile': {'ms': 'Ubah Profil', 'en': 'Edit Profile'},
  'profile_saved': {'ms': 'Profil disimpan!', 'en': 'Profile saved!'},
  'sound_gameplay': {'ms': 'Bunyi & Permainan', 'en': 'Sound & Gameplay'},
  'game_data': {'ms': 'Data Permainan', 'en': 'Game Data'},
  'on': {'ms': 'Hidup', 'en': 'On'},
  'off': {'ms': 'Tutup', 'en': 'Off'},
  'ok': {'ms': 'OK', 'en': 'OK'},
  'back': {'ms': 'Kembali', 'en': 'Back'},
  'coins': {'ms': 'Syiling', 'en': 'Coins'},
  'stars': {'ms': 'Bintang', 'en': 'Stars'},

  // Map / levels
  'map_title': {'ms': 'Peta Malaysia', 'en': 'Malaysia Map'},
  'peninsular': {'ms': 'Semenanjung', 'en': 'Peninsular'},
  'borneo': {'ms': 'Borneo', 'en': 'Borneo'},
  'states_done': {'ms': '{n}/{total} negeri', 'en': '{n}/{total} states'},
  'player_level': {'ms': 'Tukang Masak', 'en': 'Stall Cook'},
  'journey': {'ms': 'Perjalanan', 'en': 'Journey'},
  'locked': {'ms': 'Berkunci', 'en': 'Locked'},
  'no_lives': {'ms': 'Nyawa habis! Penuh semula dalam {time}', 'en': 'No lives left! Full again in {time}'},
  'life_lost': {'ms': 'Hilang 1 nyawa', 'en': 'Lost 1 life'},
  'unlock_hint': {
    'ms': 'Tamatkan semua tahap {state} untuk membuka.',
    'en': 'Complete every level in {state} to unlock.',
  },
  'level': {'ms': 'Tahap', 'en': 'Level'},
  'level_n': {'ms': 'Tahap {n}', 'en': 'Level {n}'},
  'easy': {'ms': 'Mudah', 'en': 'Easy'},
  'medium': {'ms': 'Sederhana', 'en': 'Medium'},
  'hard': {'ms': 'Sukar', 'en': 'Hard'},
  'best': {'ms': 'Terbaik', 'en': 'Best'},
  'goal_customers': {'ms': 'Layan {n} pelanggan', 'en': 'Serve {n} customers'},
  'seconds': {'ms': '{n} saat', 'en': '{n} sec'},
  'featured_food': {'ms': 'Menu Gerai', 'en': 'Stall Menu'},
  'example_dialogue': {'ms': 'Contoh Dialog', 'en': 'Example Dialogue'},
  'choose_level': {'ms': 'Pilih Tahap', 'en': 'Choose a Level'},
  'start': {'ms': 'Mula', 'en': 'Start'},
  'dialogue_draft_note': {
    'ms': 'Dialog draf — perlu disemak penutur tempatan.',
    'en': 'Draft dialogue — pending local speaker review.',
  },

  // Gameplay
  'ready': {'ms': 'Bersedia?', 'en': 'Ready?'},
  'tap_to_start': {'ms': 'Ketik untuk mula', 'en': 'Tap to start'},
  'hint': {'ms': 'Petunjuk', 'en': 'Hint'},
  'hide_hint': {'ms': 'Sorok', 'en': 'Hide'},
  'hint_unavailable': {'ms': 'Tiada petunjuk di tahap ini', 'en': 'No hints in this level'},
  'standard_malay': {'ms': 'Bahasa Melayu Standard', 'en': 'Standard Malay'},
  'tray': {'ms': 'Dulang', 'en': 'Tray'},
  'tray_empty': {'ms': 'Ketik makanan untuk letak di dulang', 'en': 'Tap food to add it to the tray'},
  'clear': {'ms': 'Kosongkan', 'en': 'Clear'},
  'serve': {'ms': 'HIDANG', 'en': 'SERVE'},
  'select_food_first': {'ms': 'Pilih makanan dahulu!', 'en': 'Select some food first!'},
  'correct': {'ms': 'Betul! Sedap!', 'en': 'Correct! Delicious!'},
  'incorrect': {'ms': 'Alamak, salah order!', 'en': 'Oops, wrong order!'},
  'streak_bonus': {'ms': 'Bonus berturut +{n}', 'en': 'Streak bonus +{n}'},
  'served_x': {'ms': 'Dilayan {n}/{goal}', 'en': 'Served {n}/{goal}'},
  'streak': {'ms': 'Rentetan', 'en': 'Streak'},
  'score': {'ms': 'Markah', 'en': 'Score'},
  'time': {'ms': 'Masa', 'en': 'Time'},
  'times_up': {'ms': 'Masa tamat!', 'en': "Time's up!"},
  'goal_reached': {'ms': 'Sasaran dicapai!', 'en': 'Goal reached!'},
  'too_many_wrong': {'ms': '3 pesanan salah!', 'en': '3 wrong orders!'},
  'life_cost_note': {
    'ms': 'Kemajuan pusingan ini akan hilang dan anda akan kehilangan 1 nyawa.',
    'en': 'Progress in this run will be lost and you will lose 1 life.',
  },

  // Pause
  'paused': {'ms': 'Rehat Sekejap', 'en': 'Paused'},
  'resume': {'ms': 'Sambung', 'en': 'Resume'},
  'restart': {'ms': 'Mula Semula', 'en': 'Restart Level'},
  'main_menu': {'ms': 'Menu Utama', 'en': 'Main Menu'},
  'quit_confirm_title': {'ms': 'Tinggalkan tahap?', 'en': 'Leave this level?'},
  'quit_confirm_body': {
    'ms': 'Kemajuan pusingan ini akan hilang.',
    'en': 'Progress in this run will be lost.',
  },
  'restart_confirm_title': {'ms': 'Mula semula?', 'en': 'Restart?'},

  // Result
  'level_complete': {'ms': 'Tahap Selesai!', 'en': 'Level Complete!'},
  'level_failed': {'ms': 'Cuba Lagi!', 'en': 'Try Again!'},
  'level_failed_body': {
    'ms': 'Layan {n} pelanggan dengan betul untuk menamatkan tahap.',
    'en': 'Serve {n} customers correctly to clear the level.',
  },
  'customers_served': {'ms': 'Pelanggan dilayan', 'en': 'Customers served'},
  'correct_orders': {'ms': 'Order betul', 'en': 'Correct orders'},
  'accuracy': {'ms': 'Ketepatan', 'en': 'Accuracy'},
  'best_streak': {'ms': 'Rentetan terbaik', 'en': 'Best streak'},
  'time_bonus': {'ms': 'Bonus masa', 'en': 'Time bonus'},
  'completion_bonus': {'ms': 'Bonus tamat', 'en': 'Completion bonus'},
  'coins_earned': {'ms': 'Syiling diperoleh', 'en': 'Coins earned'},
  'new_best': {'ms': 'Rekod baharu!', 'en': 'New best!'},
  'new_foods': {'ms': 'Makanan baharu ditemui', 'en': 'New foods discovered'},
  'state_unlocked': {'ms': '{state} kini dibuka!', 'en': '{state} is now unlocked!'},
  'replay': {'ms': 'Main Lagi', 'en': 'Replay'},
  'next_level': {'ms': 'Tahap Seterusnya', 'en': 'Next Level'},
  'to_map': {'ms': 'Ke Peta', 'en': 'To Map'},
  'saving': {'ms': 'Menyimpan...', 'en': 'Saving...'},

  // Collection
  'discovered_x': {'ms': '{n}/{total} ditemui', 'en': '{n}/{total} discovered'},
  'undiscovered': {'ms': 'Belum ditemui', 'en': 'Not discovered yet'},
  'undiscovered_hint': {
    'ms': 'Hidangkan makanan ini dengan betul untuk membukanya.',
    'en': 'Serve this dish correctly to unlock it.',
  },
  'ingredients': {'ms': 'Bahan', 'en': 'Ingredients'},
  'cultural_fact': {'ms': 'Fakta Budaya', 'en': 'Cultural Fact'},
  'region': {'ms': 'Negeri', 'en': 'State'},
  'shared_note': {
    'ms': 'Makanan serantau sering dikongsi antara negeri.',
    'en': 'Regional foods are often shared across states.',
  },

  // Shop
  'cat_table': {'ms': 'Meja', 'en': 'Tables'},
  'cat_decoration': {'ms': 'Hiasan', 'en': 'Decor'},
  'cat_clothing': {'ms': 'Pakaian', 'en': 'Clothing'},
  'cat_signboard': {'ms': 'Papan Tanda', 'en': 'Signboard'},
  'cat_theme': {'ms': 'Tema', 'en': 'Themes'},
  'buy': {'ms': 'Beli', 'en': 'Buy'},
  'equip': {'ms': 'Guna', 'en': 'Equip'},
  'equipped': {'ms': 'Digunakan', 'en': 'Equipped'},
  'free': {'ms': 'Percuma', 'en': 'Free'},
  'not_enough_coins': {'ms': 'Syiling tidak mencukupi!', 'en': 'Not enough coins!'},
  'purchased': {'ms': 'Dibeli dan digunakan!', 'en': 'Purchased and equipped!'},
  'buy_confirm': {'ms': 'Beli {item} dengan {price} syiling?', 'en': 'Buy {item} for {price} coins?'},
  'cosmetic_note': {
    'ms': 'Barang kosmetik sahaja — tidak menjejaskan permainan.',
    'en': 'Cosmetic only — never affects gameplay.',
  },
  'preview': {'ms': 'Pratonton Gerai', 'en': 'Stall Preview'},

  // Settings
  'music': {'ms': 'Muzik', 'en': 'Music'},
  'sfx': {'ms': 'Kesan Bunyi', 'en': 'Sound Effects'},
  'vibration': {'ms': 'Getaran', 'en': 'Vibration'},
  'auto_hint': {'ms': 'Tunjuk terjemahan secara automatik', 'en': 'Show translation automatically'},
  'language': {'ms': 'Bahasa', 'en': 'Language'},
  'reset_progress': {'ms': 'Set Semula Kemajuan', 'en': 'Reset Progress'},
  'reset_confirm_title': {'ms': 'Set semula semua kemajuan?', 'en': 'Reset all progress?'},
  'reset_confirm_body': {
    'ms': 'Tahap, markah, syiling, barang kedai dan koleksi akan dipadam. Tindakan ini tidak boleh dibatalkan.',
    'en': 'Levels, scores, coins, shop items and collection will be erased. This cannot be undone.',
  },
  'reset_done': {'ms': 'Kemajuan telah diset semula.', 'en': 'Progress has been reset.'},
  'about': {'ms': 'Perihal', 'en': 'About'},
  'about_body': {
    'ms': 'Permainan santai meraikan makanan, gerai dan loghat Malaysia. Dialog dan fakta budaya ialah draf dan perlu disemak penutur tempatan.',
    'en': 'A casual game celebrating Malaysian food, stalls and regional speech. Dialogue and cultural facts are drafts pending local review.',
  },

  // Tutorial
  'tut_1_title': {'ms': 'Selamat datang ke gerai!', 'en': 'Welcome to the stall!'},
  'tut_1_body': {
    'ms': 'Bantu Mak Cik melayan pelanggan sebelum masa tamat.',
    'en': 'Help Mak Cik serve customers before time runs out.',
  },
  'tut_2_title': {'ms': 'Baca order', 'en': 'Read the order'},
  'tut_2_body': {
    'ms': 'Pelanggan memesan dalam loghat tempatan. Ketik Petunjuk untuk melihat terjemahan Bahasa Melayu Standard.',
    'en': 'Customers order in local speech. Tap Hint to see the Standard Malay translation.',
  },
  'tut_3_title': {'ms': 'Pilih makanan', 'en': 'Pick the food'},
  'tut_3_body': {
    'ms': 'Ketik kad makanan untuk menambah ke dulang. Guna + dan − untuk ubah kuantiti.',
    'en': 'Tap food cards to add them to the tray. Use + and − to change quantities.',
  },
  'tut_4_title': {'ms': 'Hidang!', 'en': 'Serve!'},
  'tut_4_body': {
    'ms': 'Ketik HIDANG. Setiap makanan DAN kuantiti mesti tepat. Order betul berturut-turut memberi bonus!',
    'en': 'Tap SERVE. Every food AND quantity must match. Correct orders in a row earn a bonus!',
  },
  'tut_5_title': {'ms': 'Jelajah Malaysia', 'en': 'Explore Malaysia'},
  'tut_5_body': {
    'ms': 'Kumpul bintang untuk membuka negeri baharu, temui makanan dan hias gerai dengan syiling.',
    'en': 'Earn stars to unlock new states, discover foods and decorate your stall with coins.',
  },
  'next': {'ms': 'Seterusnya', 'en': 'Next'},
  'lets_go': {'ms': 'Jom Mula!', 'en': "Let's Go!"},
  'skip': {'ms': 'Langkau', 'en': 'Skip'},
};

String tr(String key, [Map<String, String>? params]) {
  final lang = ProgressionService.instance.lang;
  var s = _strings[key]?[lang] ?? _strings[key]?['en'] ?? key;
  if (params != null) {
    params.forEach((k, v) => s = s.replaceAll('{$k}', v));
  }
  return s;
}
