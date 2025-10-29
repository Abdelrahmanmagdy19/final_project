// في ملف: doctors_details_model.dart

class DoctorsDetailsModel {
  final String? image;
  final String? name;
  final String? specialty;
  final double? totalRating;
  final double? experience;
  final String? about;
  final String? price;

  DoctorsDetailsModel({
    this.image,
    this.name,
    this.specialty,
    this.totalRating,
    this.experience,
    this.about,
    this.price,
  });

  factory DoctorsDetailsModel.fromFirestore(Map<String, dynamic> firestoreMap) {
    return DoctorsDetailsModel(
      image: firestoreMap['imageUrl'] as String?,
      name: firestoreMap['name'] as String?,
      specialty: firestoreMap['specialization'] as String?,
      totalRating: (firestoreMap['totalRating'] as num?)?.toDouble(),
      experience: (firestoreMap['experience'] as num?)?.toDouble(),
      about: firestoreMap['about'] as String?,
      price: firestoreMap['price'] as String?,
    );
  }
}
