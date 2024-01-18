import 'package:flutter/material.dart';
import 'package:google_mao/api/user_api.dart';
import 'package:google_mao/components/constants.dart';
import 'package:google_mao/models/login.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:google_mao/ui/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationWrapper extends StatelessWidget {
  // const AuthenticationWrapper({super.key});
late StateProvider myProvider;
  @override
  Widget build(BuildContext context) {
  myProvider=Provider.of<StateProvider>(context,listen:false);
    return FutureBuilder(
      // Check if the user is authenticated
      future: isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the Future is still running, show a loading indicator
          return CircularProgressIndicator();
        } else {
          if(snapshot.data == true){

          }
          return snapshot.data == true ?  HomeScreen():SignInPage();
        }
      },
    );
  }
  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList('token');
    myProvider.setToken(UserDetail(firstname: items![0], lastname:items![1] , token: items![2]));
    if(items?.length==0 || items==null){
      return false;
    }
    else{
    return true;
    }
  }
}

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
                          //   String password = _passwordController.text;
  
                          setLoad(true);
                          // Login user=Login(username: username,password: password);
                          Login user=Login(username: "Abishek",password: "Abishek123");

                          userService.LoginUser(user).then((value) async {
                            if(value.token!=""){
                            Provider.of<StateProvider>(context,listen:false).testing(value.token);  
                            Provider.of<StateProvider>(context,listen:false).setToken(value);
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setStringList('token', <String>[value.firstname, value.lastname, value.token]);
                              setLoad(false);
                            Navigator.of(context).canPop()?
                              Navigator.pop(context, true):
                              Navigator.pushReplacement(
                                context,MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                            }
                            else{
                              setLoad(false);  
                                _displayMessage(context, 'Login Failed', const Duration(seconds: 3));                            
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

 void _displayMessage(BuildContext context, String message, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }