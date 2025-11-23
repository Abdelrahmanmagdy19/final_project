class MedicineModel {
  final int id;
  final String name;
  final String mainUse;
  final String description;
  final String imagePathNote;
  final String priceNote;
  final String quantityPcs;

  MedicineModel({
    required this.id,
    required this.name,
    required this.mainUse,
    required this.description,
    required this.imagePathNote,
    required this.priceNote,
    required this.quantityPcs,
  });
}

final List<MedicineModel> allMedications = [
  MedicineModel(
    id: 1,
    name: 'Panadol',
    mainUse: 'Pain relief and fever reduction.',
    description:
        '**Active Ingredient:** Paracetamol/Acetaminophen. **Usage Time:** Can be taken every 4-6 hours as needed. **Side Effects:** Generally safe when used correctly. Rare liver damage with overdose. **Note:** Do not exceed the maximum daily dose (usually 4g).',
    imagePathNote:
        'https://www.dvago.pk/_next/image?url=https%3A%2F%2Fdvago-assets.s3.ap-southeast-1.amazonaws.com%2FProductsImages%2FPanadol%2520Regular%2520600x600.jpg&w=1280&q=50',
    priceNote: '\$ 30.00',
    quantityPcs: '20 tabs',
  ),
  MedicineModel(
    id: 2,
    name: 'Brufen',
    mainUse: 'Pain, inflammation, and fever (NSAID).',
    description:
        '**Active Ingredient:** Ibuprofen. **Usage Time:** Taken with food or milk to reduce stomach irritation. **Side Effects:** Nausea, stomach upset, heartburn. Prolonged use may affect the kidneys/stomach lining. **Note:** Avoid if you have stomach ulcers or severe heart failure.',
    imagePathNote:
        'https://lh6.googleusercontent.com/proxy/uQRcEtpKh0CN_X9m4XoC-XIsU50ITQYNcXEn6YiF4wxFvvctThypADpbL0xskSrs1hM3d6mJlUmnIJ010DF1YihIVBXZ0lnDUq1jWrS_v0wQ5IZDfOQLkQ7ZrzJaTC0KwA',
    priceNote: '\$ 45.50',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 3,
    name: 'Augmentin',
    mainUse: 'Treating bacterial infections (Antibiotic).',
    description:
        '**Active Ingredient:** Amoxicillin and Clavulanic Acid. **Usage Time:** Take at the start of a meal for best absorption and reduced stomach upset. **Side Effects:** Diarrhea, nausea, vomiting, fungal infections (Thrush). **Note:** Complete the full course of treatment even if symptoms improve.',
    imagePathNote:
        'https://www.dawadose.com/wp-content/uploads/2024/10/Augmentin-625mg-20-Tablets.png',
    priceNote: '\$ 85.00',
    quantityPcs: '14 tabs',
  ),
  MedicineModel(
    id: 4,
    name: 'Controloc',
    mainUse: 'Treating heartburn, GERD, and stomach ulcers.',
    description:
        '**Active Ingredient:** Pantoprazole (PPI). **Usage Time:** Take once daily, usually in the morning before breakfast. **Side Effects:** Headache, diarrhea, dizziness. Long-term use requires monitoring for mineral deficiencies. **Note:** Provides relief by reducing stomach acid production.',
    imagePathNote:
        'https://cdn.chefaa.com/filters:format(webp)/public/uploads/products/controloc-antacid-20mg-14tab-01718194924.png',
    priceNote: '\$ 110.75',
    quantityPcs: '28 tabs',
  ),
  MedicineModel(
    id: 5,
    name: 'Voltaren',
    mainUse: 'Pain and inflammation relief (NSAID).',
    description:
        '**Active Ingredient:** Diclofenac. **Usage Time:** Take with or immediately after food. **Side Effects:** Gastrointestinal issues (pain, bleeding), rash, fluid retention. **Note:** Similar risks to Ibuprofen; use the lowest effective dose for the shortest duration.',
    imagePathNote:
        'https://cdn11.bigcommerce.com/s-jolu2e/images/stencil/1280x1280/attribute_rule_images/9086_source_1727661308.jpg',
    priceNote: '\$ 38.00',
    quantityPcs: '20 tabs',
  ),
  MedicineModel(
    id: 6,
    name: 'Lipitor',
    mainUse: 'Lowering high cholesterol levels.',
    description:
        '**Active Ingredient:** Atorvastatin (Statin). **Usage Time:** Usually taken once daily, often in the evening, with or without food. **Side Effects:** Muscle pain (myalgia), headache, liver enzyme elevation. **Note:** Requires regular blood tests to monitor liver function.',
    imagePathNote:
        'https://dev.spirit.com.kw/cache/large/product/1668/1741000514_40_0.webp',
    priceNote: '\$ 150.00',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 7,
    name: 'Diamicron',
    mainUse: 'Treating Type 2 Diabetes Mellitus.',
    description:
        '**Active Ingredient:** Gliclazide (Sulfonylurea). **Usage Time:** Taken with breakfast and/or main meals. **Side Effects:** Hypoglycemia (low blood sugar), weight gain. **Note:** Patients must monitor blood sugar levels and maintain regular meals.',
    imagePathNote:
        'https://www.pharmacie-de-sauternes.fr/resize/600x600/media/finish/img/normal/16/3400933814687-diamicron-60mg-lm-cpr-30.jpg',
    priceNote: '\$ 70.25',
    quantityPcs: '60 tabs',
  ),
  MedicineModel(
    id: 8,
    name: 'Cafigen',
    mainUse: 'Treating migraine and tension headaches.',
    description:
        '**Active Ingredient:** Ergotamine and Caffeine. **Usage Time:** Take immediately at the first sign of a migraine. Do not use daily. **Side Effects:** Nausea, vomiting, numbness/tingling in fingers/toes. **Note:** Not for prevention; strictly for acute treatment. Limit use to avoid rebound headaches.',
    imagePathNote:
        'https://dkud4u09qff41.cloudfront.net/Products/590ad875-2ff4-4469-b931-c868616491f6.jpeg',
    priceNote: '\$ 25.00',
    quantityPcs: '12 tabs',
  ),
  MedicineModel(
    id: 9,
    name: 'Concor',
    mainUse: 'Managing high blood pressure and angina.',
    description:
        '**Active Ingredient:** Bisoprolol (Beta-Blocker). **Usage Time:** Once daily, usually in the morning. **Side Effects:** Slow heart rate, fatigue, dizziness, cold hands/feet. **Note:** Do not stop taking abruptly, as this can worsen heart conditions. Not suitable for certain asthma types.',
    imagePathNote:
        'https://shop.marham.pk/cdn/shop/files/Concortablets2.5mg.jpg?v=1719981601&width=480',
    priceNote: '\$ 95.00',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 10,
    name: 'Buscopan',
    mainUse: 'Relieving abdominal cramps and spasms.',
    description:
        '**Active Ingredient:** Hyoscine Butylbromide (Antispasmodic). **Usage Time:** Taken as needed for cramp relief. **Side Effects:** Dry mouth, blurred vision, constipation, fast heart rate. **Note:** Should not be used if you have glaucoma or an enlarged prostate.',
    imagePathNote:
        'https://cdn11.bigcommerce.com/s-dmb1ykvg7m/images/stencil/1280x1280/products/31744/14885/Buscopan-Plus-100s__50715.1721201934.png?c=2',
    priceNote: '\$ 42.00',
    quantityPcs: '20 tabs',
  ),
  MedicineModel(
    id: 11,
    name: 'Vitrac',
    mainUse: 'Treating allergy symptoms (Antihistamine).',
    description:
        '**Active Ingredient:** Cetirizine (Second-generation antihistamine). **Usage Time:** Once daily, usually in the evening. **Side Effects:** Drowsiness (less than first-generation), dry mouth, headache. **Note:** Generally non-drowsy but use caution when driving initially.',
    imagePathNote:
        'https://indianpharmanetwork.co.in/medicines/wp-content/uploads/2025/04/Vitrakvi.webp',
    priceNote: '\$ 60.50',
    quantityPcs: '10 caps',
  ),
  MedicineModel(
    id: 12,
    name: 'Marvelon',
    mainUse: 'Oral contraception (Birth Control Pills).',
    description:
        '**Active Ingredient:** Ethinylestradiol and Desogestrel (Combined hormonal pill). **Usage Time:** Take one tablet daily, starting on the first day of the cycle. **Side Effects:** Nausea, breast tenderness, headache, mood changes. Serious risk of blood clots. **Note:** Requires consistent, daily use for effectiveness.',
    imagePathNote:
        'https://www.vinmec.com/static/uploads/small_20220219_165349_713389_thuoc_marvelon_max_1800x1800_jpg_0eb090c13d.jpg',
    priceNote: '\$ 55.00',
    quantityPcs: '21 tabs',
  ),
  MedicineModel(
    id: 13,
    name: 'Nexium',
    mainUse: 'Treating acid reflux (GERD) and stomach ulcers.',
    description:
        '**Active Ingredient:** Esomeprazole (PPI). **Usage Time:** Once daily, at least one hour before a meal. **Side Effects:** Similar to Controloc: headache, nausea, gas. **Note:** Do not crush or chew the capsule/tablet; swallow whole.',
    imagePathNote:
        'https://tdawi.com/media/webp_image/catalog/product/cache/c02fd180406f0a5f799ad7095a14ddcd/n/e/nexium_40_-_2_i9jpno1rx619cuzv.webp',
    priceNote: '\$ 120.00',
    quantityPcs: '14 caps',
  ),
  MedicineModel(
    id: 14,
    name: 'Cataflam',
    mainUse: 'Fast relief of pain and inflammation.',
    description:
        '**Active Ingredient:** Diclofenac Potassium (NSAID). **Usage Time:** Can be taken every 8 hours as needed. Better absorbed on an empty stomach for faster effect. **Side Effects:** Stomach upset, dizziness. **Note:** Rapid-acting formulation, commonly used for dental pain or acute injury.',
    imagePathNote:
        'https://www.dawadose.com/wp-content/uploads/2024/10/Cataflam-50mg-20-Tablets.webp',
    priceNote: '\$ 33.75',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 15,
    name: 'Ciprofloxacin',
    mainUse: 'Treating various bacterial infections (Antibiotic).',
    description:
        '**Active Ingredient:** Ciprofloxacin (Fluoroquinolone). **Usage Time:** Usually twice daily. Avoid taking with dairy products or antacids. **Side Effects:** Nausea, diarrhea, tendon problems (rare but serious), confusion. **Note:** Can increase sun sensitivity; use sunscreen.',
    imagePathNote:
        'https://fidson.com/wp-content/uploads/2022/09/Ciprofloxacin-500-768x768.png',
    priceNote: '\$ 65.00',
    quantityPcs: '10 tabs',
  ),
  MedicineModel(
    id: 16,
    name: 'Flumox',
    mainUse: 'Treating bacterial infections (Antibiotic).',
    description:
        '**Active Ingredient:** Flucloxacillin (Penicillin). **Usage Time:** Take 30-60 minutes before food for best absorption. **Side Effects:** Nausea, diarrhea, rash. **Note:** Tell your doctor if you have a known penicillin allergy.',
    imagePathNote:
        'https://www.eipico.com.eg/DataImages/PRDS/ImageSmall_Path16.png?timestamp=1763683200015',
    priceNote: '\$ 75.00',
    quantityPcs: '12 caps',
  ),
  MedicineModel(
    id: 17,
    name: 'Vitamin C Eff.',
    mainUse: 'Dietary supplement, boosting immunity.',
    description:
        '**Active Ingredient:** Ascorbic Acid. **Usage Time:** Dissolve in water and drink once daily. **Side Effects:** High doses may cause diarrhea or stomach upset. **Note:** Effervescent form provides quick hydration and may be gentler on the stomach.',
    imagePathNote:
        'https://lh4.googleusercontent.com/proxy/F6Tvg0cTryFm3AZZuztxHiUcbb533ir-aDwK-Emp1UeThoPySGGrnY4tRWZC7htRZgUeIsX3e8VfnspvURkqm2Ed3ofVlOLM3pVn4esPwTMToihhnXRMQAPKpfE_rR-Nmoe36iakrCg',
    priceNote: '\$ 28.50',
    quantityPcs: '10 eff. tabs',
  ),
  MedicineModel(
    id: 18,
    name: 'Amoxil',
    mainUse: 'Treating bacterial infections (Antibiotic).',
    description:
        '**Active Ingredient:** Amoxicillin (Penicillin). **Usage Time:** Can be taken with or without food, usually 2-3 times a day. **Side Effects:** Rash, diarrhea, nausea. **Note:** A common, broad-spectrum antibiotic. Complete the full course.',
    imagePathNote:
        'https://www.myvitaminstore.pk/cdn/shop/files/amoxil-250mg-100-ct-gsk-467833.jpg?v=1713777946',
    priceNote: '\$ 50.00',
    quantityPcs: '16 caps',
  ),
  MedicineModel(
    id: 19,
    name: 'Seroxat',
    mainUse: 'Treating depression and anxiety disorders (SSRI).',
    description:
        '**Active Ingredient:** Paroxetine (SSRI). **Usage Time:** Once daily, usually in the morning. **Side Effects:** Nausea, insomnia, sexual dysfunction, weight changes. **Note:** Takes several weeks to show full effect. Do not stop abruptly; gradual tapering is essential.',
    imagePathNote:
        'https://pmlive.com/wp-content/uploads/2024/02/GSK-Seroxat-paroxetine.jpg',
    priceNote: '\$ 140.00',
    quantityPcs: '30 tabs',
  ),
  MedicineModel(
    id: 20,
    name: 'Nizoral',
    mainUse: 'Treating fungal infections.',
    description:
        '**Active Ingredient:** Ketoconazole (Antifungal). **Usage Time:** Typically once daily with a meal. **Side Effects:** Nausea, vomiting. Can cause serious liver problems (rare). **Note:** Often reserved for severe fungal infections due to potential liver toxicity; requires monitoring.',
    imagePathNote:
        'https://uk2gulf.com/cdn/shop/files/51yEqR5bK5L.SS700.jpg?v=1733686146',
    priceNote: '\$ 48.00',
    quantityPcs: '10 tabs',
  ),
];

final List<MedicineModel> allNonMedicationProducts = [
  MedicineModel(
    id: 21,
    name: 'Neutrogena Hydro Boost Water Gel',
    mainUse: 'Intense facial hydration.',
    description:
        '**Key Ingredient:** Hyaluronic Acid. **Usage Time:** Apply to face and neck morning and night. **Skin Type:** Suitable for all skin types, especially dry/combination. **Note:** Non-comedogenic and oil-free.',
    imagePathNote:
        'https://images.ctfassets.net/xvcg1y2kwpfh/5DVHhZ5u2JMbNrjWA42E1q/3507dc58484b03d37f5c746687441c41/Hydro_BoostWater_Gel_Moisturiser-en-ae',
    priceNote: '\$ 99.00',
    quantityPcs: '50 ml',
  ),
  MedicineModel(
    id: 22,
    name: 'Sunscreen SPF 50+',
    mainUse: 'Broad spectrum UV protection.',
    description:
        '**Active Agents:** Zinc Oxide, Titanium Dioxide. **Usage Time:** Apply liberally 15 minutes before sun exposure; reapply every 2 hours. **Features:** Water-resistant. **Note:** Essential for daily anti-aging routine.',
    imagePathNote: 'https://m.media-amazon.com/images/I/61lS8hwARDL.jpg',
    priceNote: '\$ 88.50',
    quantityPcs: '100 ml',
  ),
  MedicineModel(
    id: 23,
    name: 'Oral-B Pro-Expert Toothpaste',
    mainUse: 'Comprehensive dental hygiene.',
    description:
        '**Active Ingredient:** Stannous Fluoride. **Usage Time:** Brush twice daily. **Benefits:** Protects against plaque, sensitivity, cavities, and gum problems. **Note:** Use a pea-sized amount for best results.',
    imagePathNote:
        'https://images-eu.ssl-images-amazon.com/images/I/71PVMZ+6TeL._AC_UL600_SR600,600_.jpg',
    priceNote: '\$ 35.00',
    quantityPcs: '75 ml',
  ),
  MedicineModel(
    id: 24,
    name: 'Digital Thermometer',
    mainUse: 'Accurate body temperature measurement.',
    description:
        '**Type:** Digital, flexible tip. **Features:** Fast reading (approx. 10 seconds), memory function. **Usage Note:** Suitable for oral, rectal, or axillary use. **Battery:** Includes long-lasting battery.',
    imagePathNote:
        'https://microsidd.com/cdn/shop/files/thermometerpeerless.jpg?v=1686760182&width=1206',
    priceNote: '\$ 75.00',
    quantityPcs: '1 pc',
  ),
  MedicineModel(
    id: 25,
    name: 'Multivitamin Formula',
    mainUse: 'General nutritional support.',
    description:
        '**Key Vitamins:** A, C, D, E, B-Complex. **Minerals:** Iron, Zinc, Calcium. **Usage Time:** Take one tablet daily with a meal. **Note:** Supports immune function and energy metabolism. Consult a doctor if pregnant.',
    imagePathNote:
        'https://gofit-eg.com/wp-content/uploads/2024/12/Organic-Nation-Vitamin-Nation-30Serv.-14242-30Tablets_1.webp',
    priceNote: '\$ 155.00',
    quantityPcs: '60 tabs',
  ),
  MedicineModel(
    id: 26,
    name: 'First Aid Kit (Basic)',
    mainUse: 'Emergency treatment for minor injuries.',
    description:
        '**Contents:** Bandages, antiseptic wipes, gauze pads, medical tape, scissors, disposable gloves. **Note:** Essential for home, car, or travel. Check expiration dates of sterile items regularly.',
    imagePathNote:
        'https://www.asmgroup.ie/wp-content/uploads/2023/09/First-Aid-Kit-Essentials-Ireland.jpg',
    priceNote: '\$ 210.00',
    quantityPcs: '1 kit',
  ),
  MedicineModel(
    id: 27,
    name: 'Dettol Antiseptic Liquid',
    mainUse: 'Disinfecting wounds and surfaces.',
    description:
        '**Active Ingredient:** Chloroxylenol. **Usage:** Dilute before applying to skin. Use undiluted for general surface cleaning. **Note:** Do not swallow. Keep away from eyes.',
    imagePathNote:
        'https://images-cdn.ubuy.com.eg/6526b8550c0f694daf1f0cb4-dettol-250-ml.jpg',
    priceNote: '\$ 55.50',
    quantityPcs: '500 ml',
  ),
  MedicineModel(
    id: 28,
    name: 'Nivea Body Lotion (Intensive)',
    mainUse: 'Deeply moisturizing dry skin.',
    description:
        '**Key Ingredient:** Almond Oil, Vitamin E. **Usage Time:** Apply daily all over the body, especially after showering. **Benefits:** Provides 48-hour moisture. **Note:** Dermatologically tested.',
    imagePathNote:
        'https://img.nivea.com/-/media/miscellaneous/media-center-items/0/e/0/f4c2f97ed87241db8a49c498e5e1ce3b-web_1010x1180_transparent_png.png',
    priceNote: '\$ 65.00',
    quantityPcs: '400 ml',
  ),
  MedicineModel(
    id: 29,
    name: 'Omron Blood Pressure Monitor',
    mainUse: 'Home monitoring of blood pressure.',
    description:
        '**Type:** Automatic upper arm monitor. **Features:** Easy-to-read display, hypertension indicator, memory storage. **Note:** Essential for individuals managing high blood pressure. Follow instructions carefully.',
    imagePathNote:
        'https://m.media-amazon.com/images/I/71eSP8Sf-eL._AC_SL1500_.jpg',
    priceNote: '\$ 450.00',
    quantityPcs: '1 pc',
  ),
  MedicineModel(
    id: 30,
    name: 'Gillette Mach 3 Razor',
    mainUse: 'Smooth and close shaving.',
    description:
        '**Features:** 3 blades, lubrication strip, microfins. **Usage Note:** Use with shaving gel/foam for best results and reduced irritation. **Note:** Replace blade cartridge when the lubricant strip fades.',
    imagePathNote:
        'https://i5.walmartimages.com/seo/Gillette-Mach3-Men-s-Razor-Handle-and-1-Blade-Refill_32a21fb5-4cf8-44b3-89da-12154004a8d7.3792f60895d5dfbea66d9bad192ddf7c.jpeg',
    priceNote: '\$ 70.00',
    quantityPcs: '1 handle + 2 cartridges',
  ),
  MedicineModel(
    id: 31,
    name: 'Cetaphil Gentle Skin Cleanser',
    mainUse: 'Daily cleansing for sensitive skin.',
    description:
        '**Key Feature:** Soap-free, fragrance-free formula. **Usage Time:** Use morning and night. Can be used with or without water. **Skin Type:** Ideal for dry, sensitive, and compromised skin. **Note:** Non-foaming.',
    imagePathNote:
        'https://i5.walmartimages.com/seo/Cetaphil-Gentle-Skin-Cleanser-for-Dry-to-Normal-Sensitive-Skin-8-oz_1107006b-abdd-4346-8491-f0d32776a497.141bd3fe59f1542e9a9b23b175340c62.jpeg',
    priceNote: '\$ 105.00',
    quantityPcs: '250 ml',
  ),
  MedicineModel(
    id: 32,
    name: 'Calcium + Vitamin D Tablets',
    mainUse: 'Bone health and mineral supplementation.',
    description:
        '**Active Ingredients:** Calcium Carbonate, Cholecalciferol (Vitamin D3). **Usage Time:** Take 1-2 tablets daily with food. **Benefits:** Supports bone density and muscle function. **Note:** Vitamin D aids in Calcium absorption.',
    imagePathNote:
        'https://www.nutrifactor.com.pk/cdn/shop/files/Bonex-D-60-New.png?v=1717676140',
    priceNote: '\$ 80.00',
    quantityPcs: '60 tabs',
  ),
  MedicineModel(
    id: 33,
    name: 'Baby Diapers (Size 4)',
    mainUse: 'Infant hygiene and containment.',
    description:
        '**Weight Range:** 7-18 kg. **Features:** Leak-proof barriers, wetness indicator, soft materials. **Note:** Change immediately when soiled to prevent diaper rash. Hypoallergenic material.',
    imagePathNote:
        'https://cdn.mafrservices.com/pim-content/EGY/media/product/644069/1737020515/644069_main.jpg?im=Resize=376',
    priceNote: '\$ 180.00',
    quantityPcs: '58 pcs',
  ),
  MedicineModel(
    id: 34,
    name: 'Vicks VapoRub',
    mainUse: 'Relief from cold and cough symptoms.',
    description:
        '**Active Ingredients:** Camphor, Menthol, Eucalyptus Oil. **Usage:** Rub onto the chest and throat up to three times daily. **Note:** For external use only. Not recommended for children under 2 years.',
    imagePathNote:
        'https://cloudinary.images-iherb.com/image/upload/f_auto,q_auto:eco/images/vks/vks00361/y/47.jpg',
    priceNote: '\$ 40.00',
    quantityPcs: '50 g',
  ),
  MedicineModel(
    id: 35,
    name: 'Band-Aid (Assorted Sizes)',
    mainUse: 'Covering and protecting minor cuts and scrapes.',
    description:
        '**Material:** Flexible fabric, sterile padding. **Features:** Strong adhesive, breathable. **Usage Note:** Clean the wound thoroughly before applying the bandage. Change daily or when wet.',
    imagePathNote:
        'https://i5.walmartimages.com/seo/BAND-AID-Flexible-Fabric-Adhesive-Bandages-Assorted-100-ea_c72d9b2d-a7f5-4d88-b7b6-62160477fa42.89f9b9c145ba1d08ff83e446ee2e5bc5.jpeg',
    priceNote: '\$ 22.00',
    quantityPcs: '40 pcs',
  ),
  MedicineModel(
    id: 36,
    name: 'Elastoplast Knee Support',
    mainUse: 'Support for joint pain and minor strains.',
    description:
        '**Material:** Breathable, elastic fabric. **Size:** Medium/Large. **Benefits:** Provides compression and warmth. **Note:** Consult a physiotherapist for severe or persistent pain.',
    imagePathNote:
        'https://images-us.eucerin.com/~/media/hansaplast/local/gb/sports/performance/knee/ep%20%20performance%20knee%20support%201%20product%20zoom.png?rx=0&ry=0&rw=2400&rh=2400&hash=A41A48C20AE1DE8C51CAC882B4531138',
    priceNote: '\$ 130.00',
    quantityPcs: '1 pc',
  ),
  MedicineModel(
    id: 37,
    name: 'Listerine Mouthwash',
    mainUse: 'Reducing plaque and freshening breath.',
    description:
        '**Active Ingredients:** Eucalyptol, Menthol, Thymol. **Usage Time:** Rinse for 30 seconds twice a day after brushing. **Flavor:** Cool Mint. **Note:** Use as an adjunct to brushing and flossing, not a replacement.',
    imagePathNote:
        'https://images.ctfassets.net/b7vjv6cc1lvj/2RT3sVVEHUQVqifcEapM4T/0bf021e57d29b91525794e84853b1287/LIS_5010123730222_EMEA_UK_LISTOTALCARE_500ML_000.jpg?fm=webp&w=3840',
    priceNote: '\$ 49.00',
    quantityPcs: '500 ml',
  ),
  MedicineModel(
    id: 38,
    name: 'Electric Hot Water Bottle',
    mainUse: 'Providing targeted heat therapy for muscle aches.',
    description:
        '**Features:** Pre-filled, heats up quickly, retains heat for several hours. **Safety:** Automatic shut-off mechanism. **Note:** More convenient and safer than traditional rubber bottles. Do not use near water.',
    imagePathNote:
        'https://static.coolgift.com/media/cache/sylius_shop_product_large_thumbnail/product/Electric-Watter-Bottle-11.jpg',
    priceNote: '\$ 160.00',
    quantityPcs: '1 pc',
  ),
  MedicineModel(
    id: 39,
    name: 'Biotin 10000 mcg',
    mainUse: 'Supplement for hair, skin, and nail health.',
    description:
        '**Active Ingredient:** Biotin (Vitamin B7). **Usage Time:** Take one capsule daily with food. **Note:** Can help strengthen brittle nails and promote hair growth. Consult a doctor before starting new supplements.',
    imagePathNote:
        'https://f.nooncdn.com/p/pnsku/N22355690A/45/_/1730107037/cdf56cdb-500c-462a-ad70-394a7a6fe63f.jpg?width=1200',
    priceNote: '\$ 115.00',
    quantityPcs: '90 caps',
  ),
  MedicineModel(
    id: 40,
    name: 'Hand Sanitizer Gel',
    mainUse: 'Instant hand hygiene without water.',
    description:
        '**Active Ingredient:** 70% Ethyl Alcohol. **Usage:** Apply a palmful and rub hands together thoroughly until dry. **Note:** Effective against most common germs. Keep away from flames.',
    imagePathNote:
        'https://media.hedeya.com/catalog/product/cache/f1cdd4da9872aaaed51e8dc026e80748/c/b/cbcda52f-d4d2-49e2-8eaa-9c8620bfcce7-2.jpg',
    priceNote: '\$ 28.00',
    quantityPcs: '100 ml',
  ),
];
