import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro4/screens/HomeScreen.dart';
import 'package:pro4/screens/SignInScreen.dart';
import 'package:pro4/screens/SignupScreen.dart';
import 'package:pro4/wights/CustomTextfield.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          // color: Colors.red,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40,),
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.deepPurple,
                  size: 95,
                ),
                const SizedBox(height: 8,),
                Text("Sign In",style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                const SizedBox(height: 5,),
                Text("Sign in to get started with our app",style: TextStyle(color: Colors.black54),),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      CustomTextfield(
                        controller: _emailController,
                        hintText: "Email",
                        prefixIcon: Icons.person_outline,
                        validator: (p0) {
                          if(p0 == null || p0.isEmpty){
                            return "Email can't be empty";
                          }
                          if(!p0.contains("@gmail.com")){
                            return "Email must contain @gmail.com";
                          }
                          return p0.length <= 6 ? "Email can't be shorter than 6 characters " : null;

                        },
                      ),
                      const SizedBox(height: 12,),
                      CustomTextfield(
                        controller: _passwordController,
                        hintText: "Password",
                        prefixIcon: Icons.email_outlined,
                        validator: (p0) {
                          if(p0 == null || p0.isEmpty){
                            return "Password can't be empty";
                          }
                          return p0.length <= 6 ? "Password can't be shorter than 6 characters " : null;
                        },
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: WidgetStatePropertyAll(0),
                                backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
                                foregroundColor: WidgetStatePropertyAll(Colors.white),
                                padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
                            ),
                            onPressed: ()async{
                              final isValid = _formKey.currentState!.validate();
                              if(isValid){
                                try{
                                  final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text
                                  );
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) {
                                    return HomeScreen();
                                  },), (route) => false);
                                }on FirebaseAuthException catch (e){
                                  print(e.code);

                                  if(e.code == "invalid-credential"){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Invalid credentials"))
                                    );
                                  }
                                }
                                catch(e){
                                  print(e.toString());
                                }
                              }
                            },
                            child: Text("Sign In",style: TextStyle(fontWeight: FontWeight.bold),)
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(onPressed: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> SignupScreen()), (route) => false);
                    },
                        child: Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}