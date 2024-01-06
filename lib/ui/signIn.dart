import 'package:flutter/material.dart';
import 'package:google_mao/api/user_api.dart';
import 'package:google_mao/components/constants.dart';
import 'package:google_mao/models/login.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:google_mao/ui/home_screen.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
   const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final UserApiService userService=UserApiService();
   final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  
  bool _isObscure = true;
  bool isLoading=false;

   @override
     void initState(){
     super.initState();
     isLoading=false;
    // _emailController = TextEditingController();
  //  _passwordController = TextEditingController();
   }

  
  @override
  void dispose() {
    try{
    _emailController.dispose();
    _passwordController.dispose();
    isLoading=false;
    }catch(err){
      print(err);
    }
    super.dispose();
  }
    void setLoad(bool val){
    setState((){
        isLoading=val;
    });
    }
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MeterPro'),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width > 280 ? 30 : 16
                    ),
                  // padding: null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20,),
          
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.pink,
                          fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                     
          
                     TextField(
                      obscureText: _isObscure,
                      controller: _passwordController,
                      style:const TextStyle(letterSpacing: 2),
                      decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.pink,
                          fontSize:16,fontWeight: FontWeight.bold ),
                    
                      suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      child: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
          
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        style:ElevatedButton.styleFrom(
                        backgroundColor:violetColor,
                        shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))
                        ),
                        onPressed: () {
                          //  String username = _emailController.text;
                            // String password = _passwordController.text;
  
                          setLoad(true);
                          // Login user=Login(username: username,password: password);
                          Login user=Login(username: "Abishek",password: "Abishek123");

                          userService.LoginUser(user).then((value) {
                            if(value.token!=""){
                            Provider.of<StateProvider>(context,listen:false).setToken(value);
                              setLoad(false);
                            Navigator.of(context).canPop()?
                              Navigator.pop(context, true):
                              Navigator.pushReplacement(
                                context,MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                            }
                            else{
                              setLoad(false);
                              print("login Fail");
                            }
                          });
                          
                
                          },
                        child: const Text('Sign In',style: TextStyle(fontSize: 18,color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if(isLoading)
          Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
