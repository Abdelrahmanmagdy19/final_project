import 'package:cure_link/models/cubits/top_doctor_cubit/top_doctor_cubit_state.dart';
import 'package:cure_link/models/model/doctors_details_model.dart';
import 'package:cure_link/services/get_data_from_firebase_top_doctor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopDoctorCubit extends Cubit<TopDoctorCubitState> {
  final GetDataFromFirebaseTopDoctor _service = GetDataFromFirebaseTopDoctor();
  TopDoctorCubit() : super(TopDoctorCubitInitial());
  Future<void> fetchTopDoctors() async {
    emit(TopDoctorCubitLoading());
    try {
      final List<DoctorsDetailsModel> doctors = await _service
          .fetchTopDoctors();
      emit(TopDoctorCubitSuccess(doctors: doctors));
    } catch (e) {
      emit(TopDoctorCubitFailure(e.toString()));
    }
  }
}
