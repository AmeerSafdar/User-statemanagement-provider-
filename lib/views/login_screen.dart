// ignore_for_file: use_build_context_synchronously

import 'package:apploginfirebase/providers/user_provider.dart';
import 'package:apploginfirebase/utils/const.dart';
import 'package:apploginfirebase/views/signup_screen.dart';
import 'package:apploginfirebase/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _passwordControler = TextEditingController();
  final _formGlobalKey=GlobalKey<FormState>();
  

    @override
  void dispose() {
    super.dispose();
    _emailControler.dispose();
    _passwordControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Form(
              key:  _formGlobalKey,
              child: Column(
                children: [
                  TextFieldWidget(
                    hintText: 'Email',
                    textEditingController: _emailControler,
                   validator: ((value) {
                          if (!regex.hasMatch(value!))
                            { 
                              return 'Enter Valid Email';
                              }
                          else{
                           return null;
                          }
                  }
                   )
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  
                  TextFieldWidget(
                    hintText: 'Password',
                    textEditingController: _passwordControler,
                    validator: ((value) {
                          if (value.toString().length<6)
                            { 
                              return 'password must contain 6 letters';
                            }
                           else
                              {
                                return null;
                              }
                  }
                  )
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Consumer<UserProvider>(builder: (context,val,child){
                    return ElevatedButton(
                    onPressed:(){
                      if (_formGlobalKey.currentState!.validate()){
                        val.loginUser(_emailControler.text, _passwordControler.text,context);
                        
                                             } }, 
                    child:val.onLoading == false ? Text('login') : CircularProgressIndicator(color: Colors.white,)
                    );
                  }),
                  
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton
                      (
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                        }, child:const Text('Sign Up?'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}