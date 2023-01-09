// ignore_for_file: use_build_context_synchronously

import 'package:apploginfirebase/providers/user_provider.dart';
import 'package:apploginfirebase/utils/const.dart';
import 'package:apploginfirebase/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _firstNameControler = TextEditingController();
  final TextEditingController _lastNameControler = TextEditingController();
  final TextEditingController _passwordControler = TextEditingController();
  final _formGlobalKey=GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailControler.dispose();
    _passwordControler.dispose();
    _firstNameControler.dispose();
    _lastNameControler.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Form(
              key: _formGlobalKey,
              child: Column(
                children: [
                  TextFieldWidget(
                    hintText: 'First Name',
                    textEditingController: _firstNameControler,
                    validator: ((value) {
                        if (value!.isNotEmpty) {
                          return null;
                        }
                        else{
                          return 'Name must contain a value';
                        }
                      }),
                  ),
                  TextFieldWidget(
                    hintText: 'Last',
                    textEditingController: _lastNameControler,
                    validator: ((value) {
                        if (value!.isNotEmpty) {
                          return null;
                        }
                        else{
                          return 'Name must contain a value';
                        }
                      }),
                  ),
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

                  Consumer<UserProvider>(
                    builder: (context, val, child){
                      return ElevatedButton(
                    onPressed:(){
                      if (_formGlobalKey.currentState!.validate()){
                        val.setUserData(_firstNameControler.text, _lastNameControler.text, _emailControler.text, _passwordControler.text,context);

                       } }, 
                    child:val.onLoading == false ? Text('Signup') : CircularProgressIndicator(color: Colors.white,)
                    );

                    } )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}