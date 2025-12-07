import 'package:cure_link/cubits/login_sigin_cubits/login_sigin_cubits.dart';
import 'package:cure_link/cubits/profile_cubits/profile_cubit.dart';
import 'package:cure_link/cubits/favorites_cubits/favorites_cubits_.dart';
import 'package:cure_link/shared/navigation/auth_redirector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FavoritesCubits()),
        BlocProvider(create: (context) => LoginSiginCubits()),
        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: const CureLink(),
    ),
  );
}

class CureLink extends StatelessWidget {
  const CureLink({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthRedirector(),
    );
  }
}
