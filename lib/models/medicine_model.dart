// medicine_model.dart

class MedicineModel {
  final int id;
  final String name;
  final String mainUse;
  final String description; // وصف تفصيلي (يشمل الاستخدام والآثار الجانبية)
  final String imagePathNote; // مسار الصورة في مجلد assets
  final String priceNote; // السعر الافتراضي (مثلاً $ 45.00)
  final String quantityPcs; // عدد الحبات أو الكمية في العبوة

  MedicineModel({
    required this.id,
    required this.name,
    required this.mainUse,
    required this.description, // تم إضافة هذا الحقل
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
    description:
        '**Active Ingredient:** Paracetamol/Acetaminophen. **Usage Time:** Can be taken every 4-6 hours as needed. **Side Effects:** Generally safe when used correctly. Rare liver damage with overdose. **Note:** Do not exceed the maximum daily dose (usually 4g).',
    imagePathNote: 'assets/medicines/1.jpg',
    priceNote: '\$ 30.00',
    quantityPcs: '20 tabs',
  ),
  MedicineModel(
    id: 2,
    name: 'Brufen',
    mainUse: 'Pain, inflammation, and fever (NSAID).',
    description:
        '**Active Ingredient:** Ibuprofen. **Usage Time:** Taken with food or milk to reduce stomach irritation. **Side Effects:** Nausea, stomach upset, heartburn. Prolonged use may affect the kidneys/stomach lining. **Note:** Avoid if you have stomach ulcers or severe heart failure.',
    imagePathNote: 'assets/medicines/unnamed.png',
    priceNote: '\$ 45.50',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 3,
    name: 'Augmentin',
    mainUse: 'Treating bacterial infections (Antibiotic).',
    description:
        '**Active Ingredient:** Amoxicillin and Clavulanic Acid. **Usage Time:** Take at the start of a meal for best absorption and reduced stomach upset. **Side Effects:** Diarrhea, nausea, vomiting, fungal infections (Thrush). **Note:** Complete the full course of treatment even if symptoms improve.',
    imagePathNote: 'assets/medicines/Augmentin-625mg-20-Tablets.png',
    priceNote: '\$ 85.00',
    quantityPcs: '14 tabs',
  ),
  MedicineModel(
    id: 4,
    name: 'Controloc',
    mainUse: 'Treating heartburn, GERD, and stomach ulcers.',
    description:
        '**Active Ingredient:** Pantoprazole (PPI). **Usage Time:** Take once daily, usually in the morning before breakfast. **Side Effects:** Headache, diarrhea, dizziness. Long-term use requires monitoring for mineral deficiencies. **Note:** Provides relief by reducing stomach acid production.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 174959.png',
    priceNote: '\$ 110.75',
    quantityPcs: '28 tabs',
  ),
  MedicineModel(
    id: 5,
    name: 'Voltaren',
    mainUse: 'Pain and inflammation relief (NSAID).',
    description:
        '**Active Ingredient:** Diclofenac. **Usage Time:** Take with or immediately after food. **Side Effects:** Gastrointestinal issues (pain, bleeding), rash, fluid retention. **Note:** Similar risks to Ibuprofen; use the lowest effective dose for the shortest duration.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175101.png',
    priceNote: '\$ 38.00',
    quantityPcs: '20 tabs',
  ),
  MedicineModel(
    id: 6,
    name: 'Lipitor',
    mainUse: 'Lowering high cholesterol levels.',
    description:
        '**Active Ingredient:** Atorvastatin (Statin). **Usage Time:** Usually taken once daily, often in the evening, with or without food. **Side Effects:** Muscle pain (myalgia), headache, liver enzyme elevation. **Note:** Requires regular blood tests to monitor liver function.',
    imagePathNote: 'assets/medicines/PhotoRoom-20240813_111623_24.png',
    priceNote: '\$ 150.00',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 7,
    name: 'Diamicron',
    mainUse: 'Treating Type 2 Diabetes Mellitus.',
    description:
        '**Active Ingredient:** Gliclazide (Sulfonylurea). **Usage Time:** Taken with breakfast and/or main meals. **Side Effects:** Hypoglycemia (low blood sugar), weight gain. **Note:** Patients must monitor blood sugar levels and maintain regular meals.',
    imagePathNote: 'assets/medicines/product_44.jpg',
    priceNote: '\$ 70.25',
    quantityPcs: '60 tabs',
  ),
  MedicineModel(
    id: 8,
    name: 'Cafigen',
    mainUse: 'Treating migraine and tension headaches.',
    description:
        '**Active Ingredient:** Ergotamine and Caffeine. **Usage Time:** Take immediately at the first sign of a migraine. Do not use daily. **Side Effects:** Nausea, vomiting, numbness/tingling in fingers/toes. **Note:** Not for prevention; strictly for acute treatment. Limit use to avoid rebound headaches.',
    imagePathNote: 'assets/medicines/caffeine200.jpg',
    priceNote: '\$ 25.00',
    quantityPcs: '12 tabs',
  ),
  MedicineModel(
    id: 9,
    name: 'Concor',
    mainUse: 'Managing high blood pressure and angina.',
    description:
        '**Active Ingredient:** Bisoprolol (Beta-Blocker). **Usage Time:** Once daily, usually in the morning. **Side Effects:** Slow heart rate, fatigue, dizziness, cold hands/feet. **Note:** Do not stop taking abruptly, as this can worsen heart conditions. Not suitable for certain asthma types.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175320.png',
    priceNote: '\$ 95.00',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 10,
    name: 'Buscopan',
    mainUse: 'Relieving abdominal cramps and spasms.',
    description:
        '**Active Ingredient:** Hyoscine Butylbromide (Antispasmodic). **Usage Time:** Taken as needed for cramp relief. **Side Effects:** Dry mouth, blurred vision, constipation, fast heart rate. **Note:** Should not be used if you have glaucoma or an enlarged prostate.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175339.png',
    priceNote: '\$ 42.00',
    quantityPcs: '20 tabs',
  ),
  MedicineModel(
    id: 11,
    name: 'Vitrac',
    mainUse: 'Treating allergy symptoms (Antihistamine).',
    description:
        '**Active Ingredient:** Cetirizine (Second-generation antihistamine). **Usage Time:** Once daily, usually in the evening. **Side Effects:** Drowsiness (less than first-generation), dry mouth, headache. **Note:** Generally non-drowsy but use caution when driving initially.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175414.png',
    priceNote: '\$ 60.50',
    quantityPcs: '10 caps',
  ),
  MedicineModel(
    id: 12,
    name: 'Marvelon',
    mainUse: 'Oral contraception (Birth Control Pills).',
    description:
        '**Active Ingredient:** Ethinylestradiol and Desogestrel (Combined hormonal pill). **Usage Time:** Take one tablet daily, starting on the first day of the cycle. **Side Effects:** Nausea, breast tenderness, headache, mood changes. Serious risk of blood clots. **Note:** Requires consistent, daily use for effectiveness.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175437.png',
    priceNote: '\$ 55.00',
    quantityPcs: '21 tabs',
  ),
  MedicineModel(
    id: 13,
    name: 'Nexium',
    mainUse: 'Treating acid reflux (GERD) and stomach ulcers.',
    description:
        '**Active Ingredient:** Esomeprazole (PPI). **Usage Time:** Once daily, at least one hour before a meal. **Side Effects:** Similar to Controloc: headache, nausea, gas. **Note:** Do not crush or chew the capsule/tablet; swallow whole.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175457.png',
    priceNote: '\$ 120.00',
    quantityPcs: '14 caps',
  ),
  MedicineModel(
    id: 14,
    name: 'Cataflam',
    mainUse: 'Fast relief of pain and inflammation.',
    description:
        '**Active Ingredient:** Diclofenac Potassium (NSAID). **Usage Time:** Can be taken every 8 hours as needed. Better absorbed on an empty stomach for faster effect. **Side Effects:** Stomach upset, dizziness. **Note:** Rapid-acting formulation, commonly used for dental pain or acute injury.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175522.png',
    priceNote: '\$ 33.75',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 15,
    name: 'Ciprofloxacin',
    mainUse: 'Treating various bacterial infections (Antibiotic).',
    description:
        '**Active Ingredient:** Ciprofloxacin (Fluoroquinolone). **Usage Time:** Usually twice daily. Avoid taking with dairy products or antacids. **Side Effects:** Nausea, diarrhea, tendon problems (rare but serious), confusion. **Note:** Can increase sun sensitivity; use sunscreen.',
    imagePathNote: 'assets/medicines/3D Box Cipro 500.png',
    priceNote: '\$ 65.00',
    quantityPcs: '10 tabs',
  ),
  MedicineModel(
    id: 16,
    name: 'Flumox',
    mainUse: 'Treating bacterial infections (Antibiotic).',
    description:
        '**Active Ingredient:** Flucloxacillin (Penicillin). **Usage Time:** Take 30-60 minutes before food for best absorption. **Side Effects:** Nausea, diarrhea, rash. **Note:** Tell your doctor if you have a known penicillin allergy.',
    imagePathNote: 'assets/medicines/ImageSmall_Path16.png',
    priceNote: '\$ 75.00',
    quantityPcs: '12 caps',
  ),
  MedicineModel(
    id: 17,
    name: 'Vitamin C Eff.',
    mainUse: 'Dietary supplement, boosting immunity.',
    description:
        '**Active Ingredient:** Ascorbic Acid. **Usage Time:** Dissolve in water and drink once daily. **Side Effects:** High doses may cause diarrhea or stomach upset. **Note:** Effervescent form provides quick hydration and may be gentler on the stomach.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175647.png',
    priceNote: '\$ 28.50',
    quantityPcs: '10 eff. tabs',
  ),
  MedicineModel(
    id: 18,
    name: 'Amoxil',
    mainUse: 'Treating bacterial infections (Antibiotic).',
    description:
        '**Active Ingredient:** Amoxicillin (Penicillin). **Usage Time:** Can be taken with or without food, usually 2-3 times a day. **Side Effects:** Rash, diarrhea, nausea. **Note:** A common, broad-spectrum antibiotic. Complete the full course.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175725.png',
    priceNote: '\$ 50.00',
    quantityPcs: '16 caps',
  ),
  MedicineModel(
    id: 19,
    name: 'Seroxat',
    mainUse: 'Treating depression and anxiety disorders (SSRI).',
    description:
        '**Active Ingredient:** Paroxetine (SSRI). **Usage Time:** Once daily, usually in the morning. **Side Effects:** Nausea, insomnia, sexual dysfunction, weight changes. **Note:** Takes several weeks to show full effect. Do not stop abruptly; gradual tapering is essential.',
    imagePathNote: 'assets/medicines/SEROXAT.png',
    priceNote: '\$ 140.00',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 20,
    name: 'Nizoral',
    mainUse: 'Treating fungal infections.',
    description:
        '**Active Ingredient:** Ketoconazole (Antifungal). **Usage Time:** Typically once daily with a meal. **Side Effects:** Nausea, vomiting. Can cause serious liver problems (rare). **Note:** Often reserved for severe fungal infections due to potential liver toxicity; requires monitoring.',
    imagePathNote: 'assets/medicines/Screenshot 2025-11-20 175808.png',
    priceNote: '\$ 48.00',
    quantityPcs: '10 tabs',
  ),
];
