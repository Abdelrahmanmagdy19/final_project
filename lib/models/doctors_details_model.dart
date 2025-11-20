class DoctorsDetailsModel {
  final String? image;
  final String? name;
  final String? specialty;
  final double? totalRating;
  final double? experience;
  final String? about;
  final String? price;
  final String? email;
  final String? uid; // إضافة معرف فريد للطبيب

  DoctorsDetailsModel({
    this.image,
    this.name,
    this.specialty,
    this.totalRating,
    this.experience,
    this.about,
    this.price,
    this.uid,
    this.email,
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
      email: firestoreMap['email'] as String?,
      uid: firestoreMap['uid'] as String?,
    );
  }
}
