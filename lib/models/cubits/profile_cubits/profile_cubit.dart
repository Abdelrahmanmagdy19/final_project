import 'dart:developer';

import 'package:cure_link/models/model/user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final List<String> _collectionsToSearch = [
    'doctors',
    'pharmacies',
    'hospitals',
    'users',
  ];

  Future<void> fetchProfileData() async {
    emit(ProfileLoading());

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(ProfileError('User is not logged in.'));
      return;
    }

    final String uid = user.uid;
    UserProfile? foundProfile;

    try {
      for (String collectionName in _collectionsToSearch) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(uid)
            .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;

          foundProfile = UserProfile(
            uid: uid,
            name: data['name'] ?? 'اسم غير محدد',
            imageUrl:
                data['imageUrl'] ??
                'https://via.placeholder.com/150?text=Profile',
            role: collectionName,
          );
          break;
        }
      }

      if (foundProfile != null) {
        emit(ProfileLoaded(foundProfile));
      } else {
        emit(
          ProfileError('Profile not found for this user in any collection.'),
        );
      }
    } catch (e) {
      emit(ProfileError('Failed to fetch data: ${e.toString()}'));
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      emit(ProfileInitial());
    } catch (e) {
      log('Logout failed: $e');
    }
  }
}
