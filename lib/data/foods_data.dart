import '../models/food_model.dart';

/// Food catalogue.
///
/// CONTENT NOTE: descriptions and cultural facts are concise, general
/// drafts. Regional foods are often shared across states — associations
/// here are cultural suggestions, not claims of exclusive origin.
/// Verify every entry with local sources before release.
///
/// To add art, drop a PNG in assets/images/foods/ and set imagePath.
const List<FoodItem> allFoods = [
  // ───────────── KELANTAN ─────────────
  FoodItem(
    id: 'akok',
    name: 'Akok',
    stateId: 'kelantan',
    emoji: '🧁',
    colorValue: 0xFFB8732E,
    description: LocalizedText(
      'A soft, caramelised egg-and-coconut-milk cake baked in small moulds.',
      'Kuih lembut daripada telur dan santan yang dibakar dalam acuan kecil.',
    ),
    ingredients: ['Eggs', 'Coconut milk', 'Brown sugar', 'Flour'],
    culturalFact: LocalizedText(
      'Often enjoyed at breakfast or tea time and popular during Ramadan bazaars on the east coast.',
      'Sering dinikmati ketika sarapan atau minum petang, dan popular di bazar Ramadan pantai timur.',
    ),
  ),
  FoodItem(
    id: 'jala_mas',
    name: 'Jala Mas',
    stateId: 'kelantan',
    emoji: '🍯',
    colorValue: 0xFFF2B705,
    description: LocalizedText(
      'Golden threads of egg yolk cooked in sugar syrup and folded into nests.',
      'Benang kuning telur yang dimasak dalam air gula dan dilipat seperti sarang.',
    ),
    ingredients: ['Egg yolk', 'Sugar', 'Pandan leaf'],
    culturalFact: LocalizedText(
      'One of the traditional golden kuih often associated with royal and festive occasions.',
      'Antara kuih keemasan tradisional yang sering dikaitkan dengan majlis diraja dan perayaan.',
    ),
  ),
  FoodItem(
    id: 'nasi_kerabu',
    name: 'Nasi Kerabu',
    stateId: 'kelantan',
    emoji: '🍚',
    colorValue: 0xFF3F6FD8,
    description: LocalizedText(
      'Blue rice coloured with butterfly-pea flowers, served with herbs, fish and sambal.',
      'Nasi biru berwarna bunga telang, dihidang bersama ulam, ikan dan sambal.',
    ),
    ingredients: ['Rice', 'Butterfly-pea flower', 'Ulam herbs', 'Kerisik', 'Fish'],
    culturalFact: LocalizedText(
      'The blue colour comes naturally from bunga telang (butterfly-pea flower).',
      'Warna biru datang secara semula jadi daripada bunga telang.',
    ),
  ),
  FoodItem(
    id: 'solok_lada',
    name: 'Solok Lada',
    stateId: 'kelantan',
    emoji: '🌶️',
    colorValue: 0xFF2E8B57,
    description: LocalizedText(
      'Green chillies stuffed with a fish-and-coconut filling, cooked in coconut milk.',
      'Cili hijau disumbat inti ikan dan kelapa, dimasak dalam santan.',
    ),
    ingredients: ['Green chillies', 'Fish', 'Grated coconut', 'Coconut milk'],
    culturalFact: LocalizedText(
      'A classic side dish for nasi kerabu and nasi dagang.',
      'Lauk klasik untuk dimakan bersama nasi kerabu dan nasi dagang.',
    ),
  ),
  FoodItem(
    id: 'nekbat',
    name: 'Nekbat',
    stateId: 'kelantan',
    emoji: '🍮',
    colorValue: 0xFFE8A33D,
    description: LocalizedText(
      'Little egg dumplings soaked in fragrant sugar syrup.',
      'Kuih telur kecil yang direndam dalam air gula wangi.',
    ),
    ingredients: ['Eggs', 'Flour', 'Sugar syrup', 'Pandan leaf'],
    culturalFact: LocalizedText(
      'Frequently served at weddings and kenduri in Kelantan.',
      'Sering dihidangkan semasa majlis perkahwinan dan kenduri di Kelantan.',
    ),
  ),
  FoodItem(
    id: 'ayam_percik',
    name: 'Ayam Percik',
    stateId: 'kelantan',
    emoji: '🍗',
    colorValue: 0xFFC0392B,
    description: LocalizedText(
      'Grilled chicken basted with a rich, spiced coconut gravy.',
      'Ayam bakar yang disapu kuah santan berempah yang pekat.',
    ),
    ingredients: ['Chicken', 'Coconut milk', 'Lemongrass', 'Chilli', 'Spices'],
    culturalFact: LocalizedText(
      '“Percik” means to splash — the gravy is splashed on repeatedly while grilling.',
      '“Percik” bermaksud memercik — kuah dipercik berulang kali semasa dibakar.',
    ),
  ),

  // ───────────── TERENGGANU ─────────────
  FoodItem(
    id: 'keropok_lekor',
    name: 'Keropok Lekor',
    stateId: 'terengganu',
    emoji: '🍤',
    colorValue: 0xFFC9A26B,
    description: LocalizedText(
      'Chewy fish sausages made from fish and sago flour, boiled then fried.',
      'Keropok ikan kenyal daripada ikan dan tepung sagu, direbus lalu digoreng.',
    ),
    ingredients: ['Fish', 'Sago flour', 'Salt'],
    culturalFact: LocalizedText(
      'An iconic coastal snack, usually eaten with a sweet chilli dip.',
      'Snek ikonik pantai timur, biasanya dicicah sos cili manis.',
    ),
  ),
  FoodItem(
    id: 'sata',
    name: 'Sata',
    stateId: 'terengganu',
    emoji: '🍢',
    colorValue: 0xFF7FA650,
    description: LocalizedText(
      'Spiced fish and coconut wrapped in banana leaf, skewered and grilled.',
      'Ikan dan kelapa berempah dibalut daun pisang, dicucuk lidi dan dibakar.',
    ),
    ingredients: ['Fish', 'Grated coconut', 'Chilli', 'Banana leaf'],
    culturalFact: LocalizedText(
      'The triangular banana-leaf parcels are a familiar roadside sight on the east coast.',
      'Bungkusan segi tiga daun pisang ini biasa dilihat di tepi jalan pantai timur.',
    ),
  ),
  FoodItem(
    id: 'nasi_dagang',
    name: 'Nasi Dagang',
    stateId: 'terengganu',
    emoji: '🍛',
    colorValue: 0xFFD4A15A,
    description: LocalizedText(
      'Rice steamed with coconut milk and fenugreek, served with tuna curry.',
      'Nasi dikukus dengan santan dan halba, dihidang bersama gulai ikan tongkol.',
    ),
    ingredients: ['Rice', 'Coconut milk', 'Fenugreek', 'Tuna curry', 'Pickles'],
    culturalFact: LocalizedText(
      'A beloved breakfast across the east coast; styles differ between states.',
      'Sarapan kegemaran di pantai timur; gayanya berbeza antara negeri.',
    ),
  ),
  FoodItem(
    id: 'laksam',
    name: 'Laksam',
    stateId: 'terengganu',
    emoji: '🍜',
    colorValue: 0xFFEDE0C8,
    description: LocalizedText(
      'Rolled flat rice noodles in a creamy fish and coconut-milk gravy.',
      'Mi beras leper yang digulung dalam kuah ikan dan santan yang lemak.',
    ),
    ingredients: ['Rice flour sheets', 'Fish', 'Coconut milk', 'Ulam herbs'],
    culturalFact: LocalizedText(
      'Shared by Kelantan and Terengganu; the noodles are steamed sheets rolled by hand.',
      'Dikongsi oleh Kelantan dan Terengganu; mi dikukus berkeping lalu digulung.',
    ),
  ),

  // ───────────── PENANG ─────────────
  FoodItem(
    id: 'pasembur',
    name: 'Pasembur',
    stateId: 'penang',
    emoji: '🥗',
    colorValue: 0xFFE07B39,
    description: LocalizedText(
      'A salad of cucumber, fritters, tofu and egg under a sweet-spicy peanut sauce.',
      'Salad timun, cucur, tauhu dan telur dengan kuah kacang manis pedas.',
    ),
    ingredients: ['Cucumber', 'Fritters', 'Tofu', 'Egg', 'Peanut sauce'],
    culturalFact: LocalizedText(
      'Closely linked to Penang’s Indian-Muslim (Mamak) food heritage.',
      'Berkait rapat dengan warisan makanan India-Muslim (Mamak) di Pulau Pinang.',
    ),
  ),
  FoodItem(
    id: 'char_kuey_teow',
    name: 'Char Kuey Teow',
    stateId: 'penang',
    emoji: '🍝',
    colorValue: 0xFF9C5B2E,
    description: LocalizedText(
      'Flat rice noodles stir-fried over high heat with prawns, egg and bean sprouts.',
      'Kuey teow digoreng api besar bersama udang, telur dan taugeh.',
    ),
    ingredients: ['Flat rice noodles', 'Prawns', 'Egg', 'Bean sprouts', 'Chives'],
    culturalFact: LocalizedText(
      'Prized for “wok hei”, the smoky aroma from a very hot wok.',
      'Terkenal dengan aroma “wok hei” daripada kuali yang sangat panas.',
    ),
  ),
  FoodItem(
    id: 'asam_laksa',
    name: 'Asam Laksa',
    stateId: 'penang',
    emoji: '🍜',
    colorValue: 0xFFB33A3A,
    description: LocalizedText(
      'Thick rice noodles in a sour fish-and-tamarind broth with fresh herbs.',
      'Laksa tebal dalam kuah ikan dan asam jawa yang masam, dengan herba segar.',
    ),
    ingredients: ['Rice noodles', 'Mackerel', 'Tamarind', 'Torch ginger', 'Mint'],
    culturalFact: LocalizedText(
      'Often topped with a spoon of sweet prawn paste (petis or hae ko).',
      'Biasanya ditambah sesudu petis udang yang manis.',
    ),
  ),
  FoodItem(
    id: 'cendol',
    name: 'Cendol',
    stateId: 'penang',
    emoji: '🍧',
    colorValue: 0xFF6FBF4A,
    description: LocalizedText(
      'Shaved ice with green pandan jelly, coconut milk and palm sugar syrup.',
      'Ais serut dengan cendol pandan, santan dan sirap gula melaka.',
    ),
    ingredients: ['Pandan jelly', 'Coconut milk', 'Palm sugar', 'Shaved ice'],
    culturalFact: LocalizedText(
      'Enjoyed nationwide; Penang street stalls are especially well known for it.',
      'Dinikmati di seluruh negara; gerai tepi jalan di Pulau Pinang terkenal dengannya.',
    ),
  ),

  // ───────────── MELAKA ─────────────
  FoodItem(
    id: 'kuih_keria',
    name: 'Kuih Keria',
    stateId: 'melaka',
    emoji: '🍩',
    colorValue: 0xFFB0703C,
    description: LocalizedText(
      'Sweet-potato doughnuts glazed in crunchy palm sugar.',
      'Kuih keledek berbentuk cincin yang disalut gula melaka.',
    ),
    ingredients: ['Sweet potato', 'Flour', 'Palm sugar'],
    culturalFact: LocalizedText(
      'Melaka’s gula melaka gives the glaze its deep caramel flavour.',
      'Gula melaka memberikan rasa karamel yang dalam pada salutannya.',
    ),
  ),
  FoodItem(
    id: 'asam_pedas',
    name: 'Asam Pedas',
    stateId: 'melaka',
    emoji: '🐟',
    colorValue: 0xFFD9483B,
    description: LocalizedText(
      'Fish cooked in a sour and spicy tamarind gravy with okra.',
      'Ikan dimasak dalam kuah asam jawa yang masam pedas bersama bendi.',
    ),
    ingredients: ['Fish', 'Tamarind', 'Chilli paste', 'Okra', 'Daun kesum'],
    culturalFact: LocalizedText(
      'Many families in Melaka and Johor have their own treasured version.',
      'Ramai keluarga di Melaka dan Johor mempunyai resipi tersendiri.',
    ),
  ),
  FoodItem(
    id: 'chicken_rice_ball',
    name: 'Chicken Rice Ball',
    stateId: 'melaka',
    emoji: '🍙',
    colorValue: 0xFFF0E6D2,
    description: LocalizedText(
      'Fragrant chicken rice shaped into balls, served with chicken and chilli sauce.',
      'Nasi ayam wangi yang dibentuk bulat, dihidang dengan ayam dan sos cili.',
    ),
    ingredients: ['Rice', 'Chicken stock', 'Chicken', 'Chilli sauce'],
    culturalFact: LocalizedText(
      'A signature of Melaka’s historic Jonker Street area.',
      'Hidangan ikonik kawasan bersejarah Jonker Street, Melaka.',
    ),
  ),
  FoodItem(
    id: 'satay_celup',
    name: 'Satay Celup',
    stateId: 'melaka',
    emoji: '🍢',
    colorValue: 0xFFE5823A,
    description: LocalizedText(
      'Skewered seafood and vegetables dipped into a pot of bubbling peanut sauce.',
      'Makanan laut dan sayur bercucuk yang dicelup ke dalam periuk kuah kacang.',
    ),
    ingredients: ['Assorted skewers', 'Peanut sauce', 'Chilli'],
    culturalFact: LocalizedText(
      'Diners pay by counting the empty skewers at the end of the meal.',
      'Pelanggan membayar dengan mengira lidi kosong selepas makan.',
    ),
  ),

  // ───────────── NEGERI SEMBILAN ─────────────
  FoodItem(
    id: 'masak_lemak_cili_api',
    name: 'Masak Lemak Cili Api',
    stateId: 'negeri_sembilan',
    emoji: '🥘',
    colorValue: 0xFFF2C12E,
    description: LocalizedText(
      'A bright yellow coconut-milk curry fired up with bird’s-eye chillies.',
      'Gulai santan kuning yang pedas dengan cili api.',
    ),
    ingredients: ['Coconut milk', 'Bird’s-eye chilli', 'Turmeric', 'Smoked meat or duck'],
    culturalFact: LocalizedText(
      'Often cooked with smoked meat (daging salai) in Negeri Sembilan.',
      'Sering dimasak bersama daging salai di Negeri Sembilan.',
    ),
  ),
  FoodItem(
    id: 'apam_johol',
    name: 'Apam Johol',
    stateId: 'negeri_sembilan',
    emoji: '🧁',
    colorValue: 0xFFE9D7B9,
    description: LocalizedText(
      'A soft steamed rice-flour cake, lightly sweet.',
      'Apam kukus tepung beras yang lembut dan sedikit manis.',
    ),
    ingredients: ['Rice flour', 'Sugar', 'Coconut milk', 'Yeast'],
    culturalFact: LocalizedText(
      'Named after the town of Johol in Negeri Sembilan.',
      'Dinamakan sempena pekan Johol di Negeri Sembilan.',
    ),
  ),
  FoodItem(
    id: 'lemang',
    name: 'Lemang',
    stateId: 'negeri_sembilan',
    emoji: '🎋',
    colorValue: 0xFF8DAA5B,
    description: LocalizedText(
      'Glutinous rice and coconut milk cooked in bamboo over an open fire.',
      'Pulut dan santan yang dimasak dalam buluh di atas api.',
    ),
    ingredients: ['Glutinous rice', 'Coconut milk', 'Banana leaf', 'Bamboo'],
    culturalFact: LocalizedText(
      'A Hari Raya favourite across Malaysia, often paired with rendang.',
      'Kegemaran Hari Raya di seluruh Malaysia, biasanya dimakan dengan rendang.',
    ),
  ),

  // ───────────── JOHOR ─────────────
  FoodItem(
    id: 'laksa_johor',
    name: 'Laksa Johor',
    stateId: 'johor',
    emoji: '🍝',
    colorValue: 0xFFB5652E,
    description: LocalizedText(
      'Spaghetti in a thick fish gravy with coconut milk, topped with fresh herbs.',
      'Spageti dengan kuah ikan pekat bersantan, ditabur ulam segar.',
    ),
    ingredients: ['Spaghetti', 'Fish', 'Coconut milk', 'Kerisik', 'Ulam'],
    culturalFact: LocalizedText(
      'A famous story links the use of spaghetti to Sultan Abu Bakar’s travels abroad.',
      'Kisah terkenal mengaitkan penggunaan spageti dengan lawatan Sultan Abu Bakar ke luar negara.',
    ),
  ),
  FoodItem(
    id: 'kacang_pool',
    name: 'Kacang Pool',
    stateId: 'johor',
    emoji: '🫘',
    colorValue: 0xFF7A4A2A,
    description: LocalizedText(
      'A hearty mashed fava-bean stew with egg, served with toasted bread.',
      'Kacang parang lenyek yang dimasak, dihidang dengan telur dan roti bakar.',
    ),
    ingredients: ['Fava beans', 'Minced meat', 'Egg', 'Bread', 'Lime'],
    culturalFact: LocalizedText(
      'Arrived via Middle Eastern influence and became a Johor breakfast staple.',
      'Datang melalui pengaruh Timur Tengah dan menjadi sarapan popular di Johor.',
    ),
  ),
  FoodItem(
    id: 'otak_otak',
    name: 'Otak-Otak',
    stateId: 'johor',
    emoji: '🍃',
    colorValue: 0xFFE06A2B,
    description: LocalizedText(
      'Spiced fish paste wrapped in coconut or banana leaves and grilled.',
      'Isi ikan berempah yang dibalut daun kelapa atau daun pisang dan dibakar.',
    ),
    ingredients: ['Fish', 'Chilli paste', 'Coconut milk', 'Leaves'],
    culturalFact: LocalizedText(
      'Muar in Johor is especially famous for otak-otak.',
      'Muar di Johor amat terkenal dengan otak-otaknya.',
    ),
  ),
  FoodItem(
    id: 'mee_rebus',
    name: 'Mee Rebus',
    stateId: 'johor',
    emoji: '🍜',
    colorValue: 0xFFD08A3A,
    description: LocalizedText(
      'Yellow noodles in a thick, sweet potato-based gravy with egg and lime.',
      'Mi kuning dengan kuah pekat berasaskan keledek, telur dan limau.',
    ),
    ingredients: ['Yellow noodles', 'Sweet potato gravy', 'Egg', 'Lime', 'Tofu'],
    culturalFact: LocalizedText(
      'Popular across the peninsula; Johor versions are well loved.',
      'Popular di seluruh semenanjung; versi Johor amat digemari.',
    ),
  ),

  // ───────────── PERAK ─────────────
  FoodItem(
    id: 'rendang_tok',
    name: 'Rendang Tok',
    stateId: 'perak',
    emoji: '🥘',
    colorValue: 0xFF5C3A1B,
    description: LocalizedText(
      'A dark, dry beef rendang slow-cooked for hours until rich and tender.',
      'Rendang daging kering yang dimasak perlahan berjam-jam hingga empuk.',
    ),
    ingredients: ['Beef', 'Coconut milk', 'Kerisik', 'Spices', 'Lemongrass'],
    culturalFact: LocalizedText(
      'A Perak speciality traditionally made for Hari Raya and royal events.',
      'Keistimewaan Perak yang lazimnya disediakan untuk Hari Raya dan majlis diraja.',
    ),
  ),
  FoodItem(
    id: 'ayam_tauge',
    name: 'Ayam Tauge',
    stateId: 'perak',
    emoji: '🌱',
    colorValue: 0xFFE9E1C4,
    description: LocalizedText(
      'Poached chicken served with crunchy, plump bean sprouts and rice.',
      'Ayam rebus dihidang bersama taugeh rangup yang gemuk dan nasi.',
    ),
    ingredients: ['Chicken', 'Bean sprouts', 'Soy sauce', 'Rice'],
    culturalFact: LocalizedText(
      'Ipoh’s bean sprouts are said to be extra crunchy thanks to the local water.',
      'Taugeh Ipoh dikatakan lebih rangup kerana air tempatannya.',
    ),
  ),
  FoodItem(
    id: 'kuih_bahulu',
    name: 'Kuih Bahulu',
    stateId: 'perak',
    emoji: '🍪',
    colorValue: 0xFFE3A857,
    description: LocalizedText(
      'Small, light sponge cakes baked in flower- or fish-shaped moulds.',
      'Kek span kecil yang ringan, dibakar dalam acuan bunga atau ikan.',
    ),
    ingredients: ['Eggs', 'Flour', 'Sugar'],
    culturalFact: LocalizedText(
      'A traditional kuih enjoyed in many states, especially during festive seasons.',
      'Kuih tradisional yang dinikmati di banyak negeri, terutama musim perayaan.',
    ),
  ),
  FoodItem(
    id: 'mee_udang',
    name: 'Mee Udang',
    stateId: 'perak',
    emoji: '🦐',
    colorValue: 0xFFE8603C,
    description: LocalizedText(
      'Noodles in a rich prawn broth topped with large fresh prawns.',
      'Mi dalam kuah udang pekat dengan udang besar yang segar.',
    ),
    ingredients: ['Noodles', 'Prawns', 'Prawn stock', 'Chilli'],
    culturalFact: LocalizedText(
      'Fishing villages along Perak’s coast are popular stops for mee udang.',
      'Kampung nelayan di pesisir Perak menjadi tumpuan untuk mee udang.',
    ),
  ),

  // ───────────── PAHANG ─────────────
  FoodItem(
    id: 'puding_diraja',
    name: 'Puding Diraja',
    stateId: 'pahang',
    emoji: '🍮',
    colorValue: 0xFFF5C26B,
    description: LocalizedText(
      'A royal pudding of banana, prunes and cherries with golden egg threads.',
      'Puding diraja daripada pisang, prun dan ceri dengan jala emas.',
    ),
    ingredients: ['Banana', 'Prunes', 'Cherries', 'Egg threads', 'Custard'],
    culturalFact: LocalizedText(
      'Created in the Pahang palace kitchen and now a Ramadan favourite.',
      'Dicipta di dapur istana Pahang dan kini kegemaran bulan Ramadan.',
    ),
  ),
  FoodItem(
    id: 'patin_tempoyak',
    name: 'Ikan Patin Tempoyak',
    stateId: 'pahang',
    emoji: '🐟',
    colorValue: 0xFFE8C547,
    description: LocalizedText(
      'River catfish cooked in a curry made with fermented durian.',
      'Ikan patin dimasak gulai bersama tempoyak (durian yang diperam).',
    ),
    ingredients: ['Patin fish', 'Tempoyak', 'Turmeric', 'Chilli'],
    culturalFact: LocalizedText(
      'The Pahang River is famous for its patin fish.',
      'Sungai Pahang terkenal dengan ikan patinnya.',
    ),
  ),
  FoodItem(
    id: 'nasi_kebuli',
    name: 'Nasi Kebuli',
    stateId: 'pahang',
    emoji: '🍛',
    colorValue: 0xFFCF9446,
    description: LocalizedText(
      'Spiced rice cooked in rich stock, often served at feasts.',
      'Nasi berempah yang dimasak dengan stok pekat, sering dihidang ketika kenduri.',
    ),
    ingredients: ['Rice', 'Meat stock', 'Spices', 'Raisins'],
    culturalFact: LocalizedText(
      'Has links to Arab culinary influence and is served at Pahang celebrations.',
      'Mempunyai kaitan dengan pengaruh masakan Arab dan dihidang semasa sambutan di Pahang.',
    ),
  ),

  // ───────────── KEDAH ─────────────
  FoodItem(
    id: 'laksa_kedah',
    name: 'Laksa Kedah',
    stateId: 'kedah',
    emoji: '🍜',
    colorValue: 0xFF9E4B3A,
    description: LocalizedText(
      'Rice noodles in a tangy fish broth, topped with herbs and boiled egg.',
      'Laksa dalam kuah ikan yang masam, ditabur herba dan telur rebus.',
    ),
    ingredients: ['Rice noodles', 'Fish', 'Tamarind', 'Egg', 'Herbs'],
    culturalFact: LocalizedText(
      'Northern laksa styles vary from town to town.',
      'Gaya laksa utara berbeza dari satu pekan ke pekan yang lain.',
    ),
  ),
  FoodItem(
    id: 'peknga',
    name: 'Peknga',
    stateId: 'kedah',
    emoji: '🍰',
    colorValue: 0xFFD7A25A,
    description: LocalizedText(
      'A traditional baked cake with a sweet, slightly chewy texture.',
      'Kuih bakar tradisional yang manis dan sedikit kenyal.',
    ),
    ingredients: ['Flour', 'Eggs', 'Sugar', 'Coconut milk'],
    culturalFact: LocalizedText(
      'A heritage kuih from Kedah that is still made in some villages.',
      'Kuih warisan Kedah yang masih dibuat di beberapa kampung.',
    ),
  ),
  FoodItem(
    id: 'nasi_ulam',
    name: 'Nasi Ulam',
    stateId: 'kedah',
    emoji: '🌿',
    colorValue: 0xFF6E9B3A,
    description: LocalizedText(
      'Rice tossed with finely sliced fresh herbs, fish and kerisik.',
      'Nasi digaul dengan ulam yang dihiris halus, ikan dan kerisik.',
    ),
    ingredients: ['Rice', 'Fresh herbs', 'Fish', 'Kerisik'],
    culturalFact: LocalizedText(
      'Celebrates the variety of herbs grown around paddy-field villages.',
      'Meraikan kepelbagaian ulam yang tumbuh di sekitar kampung sawah padi.',
    ),
  ),

  // ───────────── PERLIS ─────────────
  FoodItem(
    id: 'pulut_mempelam',
    name: 'Pulut Mempelam',
    stateId: 'perlis',
    emoji: '🥭',
    colorValue: 0xFFF3B23A,
    description: LocalizedText(
      'Sweet coconut glutinous rice served with ripe mango.',
      'Pulut santan yang manis dihidang bersama mempelam masak.',
    ),
    ingredients: ['Glutinous rice', 'Coconut milk', 'Mango', 'Sugar'],
    culturalFact: LocalizedText(
      'Best when Perlis mangoes are in season.',
      'Paling sedap ketika musim mempelam Perlis.',
    ),
  ),
  FoodItem(
    id: 'harumanis',
    name: 'Harumanis',
    stateId: 'perlis',
    emoji: '🥭',
    colorValue: 0xFF9CBF3A,
    description: LocalizedText(
      'Perlis’s famous fragrant, sweet mango variety.',
      'Varieti mempelam Perlis yang terkenal dengan aroma dan rasa manisnya.',
    ),
    ingredients: ['Harumanis mango'],
    culturalFact: LocalizedText(
      'Harumanis from Perlis has Geographical Indication status in Malaysia.',
      'Harumanis Perlis mempunyai status Petunjuk Geografi di Malaysia.',
    ),
  ),
  FoodItem(
    id: 'bihun_sup',
    name: 'Bihun Sup',
    stateId: 'perlis',
    emoji: '🍲',
    colorValue: 0xFFC9B48A,
    description: LocalizedText(
      'Rice vermicelli in a peppery beef or chicken soup.',
      'Bihun dalam sup daging atau ayam berlada.',
    ),
    ingredients: ['Rice vermicelli', 'Beef or chicken', 'Spices', 'Fried shallots'],
    culturalFact: LocalizedText(
      'A favourite breakfast across the northern states.',
      'Sarapan kegemaran di negeri-negeri utara.',
    ),
  ),

  // ───────────── SELANGOR ─────────────
  FoodItem(
    id: 'satay',
    name: 'Satay',
    stateId: 'selangor',
    emoji: '🍢',
    colorValue: 0xFFB8562B,
    description: LocalizedText(
      'Marinated meat skewers grilled over charcoal, served with peanut sauce.',
      'Daging perap bercucuk yang dibakar atas arang, dengan kuah kacang.',
    ),
    ingredients: ['Chicken or beef', 'Turmeric', 'Lemongrass', 'Peanut sauce', 'Ketupat'],
    culturalFact: LocalizedText(
      'Kajang in Selangor is especially famous for its satay.',
      'Kajang di Selangor amat terkenal dengan satenya.',
    ),
  ),
  FoodItem(
    id: 'lontong',
    name: 'Lontong',
    stateId: 'selangor',
    emoji: '🥣',
    colorValue: 0xFFE6B84A,
    description: LocalizedText(
      'Compressed rice cakes in a vegetable coconut-milk gravy.',
      'Nasi impit dalam kuah sayur bersantan.',
    ),
    ingredients: ['Rice cakes', 'Coconut milk', 'Vegetables', 'Sambal'],
    culturalFact: LocalizedText(
      'Shows Javanese influence and is popular in Selangor and Johor.',
      'Menunjukkan pengaruh Jawa dan popular di Selangor serta Johor.',
    ),
  ),
  FoodItem(
    id: 'nasi_lemak',
    name: 'Nasi Lemak',
    stateId: 'selangor',
    emoji: '🍚',
    colorValue: 0xFFF5EBD3,
    description: LocalizedText(
      'Coconut rice with sambal, fried anchovies, peanuts, cucumber and egg.',
      'Nasi santan dengan sambal, ikan bilis, kacang, timun dan telur.',
    ),
    ingredients: ['Rice', 'Coconut milk', 'Sambal', 'Anchovies', 'Peanuts', 'Egg'],
    culturalFact: LocalizedText(
      'Often described as Malaysia’s national dish.',
      'Sering digelar hidangan kebangsaan Malaysia.',
    ),
  ),
  FoodItem(
    id: 'teh_tarik',
    name: 'Teh Tarik',
    stateId: 'selangor',
    emoji: '☕',
    colorValue: 0xFFB07A4C,
    description: LocalizedText(
      'Sweet milk tea “pulled” between cups to make it frothy.',
      'Teh susu manis yang “ditarik” antara cawan sehingga berbuih.',
    ),
    ingredients: ['Black tea', 'Condensed milk'],
    culturalFact: LocalizedText(
      'The pulling technique cools the tea and creates its famous foam.',
      'Teknik menarik menyejukkan teh dan menghasilkan buih yang terkenal.',
    ),
  ),

  // ───────────── KUALA LUMPUR ─────────────
  FoodItem(
    id: 'roti_canai',
    name: 'Roti Canai',
    stateId: 'kuala_lumpur',
    emoji: '🫓',
    colorValue: 0xFFE9C46A,
    description: LocalizedText(
      'Flaky, buttery flatbread served with dhal or curry.',
      'Roti nipis berlapis yang rangup, dihidang dengan kuah dal atau kari.',
    ),
    ingredients: ['Flour', 'Ghee', 'Egg', 'Dhal curry'],
    culturalFact: LocalizedText(
      'A mamak-stall classic, eaten at any hour across the city.',
      'Hidangan klasik kedai mamak, dimakan pada bila-bila masa di seluruh kota.',
    ),
  ),
  FoodItem(
    id: 'hokkien_mee',
    name: 'Hokkien Mee',
    stateId: 'kuala_lumpur',
    emoji: '🍜',
    colorValue: 0xFF3D2B1F,
    description: LocalizedText(
      'Thick yellow noodles fried in dark soy sauce with prawns and greens.',
      'Mi kuning tebal digoreng dengan kicap pekat, udang dan sayur.',
    ),
    ingredients: ['Thick noodles', 'Dark soy sauce', 'Prawns', 'Cabbage'],
    culturalFact: LocalizedText(
      'KL-style Hokkien mee is dark and saucy, unlike Penang’s prawn soup version.',
      'Hokkien mee gaya KL berwarna gelap dan berkuah pekat, berbeza dengan versi sup udang Pulau Pinang.',
    ),
  ),
  FoodItem(
    id: 'pan_mee',
    name: 'Pan Mee',
    stateId: 'kuala_lumpur',
    emoji: '🥢',
    colorValue: 0xFFD9C5A0,
    description: LocalizedText(
      'Hand-torn or flat noodles with minced meat, anchovies and a fiery chilli.',
      'Mi tarik tangan dengan daging cincang, ikan bilis dan cili api.',
    ),
    ingredients: ['Wheat noodles', 'Minced meat', 'Anchovies', 'Sweet potato leaves', 'Chilli'],
    culturalFact: LocalizedText(
      'Chilli pan mee became a KL favourite in the 2000s.',
      'Pan mee cili menjadi kegemaran warga KL sejak tahun 2000-an.',
    ),
  ),
  FoodItem(
    id: 'apam_balik',
    name: 'Apam Balik',
    stateId: 'kuala_lumpur',
    emoji: '🥞',
    colorValue: 0xFFC98B3C,
    description: LocalizedText(
      'A folded pancake filled with crushed peanuts, sugar and sweet corn.',
      'Lempeng lipat berinti kacang tumbuk, gula dan jagung manis.',
    ),
    ingredients: ['Flour', 'Egg', 'Peanuts', 'Sugar', 'Sweet corn'],
    culturalFact: LocalizedText(
      'A must-buy snack at every pasar malam in the city.',
      'Snek wajib dibeli di setiap pasar malam di kota.',
    ),
  ),

  // ───────────── SABAH ─────────────
  FoodItem(
    id: 'kuih_cincin',
    name: 'Kuih Cincin',
    stateId: 'sabah',
    emoji: '🥨',
    colorValue: 0xFF8E5A2E,
    description: LocalizedText(
      'Crunchy ring-shaped snacks made from rice flour and palm sugar.',
      'Kuih rangup berbentuk cincin daripada tepung beras dan gula kabung.',
    ),
    ingredients: ['Rice flour', 'Palm sugar', 'Oil'],
    culturalFact: LocalizedText(
      'A traditional snack of Sabah’s Bruneian Malay community, served at festivals.',
      'Kuih tradisional masyarakat Melayu Brunei di Sabah, dihidang ketika perayaan.',
    ),
  ),
  FoodItem(
    id: 'amplang',
    name: 'Amplang',
    stateId: 'sabah',
    emoji: '🍘',
    colorValue: 0xFFE8CF9A,
    description: LocalizedText(
      'Light, crispy fish crackers with a savoury crunch.',
      'Keropok ikan yang ringan dan rangup.',
    ),
    ingredients: ['Fish', 'Tapioca flour', 'Garlic'],
    culturalFact: LocalizedText(
      'A popular souvenir snack from Tawau and the east of Sabah.',
      'Snek cenderamata popular dari Tawau dan pantai timur Sabah.',
    ),
  ),
  FoodItem(
    id: 'hinava',
    name: 'Hinava',
    stateId: 'sabah',
    emoji: '🐠',
    colorValue: 0xFFF0F0E0,
    description: LocalizedText(
      'Fresh raw fish “cooked” in lime juice with chilli, ginger and shallots.',
      'Ikan mentah segar yang “dimasak” dengan jus limau, cili, halia dan bawang.',
    ),
    ingredients: ['Mackerel', 'Lime juice', 'Chilli', 'Ginger', 'Bambangan seed'],
    culturalFact: LocalizedText(
      'A traditional dish of the Kadazandusun community.',
      'Hidangan tradisional masyarakat Kadazandusun.',
    ),
  ),
  FoodItem(
    id: 'tuaran_mee',
    name: 'Tuaran Mee',
    stateId: 'sabah',
    emoji: '🍝',
    colorValue: 0xFFE8B04A,
    description: LocalizedText(
      'Springy egg noodles stir-fried with vegetables and meat.',
      'Mi telur kenyal yang digoreng bersama sayur dan daging.',
    ),
    ingredients: ['Egg noodles', 'Vegetables', 'Egg', 'Meat'],
    culturalFact: LocalizedText(
      'Named after the town of Tuaran near Kota Kinabalu.',
      'Dinamakan sempena pekan Tuaran berhampiran Kota Kinabalu.',
    ),
  ),

  // ───────────── SARAWAK ─────────────
  FoodItem(
    id: 'kek_lapis',
    name: 'Kek Lapis Sarawak',
    stateId: 'sarawak',
    emoji: '🍰',
    colorValue: 0xFFD9405E,
    description: LocalizedText(
      'A colourful layered cake with intricate patterns, baked layer by layer.',
      'Kek berlapis berwarna-warni dengan corak rumit, dibakar lapis demi lapis.',
    ),
    ingredients: ['Butter', 'Eggs', 'Flour', 'Condensed milk', 'Flavourings'],
    culturalFact: LocalizedText(
      'A must-have during festive open houses in Sarawak.',
      'Wajib ada semasa rumah terbuka sempena perayaan di Sarawak.',
    ),
  ),
  FoodItem(
    id: 'laksa_sarawak',
    name: 'Laksa Sarawak',
    stateId: 'sarawak',
    emoji: '🍜',
    colorValue: 0xFFC9662E,
    description: LocalizedText(
      'Rice vermicelli in a sambal-belacan and coconut broth with prawns and chicken.',
      'Bihun dalam kuah rempah dan santan dengan udang dan ayam.',
    ),
    ingredients: ['Rice vermicelli', 'Laksa paste', 'Coconut milk', 'Prawns', 'Egg'],
    culturalFact: LocalizedText(
      'A beloved breakfast in Kuching, often eaten with a squeeze of lime.',
      'Sarapan kegemaran di Kuching, biasanya diperah limau.',
    ),
  ),
  FoodItem(
    id: 'manok_pansoh',
    name: 'Manok Pansoh',
    stateId: 'sarawak',
    emoji: '🎍',
    colorValue: 0xFF7DA34A,
    description: LocalizedText(
      'Chicken cooked inside bamboo with lemongrass, ginger and tapioca leaves.',
      'Ayam dimasak dalam buluh bersama serai, halia dan daun ubi.',
    ),
    ingredients: ['Chicken', 'Bamboo', 'Lemongrass', 'Ginger', 'Tapioca leaves'],
    culturalFact: LocalizedText(
      'A traditional Iban dish, especially during Gawai celebrations.',
      'Hidangan tradisional kaum Iban, terutama semasa sambutan Gawai.',
    ),
  ),
  FoodItem(
    id: 'kolo_mee',
    name: 'Kolo Mee',
    stateId: 'sarawak',
    emoji: '🍝',
    colorValue: 0xFFE3C17A,
    description: LocalizedText(
      'Springy egg noodles tossed in a light dressing with minced meat.',
      'Mi telur kenyal yang digaul dengan kuah ringan dan daging cincang.',
    ),
    ingredients: ['Egg noodles', 'Minced meat', 'Shallot oil', 'Spring onion'],
    culturalFact: LocalizedText(
      'A Kuching classic, with halal versions using chicken or beef.',
      'Hidangan klasik Kuching, dengan versi halal menggunakan ayam atau daging.',
    ),
  ),
];

final Map<String, FoodItem> foodsById = {for (final f in allFoods) f.id: f};

FoodItem? foodById(String id) => foodsById[id];
