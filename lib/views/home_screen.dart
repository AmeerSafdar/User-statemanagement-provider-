// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables


import 'package:apploginfirebase/providers/user_provider.dart';
import 'package:apploginfirebase/utils/const.dart';
import 'package:apploginfirebase/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _emailControler=TextEditingController();
  final TextEditingController _firstNameControler=TextEditingController();
  final TextEditingController _lastNameControler=TextEditingController();
  final _formGlobalKey=GlobalKey<FormState>();
 
@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<UserProvider>(context,listen: false).getUserData();
  });
  }
  
  @override
  Widget build(BuildContext context) {
    var use_pro= Provider.of<UserProvider>(context,listen: true);
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    
    return Scaffold(
      appBar: AppBar(
             actions: [
          IconButton(
            onPressed: (){
             Future.delayed(Duration.zero,(() {
                return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Do you want to logout?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async{
                        userProvider.signOut(context);
                        },
                      child: Container(
                        color: Colors.blue,
                        padding: const EdgeInsets.all(14),
                        child: const Text("Yes" ,style: TextStyle(color: Colors.white),),
                      ),
                    ),
                     TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(14),
                        child: const Text("No"),
                      ),
                    ),
                  ],
                ),
              );
             }));
          }, icon: const Icon(
            Icons.logout
          ))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Form(
              key: _formGlobalKey,
              child: Column(
                  children: [
                    
             TextFieldWidget(
                    read_only: userProvider.read_only,
                    hintText: 'First Name', 
                    textEditingController: _firstNameControler..text=userProvider.firsName ??' ', 
                    validator: ((value) {
                              if (value!.isNotEmpty) {
                                return null;
                              }
                              else{
                                return 'Name must contain a value';
                              }
                            }),),
                

                TextFieldWidget(
                    hintText: 'Last Name', 
                    read_only: userProvider.read_only,
                    textEditingController: _lastNameControler..text=userProvider.lastName ?? ' ', 
                    validator: ((value) {
                              if (value!.isNotEmpty) {
                                return null;
                              }
                              else{
                                return 'Name must contain a value';
                              }
                            }),),

               
                          TextFieldWidget(
                                read_only: userProvider.read_only,
                          hintText: 'Email',
                          textEditingController: _emailControler..text= userProvider.email ?? ' ',
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
                    height: 10,
                  ),

                    Consumer<UserProvider>(builder:(context, value, child) {
                    return  Visibility(
                    visible: value.read_only,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                      onPressed: (){
                        use_pro.getUserData();
                        value.editableTextField();
                      }, 
                      child: const Text('Edit')),
                    ),
                  );
                    },),

                  const SizedBox(
                    height: 10,
                  ),
                          
                   Consumer<UserProvider>(builder: (context, value, child) {
                     return Visibility(
                    visible:value.writable,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                      onPressed: (){
                        if (_formGlobalKey.currentState!.validate()) {
                            use_pro.getUserData();
                              value.nonEditableTextField();
                               value.updateData(
                              _emailControler.text,
                              _firstNameControler.text,
                              _lastNameControler.text,
                            FirebaseAuth.instance.currentUser!.uid
                             );
                               }
                      }, 
                      child: const Text('Done')),
                    ),
                  );
                   },)
                  ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}