class VaccineInfo {
  final String productName;
  final String manufacturer;
  final String name;
  final String description;

  const VaccineInfo({
    required this.productName,
    required this.manufacturer,
    required this.name,
    required this.description,
  });
}

const List<VaccineInfo> vaccines = [
  // MSD Animal Health
  VaccineInfo(
    productName: 'Nobivac® DHPPi',
    manufacturer: 'MSD Animal Health New Zealand',
    name: 'Canine DHPPi (core multivalent)',
    description: 'Live-attenuated vaccine for distemper, adenovirus, parvovirus, and parainfluenza.',
  ),
  VaccineInfo(
    productName: 'Nobivac® Lepto 1',
    manufacturer: 'MSD Animal Health New Zealand',
    name: 'Leptospira (inactivated)',
    description: 'Inactivated vaccine for leptospirosis (Serovar Copenhageni).',
  ),
  VaccineInfo(
    productName: 'Nobivac® KC',
    manufacturer: 'MSD Animal Health New Zealand',
    name: 'Canine KC – Kennel Cough (intranasal)',
    description: 'Live intranasal vaccine for Bordetella bronchiseptica and parainfluenza.',
  ),
  VaccineInfo(
    productName: 'Nobivac® Canine Oral Bb',
    manufacturer: 'MSD Animal Health New Zealand',
    name: 'Oral Bb – Kennel Cough (oral)',
    description: 'Oral live vaccine for Bordetella bronchiseptica (kennel cough protection).',
  ),

  // Zoetis
  VaccineInfo(
    productName: 'Vanguard® Plus 5',
    manufacturer: 'Zoetis New Zealand',
    name: 'Canine DHPPi (core multivalent)',
    description: 'Live-attenuated vaccine protecting against distemper, adenovirus, parvovirus, and parainfluenza.',
  ),
  VaccineInfo(
    productName: 'Vanguard® Lepto',
    manufacturer: 'Zoetis New Zealand',
    name: 'Leptospira (inactivated)',
    description: 'Inactivated vaccine for leptospirosis (Serovar Copenhageni).',
  ),
  VaccineInfo(
    productName: 'Vanguard® Bb Oral',
    manufacturer: 'Zoetis New Zealand',
    name: 'Oral Bb – Kennel Cough (oral)',
    description: 'Oral live vaccine for Bordetella bronchiseptica (kennel cough protection).',
  ),
  VaccineInfo(
    productName: 'Vanguard® KC',
    manufacturer: 'Zoetis New Zealand',
    name: 'Canine KC – Kennel Cough (intranasal)',
    description: 'Intranasal vaccine for Bordetella bronchiseptica and parainfluenza.',
  ),

  // Virbac
  VaccineInfo(
    productName: 'Canigen® DHPPi',
    manufacturer: 'Virbac New Zealand',
    name: 'Canine DHPPi (core multivalent)',
    description: 'Live-attenuated vaccine protecting against distemper, adenovirus, parvovirus, and parainfluenza.',
  ),
  VaccineInfo(
    productName: 'Canigen® Lepto',
    manufacturer: 'Virbac New Zealand',
    name: 'Leptospira (inactivated)',
    description: 'Inactivated vaccine for leptospirosis.',
  ),
  VaccineInfo(
    productName: 'Canigen® KC',
    manufacturer: 'Virbac New Zealand',
    name: 'Canine KC – Kennel Cough (intranasal)',
    description: 'Intranasal vaccine for Bordetella bronchiseptica and parainfluenza.',
  ),
];
