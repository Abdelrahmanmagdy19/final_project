import 'package:cure_link/firebase_options.dart';
import 'package:cure_link/models/cubits/login_sigin_cubits/login_sigin_cubits.dart';
import 'package:cure_link/screens/home_onboarding_screen/home_boarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => LoginSiginCubits())],
      child: const CureLink(),
    ),
  );
}

class CureLink extends StatelessWidget {
  const CureLink({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeOnBoardingScreen(),
    );
  }
}
