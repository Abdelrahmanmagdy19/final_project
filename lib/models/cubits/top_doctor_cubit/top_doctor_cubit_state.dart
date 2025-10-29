import 'package:cure_link/models/model/doctors_details_model.dart';

class TopDoctorCubitState {}

class TopDoctorCubitInitial extends TopDoctorCubitState {}

class TopDoctorCubitLoading extends TopDoctorCubitState {}

class TopDoctorCubitSuccess extends TopDoctorCubitState {
  final List<DoctorsDetailsModel> doctors;
  TopDoctorCubitSuccess({required this.doctors});
}

class TopDoctorCubitFailure extends TopDoctorCubitState {
  final String errorMessage;
  TopDoctorCubitFailure(this.errorMessage);
}
