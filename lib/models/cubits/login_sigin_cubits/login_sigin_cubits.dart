import 'package:cure_link/models/cubits/login_sigin_cubits/login_sigin_cubits_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginSiginCubits extends Cubit<LoginSiginCubitsState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LoginSiginCubits() : super(LoginSiginCubitsInitial());

  Future<void> loginWitheFirebase(String email, String password) async {
    emit(LoginSiginCubitsLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        emit(LoginSiginCubitsSuccess(userCredential.user));
      } else {
        emit(LoginSiginCubitsFailure('Sign-in failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginSiginCubitsFailure(e.message ?? 'Authentication error'));
    } catch (e) {
      emit(LoginSiginCubitsFailure(e.toString()));
    }
  }

  Future<void> registerWithFirebase(
    String name,
    String email,
    String password,
    String imageUrl,
    String role,
    String specialization,
    String experience,
    String about,
    String price,
  ) async {
    emit(LoginSiginCubitsLoading());

    try {
      // 1. Create user in Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        // 2. Update display name in Firebase Auth
        await user.updateDisplayName(name);

        // 3. Prepare data and save to appropriate Firestore Collection
        try {
          Map<String, dynamic> baseData = {
            'uid': user.uid,
            'name': name,
            'email': email,
            'role': role,
            'createdAt': FieldValue.serverTimestamp(),
            'imageUrl': imageUrl,
          };

          String collectionPath;

          if (role == 'doctor') {
            int yearsExperience = int.tryParse(experience) ?? 0;

            baseData.addAll({
              'specialization': specialization,
              'experience': yearsExperience,
              'about': about,
              'price': price,
              'totalRating': 0,
              'numRatings': 0,
              'averageRating': 0.0,
            });
            collectionPath = 'doctors';
          } else if (role == 'pharmacy') {
            collectionPath = 'pharmacies';
          } else if (role == 'hospital') {
            collectionPath = 'hospitals';
          } else {
            // Default to 'users' collection for regular users
            collectionPath = 'users';
          }

          await _firestore
              .collection(collectionPath)
              .doc(user.uid)
              .set(baseData);
        } catch (e) {
          // If Firestore write fails, delete the Auth user
          await user.delete();
          emit(
            LoginSiginCubitsFailure(
              'Database Error. Check Firestore Rules. Details: ${e.toString()}',
            ),
          );
          return;
        }

        await user.reload();

        emit(LoginSiginCubitsSuccess(_auth.currentUser));
      } else {
        emit(
          LoginSiginCubitsFailure('Registration failed: User object is null.'),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Authentication errors (e.g., email already in use)
      emit(LoginSiginCubitsFailure(e.message ?? 'Registration error'));
    } catch (e) {
      // Handle general errors
      emit(LoginSiginCubitsFailure('Registration failed: ${e.toString()}'));
    }
  }
}
