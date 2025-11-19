import 'package:cloud_firestore/cloud_firestore.dart';

class UserRoleService {
  final FirebaseFirestore _firestore;

  UserRoleService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _roleCollection = 'user_roles';

  Future<String> fetchUserRole(String uid) async {
    try {
      // Fast path: dedicated user_roles document.
      final roleDoc =
          await _firestore.collection(_roleCollection).doc(uid).get();
      if (roleDoc.exists) {
        final role = roleDoc.data()?['role'] as String?;
        if (role != null && role.isNotEmpty) {
          return role;
        }
      }

      // Fallback order based on existing collections structure.
      final doctorDoc =
          await _firestore.collection('doctors').doc(uid).get();
      if (doctorDoc.exists) {
        final role = doctorDoc.data()?['role'] as String?;
        return role ?? 'doctor';
      }

      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final role = userDoc.data()?['role'] as String?;
        return role ?? 'patient';
      }

      final pharmacyDoc =
          await _firestore.collection('pharmacies').doc(uid).get();
      if (pharmacyDoc.exists) {
        final role = pharmacyDoc.data()?['role'] as String?;
        return role ?? 'pharmacy';
      }

      final hospitalDoc =
          await _firestore.collection('hospitals').doc(uid).get();
      if (hospitalDoc.exists) {
        final role = hospitalDoc.data()?['role'] as String?;
        return role ?? 'hospital';
      }
    } catch (e) {
      // Intentionally swallow errors to avoid blocking login;
      // actual error handling happens upstream.
    }

    return 'patient';
  }

  Future<void> persistUserRole(String uid, String role) async {
    await _firestore.collection(_roleCollection).doc(uid).set({
      'uid': uid,
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

