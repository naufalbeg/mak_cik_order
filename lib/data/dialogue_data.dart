/// Dialogue system data (section 6).
///
/// ⚠️ REVIEW REQUIRED BEFORE RELEASE ⚠️
/// These lines are DRAFT dialogue written to exercise the system. They
/// have NOT been reviewed by local speakers. Speech varies by district
/// and community — no state has only one dialect. Have native speakers
/// check spelling, wording and cultural context, then set
/// [DialectProfile.reviewed] to true.
///
/// Each template stores two distinct strings: the customer's local
/// dialogue and its Standard Malay translation. `{items}` is replaced
/// with the order (e.g. "duo akok nga so jala mas").
class OrderTemplate {
  final String dialogue;
  final String translationMs;

  const OrderTemplate(this.dialogue, this.translationMs);
}

class DialectProfile {
  final String stateId;
  final String dialectLabel;
  final List<OrderTemplate> templates;

  /// Number words 1..5 used in the dialogue.
  final List<String> numberWords;

  /// Word joining the last item ("dan", "nga", ...).
  final String joinWord;
  final List<String> customerNames;
  final bool reviewed;

  const DialectProfile({
    required this.stateId,
    required this.dialectLabel,
    required this.templates,
    required this.numberWords,
    required this.joinWord,
    required this.customerNames,
    this.reviewed = false,
  });
}

/// Standard Malay numbers and join word used for every translation.
const List<String> standardNumberWords = ['satu', 'dua', 'tiga', 'empat', 'lima'];
const String standardJoinWord = 'dan';

const List<DialectProfile> dialectProfiles = [
  DialectProfile(
    stateId: 'kelantan',
    dialectLabel: 'Kelantanese Malay (Baso Kelate)',
    numberWords: ['so', 'duo', 'tigo', 'pat', 'limo'],
    joinWord: 'nga',
    customerNames: ['Pok Mat', 'Mek Nab', 'Che Ku', 'Abe Li', 'Kak Yah', 'Adik Ina'],
    templates: [
      OrderTemplate('Mok Cik, kawe nok {items} gak.', 'Mak Cik, saya mahu {items}.'),
      OrderTemplate('Gapo hok sedak arini? Kawe amik {items} la.',
          'Apa yang sedap hari ini? Saya ambil {items}lah.'),
      OrderTemplate('Mok Cik, bungkuh {items} ko kawe.',
          'Mak Cik, bungkuskan {items} untuk saya.'),
      OrderTemplate('Kawe lapa doh ni. Bui {items}, Mok Cik.',
          'Saya sudah lapar ni. Beri {items}, Mak Cik.'),
    ],
  ),
  DialectProfile(
    stateId: 'terengganu',
    dialectLabel: 'Terengganu Malay',
    numberWords: ['satu', 'duwe', 'tige', 'empak', 'lime'],
    joinWord: 'ngang',
    customerNames: ['Pak Su Man', 'Mok Teh', 'Abang Din', 'Kak Long', 'Deris', 'Ani'],
    templates: [
      OrderTemplate('Mok Cik, aku nok {items} ye.', 'Mak Cik, saya mahu {items} ya.'),
      OrderTemplate('Aku nok amik {items}, Mok Cik.', 'Saya mahu ambil {items}, Mak Cik.'),
      OrderTemplate('Mok Cik, bungkuh {items} ke aku.',
          'Mak Cik, bungkuskan {items} untuk saya.'),
      OrderTemplate('Lapor sungguh aku ni. Bowok {items} mari, Mok Cik.',
          'Lapar sungguh saya ni. Bawakan {items}, Mak Cik.'),
    ],
  ),
  DialectProfile(
    stateId: 'penang',
    dialectLabel: 'Penang / Northern Malay (Loghat Utara)',
    numberWords: ['satu', 'dua', 'tiga', 'empat', 'lima'],
    joinWord: 'ngan',
    customerNames: ['Pak Hassan', 'Kak Ros', 'Ah Seng', 'Muthu', 'Lina', 'Abang Kamal'],
    templates: [
      OrderTemplate('Mak Cik, cheq nak {items} noh.', 'Mak Cik, saya mahu {items} ya.'),
      OrderTemplate('Mak Cik, bagi cheq {items} sat.', 'Mak Cik, beri saya {items} sekejap.'),
      OrderTemplate('Cheq nak tapau {items}, Mak Cik.', 'Saya mahu bungkus {items}, Mak Cik.'),
      OrderTemplate('Lapaq dah ni! {items} satgi mai noh, Mak Cik.',
          'Sudah lapar ni! Bawakan {items} sekejap lagi ya, Mak Cik.'),
    ],
  ),
  DialectProfile(
    stateId: 'melaka',
    dialectLabel: 'Melaka Malay',
    numberWords: ['satu', 'dua', 'tiga', 'empat', 'lima'],
    joinWord: 'dengan',
    customerNames: ['Pak Ali', 'Mak Long', 'Uncle Lim', 'Kak Siti', 'Jason', 'Fatin'],
    templates: [
      OrderTemplate('Mak Cik, saya nak {items}, ye.', 'Mak Cik, saya mahu {items}, ya.'),
      OrderTemplate('Mak Cik, bagi {items}, makan sini.', 'Mak Cik, beri {items}, makan di sini.'),
      OrderTemplate('Mak Cik, bungkus {items} ye, nak bawak balik.',
          'Mak Cik, bungkus {items} ya, mahu bawa pulang.'),
    ],
  ),
  DialectProfile(
    stateId: 'negeri_sembilan',
    dialectLabel: 'Negeri Sembilan Malay (Baso Nogori)',
    numberWords: ['satu', 'duo', 'tigo', 'ompek', 'limo'],
    joinWord: 'dongan',
    customerNames: ['Datuk Lembaga', 'Mak Andak', 'Pak Ngah', 'Kak Ita', 'Amir', 'Nurul'],
    templates: [
      OrderTemplate('Mak Cik, den nak {items}.', 'Mak Cik, saya mahu {items}.'),
      OrderTemplate('Mak Cik, buekan den {items} yo.', 'Mak Cik, buatkan saya {items} ya.'),
      OrderTemplate('Den lapa bona ni. Bagi {items}, Mak Cik.',
          'Saya lapar betul ni. Beri {items}, Mak Cik.'),
    ],
  ),
  DialectProfile(
    stateId: 'johor',
    dialectLabel: 'Johor-Riau Malay',
    numberWords: ['satu', 'dua', 'tiga', 'empat', 'lima'],
    joinWord: 'dengan',
    customerNames: ['Pak Mail', 'Mak Jah', 'Abang Rizal', 'Kak Ani', 'Haikal', 'Mei Ling'],
    templates: [
      OrderTemplate('Mak Cik, saya nak {items}, ye.', 'Mak Cik, saya mahu {items}, ya.'),
      OrderTemplate('Mak Cik, bagi {items} satu meja.', 'Mak Cik, beri {items} untuk satu meja.'),
      OrderTemplate('Mak Cik, tolong bungkuskan {items}.', 'Mak Cik, tolong bungkuskan {items}.'),
    ],
  ),
  DialectProfile(
    stateId: 'perak',
    dialectLabel: 'Perak Malay',
    numberWords: ['satu', 'dua', 'tiga', 'empat', 'lima'],
    joinWord: 'ngan',
    customerNames: ['Pak Teh', 'Mak Uda', 'Uncle Wong', 'Kak Ngah', 'Saravanan', 'Iman'],
    templates: [
      OrderTemplate('Mak Cik, teman nak {items}.', 'Mak Cik, saya mahu {items}.'),
      OrderTemplate('Mak Cik, bagi teman {items} ye.', 'Mak Cik, beri saya {items} ya.'),
      OrderTemplate('Teman lapor dah ni. {items}, Mak Cik.',
          'Saya sudah lapar ni. {items}, Mak Cik.'),
    ],
  ),
  DialectProfile(
    stateId: 'pahang',
    dialectLabel: 'Pahang Malay',
    numberWords: ['satu', 'dua', 'tiga', 'empat', 'lima'],
    joinWord: 'dengan',
    customerNames: ['Tok Wan', 'Mak Senah', 'Abang Zul', 'Kak Mah', 'Hafiz', 'Aina'],
    templates: [
      OrderTemplate('Mak Cik, kome bagi saya {items}.', 'Mak Cik, awak beri saya {items}.'),
      OrderTemplate('Mak Cik, saya nak {items}, ye.', 'Mak Cik, saya mahu {items}, ya.'),
      OrderTemplate('Mak Cik, bungkuih {items} ye.', 'Mak Cik, bungkus {items} ya.'),
    ],
  ),
  DialectProfile(
    stateId: 'kedah',
    dialectLabel: 'Kedah Malay (Loghat Utara)',
    numberWords: ['satu', 'dua', 'tiga', 'empat', 'lima'],
    joinWord: 'ngan',
    customerNames: ['Pak Lah', 'Mak Tok', 'Abang Mie', 'Kak Pah', 'Syafiq', 'Hana'],
    templates: [
      OrderTemplate('Mak Cik, cheq nak {items} no.', 'Mak Cik, saya mahu {items} ya.'),
      OrderTemplate('Bagi cheq {items} sat, Mak Cik.', 'Beri saya {items} sekejap, Mak Cik.'),
      OrderTemplate('Lapaq sungguh dah ni. Mai {items}, Mak Cik.',
          'Lapar sungguh sudah ni. Bawakan {items}, Mak Cik.'),
    ],
  ),
  DialectProfile(
    stateId: 'perlis',
    dialectLabel: 'Perlis Malay (Loghat Utara)',
    numberWords: ['satu', 'dua', 'tiga', 'empat', 'lima'],
    joinWord: 'ngan',
    customerNames: ['Tok Ki', 'Mak Su', 'Abang Nan', 'Kak Yam', 'Danial', 'Sofea'],
    templates: [
      OrderTemplate('Mak Cik, kami nak {items} sat.', 'Mak Cik, kami mahu {items} sekejap.'),
      OrderTemplate('Mak Cik, cheq nak {items} noh.', 'Mak Cik, saya mahu {items} ya.'),
      OrderTemplate('Hang ada {items}? Cheq ambik la, Mak Cik.',
          'Awak ada {items}? Saya ambillah, Mak Cik.'),
    ],
  ),
  DialectProfile(
    stateId: 'selangor',
    dialectLabel: 'Selangor / urban colloquial Malay',
    numberWords: ['satu', 'dua', 'tiga', 'empat', 'lima'],
    joinWord: 'dengan',
    customerNames: ['Encik Faris', 'Puan Aisyah', 'Darren', 'Priya', 'Bro Amin', 'Kak Ella'],
    templates: [
      OrderTemplate('Mak Cik, nak {items}, ye.', 'Mak Cik, mahu {items}, ya.'),
      OrderTemplate('Mak Cik, tapau {items} boleh?', 'Mak Cik, bungkus {items} boleh?'),
      OrderTemplate('Mak Cik, {items} — makan sini.', 'Mak Cik, {items} — makan di sini.'),
    ],
  ),
  DialectProfile(
    stateId: 'kuala_lumpur',
    dialectLabel: 'KL colloquial Malay / Manglish',
    numberWords: ['satu', 'dua', 'tiga', 'empat', 'lima'],
    joinWord: 'dengan',
    customerNames: ['Uncle Lim', 'Kak Ros', 'Arjun', 'Bro Hafiz', 'Mei Ling', 'Abang Zul'],
    templates: [
      OrderTemplate('Mak Cik, bagi {items} satu kali, ah.', 'Mak Cik, berikan {items}, ya.'),
      OrderTemplate('Mak Cik, {items}, tapau ah. Cepat sikit, nak kejar LRT.',
          'Mak Cik, {items}, bungkus ya. Cepat sedikit, saya mahu kejar LRT.'),
      OrderTemplate('Wah, sedap bau! Mak Cik, saya nak {items}.', 'Wah, sedap bau! Mak Cik, saya mahu {items}.'),
    ],
  ),
  DialectProfile(
    stateId: 'sabah',
    dialectLabel: 'Sabah Malay',
    numberWords: ['satu', 'dua', 'tiga', 'empat', 'lima'],
    joinWord: 'sama',
    customerNames: ['Pakcik Jaimin', 'Inah', 'Jeffery', 'Kak Normah', 'Aldrin', 'Mira'],
    templates: [
      OrderTemplate('Mak Cik, sia mau {items} bah.', 'Mak Cik, saya mahu {items}.'),
      OrderTemplate('Bagi sia {items} bah, Mak Cik.', 'Beri saya {items}, Mak Cik.'),
      OrderTemplate('Lapar sudah ni. Sia ambil {items} bah.',
          'Saya sudah lapar ni. Saya ambil {items}.'),
    ],
  ),
  DialectProfile(
    stateId: 'sarawak',
    dialectLabel: 'Sarawak Malay',
    numberWords: ['satu', 'dua', 'tiga', 'empat', 'lima'],
    joinWord: 'ngan',
    customerNames: ['Pak Su Bujang', 'Dayang', 'Jimbai', 'Kak Mas', 'Kelvin', 'Awang'],
    templates: [
      OrderTemplate('Mak Cik, kamek maok {items}.', 'Mak Cik, saya mahu {items}.'),
      OrderTemplate('Mak Cik, bungkus {items} untuk kamek ya.', 'Mak Cik, bungkus {items} untuk saya ya.'),
      OrderTemplate('Lapar gilak kamek tok. Mintak {items}, Mak Cik.',
          'Lapar sangat saya ni. Minta {items}, Mak Cik.'),
    ],
  ),
];

final Map<String, DialectProfile> dialectByState = {
  for (final d in dialectProfiles) d.stateId: d,
};

/// Generic customer avatars (placeholder art).
const List<String> customerAvatars = [
  '👩🏽', '👨🏻', '👵🏽', '👴🏾', '👧🏻', '👦🏽', '🧑🏾', '🧕🏻', '👨🏽‍🦱', '👩🏻‍🦱', '🧔🏽', '👱🏻‍♀️',
];
