import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/bloc/auth/auth_cubit.dart';
import 'package:tourist_app/home_screen.dart';
import 'package:tourist_app/ui/color/app_colors.dart';
import 'package:tourist_app/ui/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String? emailError;
  String? passError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayLight,
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state is AuthError) {
            
            setState(() {
              emailError = null;
              passError = null;

              if (state.message.contains("email")) {
                emailError = state.message;
              } else if (state.message.contains("password")) {
                passError = state.message;
              } else {
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message),backgroundColor: AppColors.success,),
                );
              }
            });
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Log in to start your journey!",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800,color: AppColors.secondary),),
                const SizedBox(height: 30),

                // Email Field
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    suffix: const Icon(Icons.email_outlined,color: AppColors.primary,                         ),
                    labelText: "Email",
                    errorText: emailError,
                    border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary), 
                    borderRadius: BorderRadius.circular(8),
                    )
                  ),
                ),

                const SizedBox(height: 20),

                // Password Field
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffix: const Icon(Icons.lock_outline,color: AppColors.primary,),
                    errorText: passError, 
                    border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(8)
                    )
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  
                  children: [
                    const Text("Don't have account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                      },
                      child: const Text("register",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.secondary),),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        emailError = null;
                        passError = null;
                      });
                  
                      context.read<AuthCubit>().signUp(
                            emailCtrl.text.trim(),
                            passCtrl.text.trim(),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      
                    ),
                    child:  Text("Register", style: TextStyle(color: AppColors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
