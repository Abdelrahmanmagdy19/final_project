// medicine_model.dart

class MedicineModel {
  final int id;
  final String name;
  final String mainUse;
  final String imagePathNote; // مسار الصورة في مجلد assets
  final String priceNote; // السعر الافتراضي (مثلاً $ 45.00)
  final String quantityPcs; // عدد الحبات أو الكمية في العبوة

  MedicineModel({
    required this.id,
    required this.name,
    required this.mainUse,
    required this.imagePathNote,
    required this.priceNote,
    required this.quantityPcs,
  });
}

// Data List (List of MedicineModel) - القائمة الكاملة للأدوية
final List<MedicineModel> allMedications = [
  MedicineModel(
    id: 1,
    name: 'Panadol',
    mainUse: 'Pain relief and fever reduction.',
    imagePathNote: 'assets/medicines/1.jpg',
    priceNote: '\$ 30.00',
    quantityPcs: '20 tabs',
  ),
  MedicineModel(
    id: 2,
    name: 'Brufen',
    mainUse: 'Pain, inflammation, and fever (NSAID).',
    imagePathNote: 'assets/medicines/unnamed.png',
    priceNote: '\$ 45.50',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 3,
    name: 'Augmentin',
    mainUse: 'Treating bacterial infections (Antibiotic).',
    imagePathNote: 'assets/medicines/Augmentin-625mg-20-Tablets.png',
    priceNote: '\$ 85.00',
    quantityPcs: '14 tabs',
  ),
  MedicineModel(
    id: 4,
    name: 'Controloc',
    mainUse: 'Treating heartburn, GERD, and stomach ulcers.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 174959.png',
    priceNote: '\$ 110.75',
    quantityPcs: '28 tabs',
  ),
  MedicineModel(
    id: 5,
    name: 'Voltaren',
    mainUse: 'Pain and inflammation relief (NSAID).',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175101.png',
    priceNote: '\$ 38.00',
    quantityPcs: '20 tabs',
  ),
  MedicineModel(
    id: 6,
    name: 'Lipitor',
    mainUse: 'Lowering high cholesterol levels.',
    imagePathNote: 'assets/medicines/PhotoRoom-20240813_111623_24.png',
    priceNote: '\$ 150.00',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 7,
    name: 'Diamicron',
    mainUse: 'Treating Type 2 Diabetes Mellitus.',
    imagePathNote: 'assets/medicines/product_44.jpg',
    priceNote: '\$ 70.25',
    quantityPcs: '60 tabs',
  ),
  MedicineModel(
    id: 8,
    name: 'Cafigen',
    mainUse: 'Treating migraine and tension headaches.',
    imagePathNote: 'assets/medicines/caffeine200.jpg',
    priceNote: '\$ 25.00',
    quantityPcs: '12 tabs',
  ),
  MedicineModel(
    id: 9,
    name: 'Concor',
    mainUse: 'Managing high blood pressure and angina.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175320.png',
    priceNote: '\$ 95.00',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 10,
    name: 'Buscopan',
    mainUse: 'Relieving abdominal cramps and spasms.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175339.png',
    priceNote: '\$ 42.00',
    quantityPcs: '20 tabs',
  ),
  MedicineModel(
    id: 11,
    name: 'Vitrac',
    mainUse: 'Treating allergy symptoms (Antihistamine).',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175414.png',
    priceNote: '\$ 60.50',
    quantityPcs: '10 caps',
  ),
  MedicineModel(
    id: 12,
    name: 'Marvelon',
    mainUse: 'Oral contraception (Birth Control Pills).',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175437.png',
    priceNote: '\$ 55.00',
    quantityPcs: '21 tabs',
  ),
  MedicineModel(
    id: 13,
    name: 'Nexium',
    mainUse: 'Treating acid reflux (GERD) and stomach ulcers.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175457.png',
    priceNote: '\$ 120.00',
    quantityPcs: '14 caps',
  ),
  MedicineModel(
    id: 14,
    name: 'Cataflam',
    mainUse: 'Fast relief of pain and inflammation.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175522.png',
    priceNote: '\$ 33.75',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 15,
    name: 'Ciprofloxacin',
    mainUse: 'Treating various bacterial infections (Antibiotic).',
    imagePathNote: 'assets/medicines/3D Box Cipro 500.png',
    priceNote: '\$ 65.00',
    quantityPcs: '10 tabs',
  ),
  MedicineModel(
    id: 16,
    name: 'Flumox',
    mainUse: 'Treating bacterial infections (Antibiotic).',
    imagePathNote: 'assets/medicines/ImageSmall_Path16.png',
    priceNote: '\$ 75.00',
    quantityPcs: '12 caps',
  ),
  MedicineModel(
    id: 17,
    name: 'Vitamin C Eff.',
    mainUse: 'Dietary supplement, boosting immunity.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175647.png',
    priceNote: '\$ 28.50',
    quantityPcs: '10 eff. tabs',
  ),
  MedicineModel(
    id: 18,
    name: 'Amoxil',
    mainUse: 'Treating bacterial infections (Antibiotic).',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175725.png',
    priceNote: '\$ 50.00',
    quantityPcs: '16 caps',
  ),
  MedicineModel(
    id: 19,
    name: 'Seroxat',
    mainUse: 'Treating depression and anxiety disorders (SSRI).',
    imagePathNote: 'assets/medicines/SEROXAT.png',
    priceNote: '\$ 140.00',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 20,
    name: 'Nizoral',
    mainUse: 'Treating fungal infections.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175808.png',
    priceNote: '\$ 48.00',
    quantityPcs: '10 tabs',
  ),
];
