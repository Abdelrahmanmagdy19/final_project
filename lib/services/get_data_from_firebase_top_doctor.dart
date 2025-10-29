import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/models/model/doctors_details_model.dart';

class GetDataFromFirebaseTopDoctor {
  Future<List<DoctorsDetailsModel>> fetchTopDoctors() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .get();

      List<DoctorsDetailsModel> doctorsList = querySnapshot.docs.map((doc) {
        return DoctorsDetailsModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
        );
      }).toList();

      return doctorsList;
    } catch (e) {
      throw Exception('Failed to load top doctors: ${e.toString()}');
    }
  }
}
