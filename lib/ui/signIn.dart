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
   late final TextEditingController _emailController;

  late final TextEditingController _passwordController;
  
  bool _isObscure = true;

   @override
     void initState(){
     super.initState();
    _emailController = TextEditingController();
   _passwordController = TextEditingController();
   }

  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MeterPro'),
      ),
      body: Center(
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
                 
                  // TextField(
                  //   controller: _passwordController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Password',
                  //      labelStyle: TextStyle(color: Colors.pink,
                  //     fontSize:16 ),
                  //   ),
                  //   obscureText: true, // for password fields
                  // ),

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
                    //#355723,#ff814b,#f85f6a, #feeeef
                    // green  Color(0xFF355723)  new - #355723
                    //orange #ff8d5c  new - #ff814b
                    //pink #f85f6a
                    //pink light #feeeef
                    style:ElevatedButton.styleFrom(
                    backgroundColor:violetColor,
                    shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))
                    ),
                    // decoration:BorderRadius(0),
                    onPressed: () {
                      // Implement sign-in logic here
                      String username = _emailController.text;
                      String password = _passwordController.text;
                      Login user=Login(username: username,password: password);
                      userService.LoginUser(user).then((value) {
                        Provider.of<StateProvider>(context,listen:false).setToken(value);
                        Navigator.of(context).canPop()?
                          Navigator.pop(context, true):
                          Navigator.pushReplacement(
                            context,MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
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
    );
  }
}
