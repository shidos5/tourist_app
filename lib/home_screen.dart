import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/bloc/auth/auth_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          SizedBox(height: 150),
          Center(child: Text("Home Screen")),
          Center(
            child: ElevatedButton(onPressed: (){
              context.read<AuthCubit>().signOut();
            }, child: Text("Logout")),
          )
        ],
      ),
    );
  }
}