import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro4/screens/HomeScreen.dart';
import 'package:pro4/screens/SignInScreen.dart';
import 'package:pro4/wights/CustomTextfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          // color: Colors.red,
          child: Form(
            key: formKey,
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
                Text("Create Account",style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                const SizedBox(height: 5,),
                Text("Sign up to get started with our app",style: TextStyle(color: Colors.black54),),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      CustomTextfield(
                        controller: _nameController,
                        hintText: "Full Name",
                        prefixIcon: Icons.person_outline,
                        validator: (p0) {
                          if(p0 == null){
                            return "Name can't be empty";
                          }
                          return p0.length <= 3 ? "Name can't be shorter than 3 characters " : null;
                        },
                      ),
                      const SizedBox(height: 12,),
                      CustomTextfield(
                        controller: _emailController,
                        hintText: "Email",
                        prefixIcon: Icons.email_outlined,
                        validator: (p0) {
                          if(!p0!.contains("@gmail.com")){

                          }
                        },
                      ),
                      const SizedBox(height: 12,),
                      CustomTextfield(
                        controller: _passwordController,
                        isHidden: true,
                        hintText: "Password",
                        prefixIcon: Icons.lock_outline,
                        validator: (p0) {

                        },
                      ),
                      const SizedBox(height: 12,),
                      CustomTextfield(
                        controller: _confirmPasswordController,
                        hintText: "Confirm Password",
                        isHidden: true,
                        prefixIcon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 20,),
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
                              final isValid = formKey.currentState!.validate();
                              if(isValid){
                                //Create user
                                // FirebaseA
                                try{
                                  final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text
                                  );
                                  await user.user!.updateDisplayName(_nameController.text);
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()),(route) => false);
                                }catch(error){
                                  print("error creating user");
                                  print(error.toString());
                                }

                                //Navigate
                              }
                            },
                            child: Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold),)
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    TextButton(onPressed: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> SignInScreen()),(predicate) => false);
                    },
                        child: Text("Sign In",style: TextStyle(fontWeight: FontWeight.bold),))
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